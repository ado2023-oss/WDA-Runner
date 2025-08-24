#!/bin/bash

# --------------------------------------------
# 用户配置区域：使用前必须修改这些变量！
# --------------------------------------------

# 你的 IPA 文件路径
ORIGINAL_IPA="WebDriverAgent.ipa"

# 签名证书名称
# 在钥匙串访问中查看，例如 "iPhone Developer: John Doe (ABCDE12345)" 或 "Apple Distribution: Company Ltd. (XYZ1234567)"
SIGNING_CERTIFICATE="Apple Development: John Doe (ABCDE12345)"

# 新的配置文件 (.mobileprovision) 路径
# 确保这个配置文件的 Bundle ID 与你的主应用匹配，并且包含了所有需要签名的插件的 Bundle ID。
PROVISIONING_PROFILE="WebDriverAgent.mobileprovision"

# 解压和工作的临时目录（脚本结束后不会自动删除，以便你检查）
WORK_DIR="./ResignedIPA"

# --------------------------------------------
# 主脚本开始，一般情况下无需修改 below
# --------------------------------------------

set -e # 如果任何命令失败，则退出脚本

echo "🚦 开始重签名流程..."
echo "📦 原始 IPA: $ORIGINAL_IPA"

# 清理并创建临时工作目录
rm -rf "$WORK_DIR"
mkdir -p "$WORK_DIR"
echo "📁 工作目录创建于: $WORK_DIR"

# 步骤 1: 解压 IPA
echo "📂 正在解压 IPA..."
unzip -q "$ORIGINAL_IPA" -d "$WORK_DIR"

# 步骤 2: 定位 .app 包
APP_BUNDLE=$(find "$WORK_DIR" -name "*.app" -type d | head -n 1)
if [ -z "$APP_BUNDLE" ]; then
    echo "❌ 错误：在 IPA 中找不到 .app 包"
    exit 1
fi
echo "🎯 找到 APP 包: $APP_BUNDLE"

# 步骤 3: 替换主应用的配置文件
echo "🔄 替换嵌入式配置文件..."
cp "$PROVISIONING_PROFILE" "$APP_BUNDLE/embedded.mobileprovision"

# 步骤 4: 从配置文件中提取权限 (Entitlements)
# 这将为主应用生成一个 entitlements.plist 文件
echo "📋 从配置文件中提取权限..."
SECURITY_OUTPUT=$(security cms -D -i "$PROVISIONING_PROFILE")
ENTITLEMENTS=$(echo "$SECURITY_OUTPUT" | plutil -extract Entitlements xml1 -o - -)
if [ -z "$ENTITLEMENTS" ]; then
    echo "❌ 错误：无法从配置文件中提取权限信息"
    exit 1
fi
MAIN_ENTITLEMENTS="$WORK_DIR/entitlements.plist"
echo "$ENTITLEMENTS" > "$MAIN_ENTITLEMENTS"
echo "✅ 权限文件已生成: $MAIN_ENTITLEMENTS"

# 步骤 5: 删除所有旧的 _CodeSignature 文件夹
echo "🧹 清理旧的签名文件..."
find "$APP_BUNDLE" -name "_CodeSignature" -type d -exec rm -rf {} + 2>/dev/null || true

# 步骤 6: 重签名嵌入的 Frameworks（如果有的话）
FRAMEWORKS_DIR="$APP_BUNDLE/Frameworks"
if [ -d "$FRAMEWORKS_DIR" ]; then
    echo "🛠️  开始重签名 Frameworks..."
    for FRAMEWORK in "$FRAMEWORKS_DIR"/*.framework; do
        if [ -d "$FRAMEWORK" ]; then
            echo "   📦 正在签名: $(basename $FRAMEWORK)"
            # 注意：Framework 通常使用其自己的 Info.plist 中的权限，所以这里通常不需要 --entitlements
            codesign -f -v -s "$SIGNING_CERTIFICATE" "$FRAMEWORK"
        fi
    done
    echo "✅ Frameworks 重签名完成."
else
    echo "ℹ️  未发现 Frameworks 目录，跳过."
fi

# 步骤 7: 重签名 PlugIns (App Extensions, e.g., WeTest)（如果有的话）
PLUGINS_DIR="$APP_BUNDLE/PlugIns"
if [ -d "$PLUGINS_DIR" ]; then
    echo "🛠️  开始重签名 PlugIns (App Extensions)..."
    for PLUGIN in "$PLUGINS_DIR"/*.xctest; do
        if [ -d "$PLUGIN" ]; then
            echo "   🔌 正在处理: $(basename $PLUGIN)"
            
            # 首先，删除插件内部的旧签名
            find "$PLUGIN" -name "_CodeSignature" -type d -exec rm -rf {} + 2>/dev/null || true
            
            # 然后，重签名插件内部的 Frameworks（如果有的话）
            PLUGIN_FRAMEWORKS_DIR="$PLUGIN/Frameworks"
            if [ -d "$PLUGIN_FRAMEWORKS_DIR" ]; then
                echo "     📦 正在签名插件内部的 Frameworks..."
                for PLUGIN_FRAMEWORK in "$PLUGIN_FRAMEWORKS_DIR"/*.framework; do
                    if [ -d "$PLUGIN_FRAMEWORK" ]; then
                        echo "       🏗️  正在签名: $(basename $PLUGIN_FRAMEWORK)"
                        codesign -f -v -s "$SIGNING_CERTIFICATE" "$PLUGIN_FRAMEWORK"
                    fi
                done
                echo "     ✅ 插件内部 Frameworks 重签名完成."
            fi
            
            # 最后，重签名插件主包
            echo "     🎯 正在签名插件主包..."
            codesign -f -v -s "$SIGNING_CERTIFICATE" --entitlements "$MAIN_ENTITLEMENTS" "$PLUGIN"
            echo "     ✅ $(basename $PLUGIN) 签名完成."
        fi
    done
    echo "✅ PlugIns 重签名完成."
else
    echo "ℹ️  未发现 PlugIns 目录，跳过."
fi

# 步骤 8: 重签名主应用程序
echo "🎯 开始重签名主应用程序..."
codesign -f -v -s "$SIGNING_CERTIFICATE" --entitlements "$MAIN_ENTITLEMENTS" "$APP_BUNDLE"
echo "✅ 主应用重签名完成."

# 步骤 9: 重新打包为 IPA
echo "📦 正在重新打包为 IPA..."
RESIGNED_IPA="./app_resigned.ipa"
cd "$WORK_DIR"
zip -qr "$RESIGNED_IPA" Payload/
cd - > /dev/null
mv "$WORK_DIR/$RESIGNED_IPA" ./

echo "🎉 重签名完成！"
echo "✅ 重签名后的 IPA 文件: $(pwd)/$RESIGNED_IPA"
