<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover">
    <title>入住结果 | 酒店管理系统</title>

    <!-- 现代字体系统: Inter 优先，优雅降级 -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:opsz,wght@14..32,300;14..32,400;14..32,500;14..32,600;14..32,700&display=swap" rel="stylesheet">
    <!-- Font Awesome 6 图标库 (纯图标，无emoji) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
            background: linear-gradient(145deg, #f1f6fb 0%, #e8f0f5 100%);
            color: #1e2f3c;
            line-height: 1.5;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 2rem 1.5rem;
        }

        /* 结果卡片 */
        .result-card {
            max-width: 520px;
            width: 100%;
            background: #ffffff;
            border-radius: 36px;
            box-shadow: 0 25px 45px -12px rgba(0, 0, 0, 0.15), 0 2px 10px rgba(0, 0, 0, 0.02);
            overflow: hidden;
            animation: fadeSlideUp 0.4s ease-out;
            text-align: center;
        }

        /* 头部装饰 */
        .result-header {
            padding: 2rem 2rem 1rem 2rem;
            background: linear-gradient(120deg, #ffffff 0%, #fafefc 100%);
            border-bottom: 1px solid #eef2f7;
        }

        .result-header h1 {
            font-size: 1.9rem;
            font-weight: 700;
            letter-spacing: -0.01em;
            background: linear-gradient(145deg, #22664e, #2c8b72);
            background-clip: text;
            -webkit-background-clip: text;
            color: transparent;
            display: inline-flex;
            align-items: center;
            gap: 12px;
        }

        .result-header h1 i {
            background: none;
            color: #2c8b72;
            font-size: 1.8rem;
        }

        /* 消息内容区域 */
        .message-area {
            padding: 2rem 2rem 1.5rem 2rem;
        }

        /* 成功消息样式 */
        .message-success {
            background: #ecfdf5;
            border-radius: 24px;
            padding: 1.5rem;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 12px;
            border: 1px solid #c8e6d9;
        }

        .message-success i {
            font-size: 3rem;
            color: #2c8b72;
        }

        .message-success .message-text {
            font-size: 1.05rem;
            font-weight: 500;
            color: #1f6e58;
            line-height: 1.4;
        }

        /* 错误消息样式 */
        .message-error {
            background: #fff5f2;
            border-radius: 24px;
            padding: 1.5rem;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 12px;
            border: 1px solid #ffe0d6;
        }

        .message-error i {
            font-size: 3rem;
            color: #e28c6e;
        }

        .message-error .message-text {
            font-size: 1.05rem;
            font-weight: 500;
            color: #bc5a42;
            line-height: 1.4;
        }

        /* 普通信息样式 */
        .message-info {
            background: #f0f6fa;
            border-radius: 24px;
            padding: 1.5rem;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 12px;
            border: 1px solid #dde9f0;
        }

        .message-info i {
            font-size: 3rem;
            color: #6f9a86;
        }

        .message-info .message-text {
            font-size: 1.05rem;
            font-weight: 500;
            color: #3a6e5c;
            line-height: 1.4;
        }

        /* 底部链接 */
        .footer-link {
            padding: 1rem 2rem 2rem 2rem;
            border-top: 1px solid #eef2f8;
            background: #ffffff;
        }

        .back-home {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            background: #f0f5f9;
            padding: 0.7rem 2rem;
            border-radius: 60px;
            text-decoration: none;
            font-weight: 500;
            font-size: 0.9rem;
            color: #2f6e5a;
            transition: all 0.25s;
            border: 1px solid #dee9ef;
        }

        .back-home i {
            transition: transform 0.2s;
        }

        .back-home:hover {
            background: #e6edf4;
            color: #1c5a48;
            transform: translateY(-2px);
            box-shadow: 0 6px 12px -8px rgba(0, 0, 0, 0.1);
        }

        .back-home:hover i {
            transform: translateX(-4px);
        }

        /* 动画 */
        @keyframes fadeSlideUp {
            from {
                opacity: 0;
                transform: translateY(15px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* 响应式 */
        @media (max-width: 500px) {
            body {
                padding: 1rem;
            }
            .result-header h1 {
                font-size: 1.5rem;
            }
            .message-area {
                padding: 1.5rem 1.2rem;
            }
            .message-success .message-text,
            .message-error .message-text,
            .message-info .message-text {
                font-size: 0.95rem;
            }
            .footer-link {
                padding: 1rem 1rem 1.5rem;
            }
        }
    </style>
</head>
<body>

<div class="result-card">
    <div class="result-header">
        <h1>
            <i class="fas fa-clipboard-list"></i>
            操作结果
        </h1>
    </div>

    <div class="message-area">
        <%
            // 获取消息内容，用于判断消息类型（成功/错误/普通）
            String message = (String) request.getAttribute("message");
            String messageType = "info"; // 默认类型
            if (message != null) {
                if (message.contains("成功") || message.contains("入住办理完成") || message.contains("success") || message.contains("Success")) {
                    messageType = "success";
                } else if (message.contains("错误") || message.contains("失败") || message.contains("error") || message.contains("Error") || message.contains("异常")) {
                    messageType = "error";
                }
            }
        %>

        <% if (messageType.equals("success")) { %>
            <div class="message-success">
                <i class="fas fa-check-circle"></i>
                <div class="message-text">${requestScope.message}</div>
            </div>
        <% } else if (messageType.equals("error")) { %>
            <div class="message-error">
                <i class="fas fa-exclamation-triangle"></i>
                <div class="message-text">${requestScope.message}</div>
            </div>
        <% } else { %>
            <div class="message-info">
                <i class="fas fa-info-circle"></i>
                <div class="message-text">${requestScope.message}</div>
            </div>
        <% } %>
    </div>

    <div class="footer-link">
        <a href="${pageContext.request.contextPath}/index.jsp" class="back-home">
            <i class="fas fa-arrow-left"></i>
            返回首页
        </a>
    </div>
</div>
</body>
</html>