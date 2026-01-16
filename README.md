🌐 [English](README.en.md) | 中文

# 🚀 WDA-Runner 跨平台UI自动化测试工具

> **支持平台**: Windows、macOS、iPhone、Android、Ubuntu 等任何安装有浏览器的设备
> **iOS支持**: iOS13 ~ iOS26
> **功能**: UI自动化测试 / 局域网内控制iPhone测试

---

## 📅 版本更新日志

### 2025年11月04日
- 🎯 完善鼠标滚动功能
- ⌨️ 键盘输入增加监听，提供更友好的输入体验
- 沟通群：Q:418229151

---

## 📖 使用指南

### ⚠️ 重要提示
- IPA包未签名，无法直接通过爱思助手等工具安装
- 安装时如遇"安装包验证失败"错误，请按以下步骤操作
- 安装方式有如下2种，可自行选择安装

#### 1.	使用 [WDAInstaller.dmg](https://github.com/ado2023-oss/WDA-Runner/releases/download/1.1.0/WDAInstaller_MacOSV1.1.0.dmg) 工具（git右侧release选择最新版本）[windows版本点我](https://github.com/ado2023-oss/WDA-Runner/releases/download/1.1.0/WDAInstaller_WindowsV1.1.0.zip)
- 	安装好后，在mac顶部状态栏会出现一个🔧的图标就是（可能需要去Mac-设置-隐私与安全中运行WDAInstaller 运行）
-  打开WDAInstaller之后，需要先输入AppleId跟密码登录(**⚠️⚠️⚠️强烈建议新注册一个AppleID进行签名⚠️⚠️⚠️，官网地址：https://account.apple.com/account, 有可能会revoke您原来的证书**)
-  然后点击 ‘Install WDA-Runner’，静待一刻，就可以在手机上看到安装进度
-  点击WDA-Runner，会提示未信任的App
- 打开手机设置--通用--VPN与设备管理，然后选择AppleID的那一行，点击信任App，即可正常打开使用App
- 这种方式适用所有人，使用的是个人AppleID进行免费的7天有效期签名，7天后App会打不开，需要重新签名
- WDAInstaller 虽然不会采集您的账号信息，但是需要将信息发送到苹果生成证书跟描述文件，有可能会影响您账号下原有的开发者账号，⚠️⚠️⚠️**有可能会revoke您原来的证书**⚠️⚠️⚠️！！如因操作失误导致证书revoke引起的损失，请自行负责！）
- windows版本在输入完账户密码之后，等待1分钟左右即可安装完成，如果一直没响应，杀死WDAInstaller进程重新打开，再将手机数据线重新插拔再次安装

#### 2.	如果您是专业的开发人员并有自己的开发者账号，嫌弃7天过期需要续签，可自行使用我git中提供的签名工具：
##### 对于Apple Silicon芯片Mac：
```bash 
git clone https://github.com/ado2023-oss/WDA-Runner
cd WDA-Runner
chmox +x resign_binary
./resign_binary 'Apple Development: xxx' 'xxxx.mobileprovision' '18'
```
参数分别是:   	证书名字 - 描述文件路径 - 系统版本(如果是 16.6.1， 需要写成 16 )
##### 对于Apple Intel芯片Mac：
```bash 
git clone https://github.com/ado2023-oss/WDA-Runner
cd WDA-Runner
chmox +x resign_intel
resign_intel -cert 'Apple Development: xxx' -profile 'xxxx.mobileprovision' -os '18'
```


#### 巨魔玩家请使用专用版本！！(部分巨魔玩家安装好App，启动会crash，经过实测，需要下载电脑版本的爱思助手，工具箱选择：实时屏幕后，等画面出来之后即可正常使用！！！)

![](5.png)
	
#### 打开手机App，启动服务，服务启动之后： 
#### 访问 http://xx.xx.xx.xx:47000/live 即可操作手机
#### 示例图
![](1.png)
![](2.png)
	
#### 抖音看效果::
	
### 
```bash
https://v.douyin.com/_j4gah-vqao/
```
#### youtube:: 
```bash
https://youtube.com/shorts/Dz0HmWH1ZFI?si=Ox7YPAl5GfyDcvgG
```
	
#### 补充说明: 
##### 如果采用的是无线访问，有可能会比较卡顿，特别在一些网络比较复杂的情形，原因是带宽不足，目测带宽需要再2M/s以上方可稳定访问
##### 提供一个有线（USB数据线链接MAC跟手机）方式的访问：
##### Mac用户：
```bash
-- 安装homebrew，打开终端
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

-- 安装libimobiledevice
brew install libimobiledevice

-- 安装好brew 跟 libimobiledevice，打开2个终端，分别输入以下命令
iproxy 47000 47000

-- 另一个终端输入
iproxy 47001 47001

-- 最后浏览器打开
http://127.0.0.1:47000/live
```
##### Windows用户：
```bash
-- 首先需要去官网下载 itunes 并安装，地址如下；安装好之后打开，数据线链接手机，并信任手机，itunes上可以看到你的手机说明连接正常，继续往下
https://www.apple.com.cn/itunes/

-- 下载iproxy工具并解压，一般选择64位的那个为准，比如： libimobiledevice.1.2.1-r1122-win-x64.zip
https://github.com/libimobiledevice-win32/imobiledevice-net/releases

-- 打开2个命令提示符窗口，第一个（执行以下命令后不要关闭）：
-- 这是楼主下载地址是这个目录，需要以你的访问目录为准，把iproxy.exe 拖入命令提示符即可
C:\Users\Administrator>C:\Users\Administrator\Downloads\libimobiledevice.1.2.1-r1122-win-x64\iproxy.exe 47000 47000

-- 第二个窗口
C:\Users\Administrator>C:\Users\Administrator\Downloads\libimobiledevice.1.2.1-r1122-win-x64\iproxy.exe 47001 47001

-- 最后浏览器打开
http://127.0.0.1:47000/live

```
## 放几组授权码 (如果全都失败了可以进群找管理员要)

#### 239517b1-9765-4588-81d2-ac15f8bd40ae
#### 272da8d3-49c1-4e5d-8b95-c8c8a78e610f 
#### 88fb4140-7c50-4822-884f-55ca71d8fb34
#### 8ac079ec-c8e1-4bb9-990d-e323320e08b4
#### d72aba58-61aa-4bad-bb1e-4bd2ef1a8f8f
