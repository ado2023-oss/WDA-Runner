<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UI自动化测试/局域网内控制iPhone测试</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', 'PingFang SC', 'Microsoft YaHei', sans-serif;
        }
        
        body {
            background-color: #f5f7fa;
            color: #333;
            line-height: 1.6;
            padding: 20px;
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.08);
            padding: 40px;
            margin: 20px 0;
        }
        
        header {
            text-align: center;
            margin-bottom: 40px;
            padding-bottom: 20px;
            border-bottom: 1px solid #eaeaea;
        }
        
        h1 {
            color: #2c3e50;
            font-size: 2.5rem;
            margin-bottom: 15px;
        }
        
        h2 {
            color: #3498db;
            margin: 30px 0 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #eaeaea;
        }
        
        h3 {
            color: #2c3e50;
            margin: 20px 0 10px;
        }
        
        p {
            margin-bottom: 15px;
            font-size: 16px;
        }
        
        .warning {
            background-color: #fff3e0;
            border-left: 4px solid #ff9800;
            padding: 15px;
            margin: 20px 0;
            border-radius: 0 4px 4px 0;
        }
        
        .important {
            background-color: #ffebee;
            border-left: 4px solid #f44336;
            padding: 15px;
            margin: 20px 0;
            border-radius: 0 4px 4px 0;
        }
        
        .info {
            background-color: #e3f2fd;
            border-left: 4px solid #2196f3;
            padding: 15px;
            margin: 20px 0;
            border-radius: 0 4px 4px 0;
        }
        
        ul, ol {
            margin: 15px 0;
            padding-left: 30px;
        }
        
        li {
            margin-bottom: 10px;
        }
        
        code {
            background-color: #f5f5f5;
            padding: 2px 6px;
            border-radius: 4px;
            font-family: 'Fira Code', monospace;
            font-size: 0.95em;
        }
        
        pre {
            background-color: #2d2d2d;
            color: #f8f8f2;
            padding: 15px;
            border-radius: 6px;
            overflow-x: auto;
            margin: 20px 0;
            line-height: 1.5;
        }
        
        .step-box {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            margin: 25px 0;
        }
        
        .step {
            flex: 1;
            min-width: 300px;
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
            border-top: 4px solid #3498db;
        }
        
        .step-number {
            display: inline-block;
            background: #3498db;
            color: white;
            width: 30px;
            height: 30px;
            text-align: center;
            line-height: 30px;
            border-radius: 50%;
            margin-right: 10px;
        }
        
        .image-placeholder {
            background: #eaeaea;
            height: 200px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 20px 0;
            color: #777;
            font-style: italic;
        }
        
        .footer {
            text-align: center;
            margin-top: 40px;
            padding-top: 20px;
            border-top: 1px solid #eaeaea;
            color: #7f8c8d;
            font-size: 0.9rem;
        }
        
        @media (max-width: 768px) {
            body {
                padding: 10px;
            }
            
            .container {
                padding: 20px;
            }
            
            h1 {
                font-size: 2rem;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <header>
            <h1>UI自动化测试/局域网内控制iPhone测试</h1>
            <p>通过本工具，您可以在局域网内控制iPhone进行UI自动化测试</p>
        </header>
        
        <section>
            <h2>使用说明</h2>
            
            <div class="warning">
                <p><strong>注意：</strong>ipa包没有签名过，无法使用爱思助手等工具安装到iPhone上，会提示"安装包验证失败"错误。</p>
            </div>
            
            <h3>签名工具使用</h3>
            <p>签名工具可以自己写，也可以使用提供的<code>resign.sh</code>脚本。</p>
            
            <div class="important">
                <p>经过测试，爱思助手的签名工具无法完整签名。没有经验的建议使用提供的签名脚本（仅限macOS）。</p>
            </div>
            
            <h3>签名脚本配置</h3>
            <p>签名脚本需要修改以下两个地方：</p>
            
            <ol>
                <li>第12行：改为钥匙串中的名字</li>
                <li>第16行：改为你的描述文件的名字</li>
            </ol>
            
            <div class="info">
                <p>描述文件可以从相关渠道获取（如闲鱼等平台），通常价格在13-14元左右。需要先安装到钥匙串方可继续签名。</p>
                <p>描述文件最好使用<code>com.*</code>通配符格式，有能力的用户可以自行修改。</p>
            </div>
            
            <h3>试用版本限制</h3>
            <p>试用版本目前只有一分钟使用时间，一分钟后会停止服务，需要授权才能继续使用。</p>
            
            <div class="important">
                <p>本软件禁止用于非法用途！</p>
            </div>
            
            <h3>技术原理</h3>
            <p>本软件参照WDA（WebDriverAgent）的自动化测试工具，相当于在手机内部启动了一个服务器，浏览器可以通过访问手机的IP地址来访问这个服务器。</p>
            
            <h3>访问方式</h3>
            <p>访问地址：<code>http://192.168.x.x:47000/live</code></p>
            
            <div class="info">
                <p>每次访问时，App会弹出消息通知，提示是否允许来自客户端的访问，同意后方可访问。</p>
            </div>
            
            <h3>功能说明</h3>
            <p>目前网页版本还比较简单，一些简单的手势已实现，后续会逐渐加入键盘等事件。</p>
            
            <h3>权限需求</h3>
            <p>需要申请以下权限：</p>
            <ul>
                <li>网络权限</li>
                <li>消息通知</li>
                <li>本地网络</li>
            </ul>
            
            <h3>更新计划</h3>
            <p>Windows版本正在研究中，后续会更新发布。</p>
            
            <div class="step-box">
                <div class="step">
                    <h4><span class="step-number">1</span>环境准备</h4>
                    <p>确保iPhone和电脑在同一局域网内，安装必要的描述文件。</p>
                </div>
                <div class="step">
                    <h4><span class="step-number">2</span>签名应用</h4>
                    <p>使用resign.sh脚本对ipa进行签名，修改相应的配置参数。</p>
                </div>
                <div class="step">
                    <h4><span class="step-number">3</span>安装运行</h4>
                    <p>将签名后的应用安装到iPhone并运行。</p>
                </div>
                <div class="step">
                    <h4><span class="step-number">4</span>访问控制</h4>
                    <p>通过浏览器访问iPhone的IP地址和端口进行控制。</p>
                </div>
            </div>
        </section>
        
        <div class="footer">
            <p>© 2023 UI自动化测试工具 | 版本号: 1.0.0 | 更新日期: 2023-11-05</p>
        </div>
    </div>
</body>
</html>
