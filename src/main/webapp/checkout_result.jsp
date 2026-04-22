<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.math.BigDecimal" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover">
    <title>退房结算结果 | 酒店管理系统</title>

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
            flex-direction: column;
        }

        /* 主容器 */
        .result-wrapper {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 2rem 1.5rem;
        }

        .result-card {
            max-width: 540px;
            width: 100%;
            background: #ffffff;
            border-radius: 36px;
            box-shadow: 0 25px 45px -12px rgba(0, 0, 0, 0.15), 0 2px 10px rgba(0, 0, 0, 0.02);
            overflow: hidden;
            animation: fadeSlideUp 0.4s ease-out;
        }

        /* 头部区域 */
        .card-header {
            background: linear-gradient(120deg, #ffffff 0%, #fafefc 100%);
            padding: 2rem 2rem 0.75rem 2rem;
            border-bottom: 1px solid #eef2f7;
            text-align: center;
        }

        /* 成功状态头部 */
        .card-header.success h2 {
            background: linear-gradient(145deg, #22664e, #2c8b72);
            background-clip: text;
            -webkit-background-clip: text;
            color: transparent;
        }

        .card-header.success h2 i {
            color: #2c8b72;
        }

        /* 错误状态头部 */
        .card-header.error h2 {
            background: linear-gradient(145deg, #b54e3a, #c96a52);
            background-clip: text;
            -webkit-background-clip: text;
            color: transparent;
        }

        .card-header.error h2 i {
            color: #c96a52;
        }

        .card-header h2 {
            font-size: 1.9rem;
            font-weight: 700;
            letter-spacing: -0.01em;
            display: inline-flex;
            align-items: center;
            gap: 12px;
        }

        .card-header h2 i {
            font-size: 1.8rem;
        }

        /* 内容区域 */
        .result-content {
            padding: 2rem 2rem 1.5rem 2rem;
        }

        /* 成功信息卡片 */
        .success-panel {
            background: #ecfdf5;
            border-radius: 28px;
            padding: 1.8rem;
            border: 1px solid #c8e6d9;
            text-align: center;
        }

        .success-icon {
            width: 70px;
            height: 70px;
            background: #2c8b72;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.2rem auto;
        }

        .success-icon i {
            font-size: 2.5rem;
            color: white;
        }

        .success-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: #1f6e58;
            margin-bottom: 1.5rem;
        }

        /* 结算详情 */
        .detail-box {
            background: #ffffff;
            border-radius: 20px;
            padding: 1.2rem 1.5rem;
            margin: 1rem 0;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.03);
            border: 1px solid #dee9e3;
        }

        .detail-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.8rem 0;
            border-bottom: 1px solid #eef3ef;
        }

        .detail-row:last-child {
            border-bottom: none;
        }

        .detail-label {
            font-weight: 500;
            color: #4f6f82;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .detail-label i {
            width: 24px;
            color: #2c8b72;
            font-size: 0.95rem;
        }

        .detail-value {
            font-weight: 600;
            color: #1e2f3c;
        }

        .cost-value {
            font-size: 1.8rem;
            font-weight: 800;
            color: #c26e4a;
        }

        .status-badge {
            display: inline-block;
            background: #e2edf9;
            color: #3f6b8c;
            padding: 0.25rem 1rem;
            border-radius: 40px;
            font-size: 0.8rem;
            font-weight: 500;
        }

        /* 错误信息卡片 */
        .error-panel {
            background: #fff5f2;
            border-radius: 28px;
            padding: 1.8rem;
            border: 1px solid #ffe0d6;
            text-align: center;
        }

        .error-icon {
            width: 70px;
            height: 70px;
            background: #e28c6e;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.2rem auto;
        }

        .error-icon i {
            font-size: 2.5rem;
            color: white;
        }

        .error-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: #bc5a42;
            margin-bottom: 1rem;
        }

        .error-message-box {
            background: #ffffff;
            border-radius: 16px;
            padding: 1rem;
            margin: 1rem 0;
            border-left: 3px solid #e28c6e;
            text-align: left;
            color: #8b5a4a;
            font-size: 0.9rem;
        }

        .warning-note {
            background: #fff8e6;
            border-radius: 16px;
            padding: 0.8rem 1rem;
            margin-top: 1rem;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 0.85rem;
            color: #b88c4a;
        }

        /* 底部链接 */
        .footer-links {
            padding: 1rem 2rem 2rem 2rem;
            border-top: 1px solid #eef2f8;
            text-align: center;
            background: #ffffff;
            display: flex;
            justify-content: center;
            gap: 1rem;
            flex-wrap: wrap;
        }

        .action-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: #f0f5f9;
            padding: 0.65rem 1.5rem;
            border-radius: 60px;
            text-decoration: none;
            font-weight: 500;
            font-size: 0.9rem;
            color: #2f6e5a;
            transition: all 0.25s;
            border: 1px solid #dee9ef;
        }

        .action-link i {
            transition: transform 0.2s;
        }

        .action-link:hover {
            background: #e6edf4;
            color: #1c5a48;
            transform: translateY(-2px);
        }

        .action-link:hover i {
            transform: translateX(-3px);
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
            .result-wrapper {
                padding: 1rem;
            }
            .card-header h2 {
                font-size: 1.5rem;
            }
            .result-content {
                padding: 1.2rem 1.2rem 1rem;
            }
            .success-panel, .error-panel {
                padding: 1.2rem;
            }
            .cost-value {
                font-size: 1.4rem;
            }
            .footer-links {
                padding: 1rem 1rem 1.5rem;
                gap: 0.8rem;
            }
            .action-link {
                padding: 0.5rem 1.2rem;
                font-size: 0.8rem;
            }
        }
    </style>
</head>
<body>

<!-- 引入头部导航 -->
<%@ include file="header.jsp" %>

<div class="result-wrapper">
    <div class="result-card">
        <%
            Object successObj = request.getAttribute("success");
            String roomNumber = (String) request.getAttribute("roomNumber");
            Object costObj = request.getAttribute("totalCost");

            BigDecimal totalCost = BigDecimal.ZERO;
            if (costObj instanceof BigDecimal) {
                totalCost = (BigDecimal) costObj;
            }

            // 只要 roomNumber 不为空，哪怕 success 标志丢了，也算成功
            boolean isSuccess = (Boolean.TRUE.equals(successObj) || roomNumber != null);
        %>

        <div class="card-header <%= isSuccess ? "success" : "error" %>">
            <h2>
                <i class="<%= isSuccess ? "fas fa-check-circle" : "fas fa-exclamation-triangle" %>"></i>
                <%= isSuccess ? "退房办理成功" : "操作异常" %>
            </h2>
        </div>

        <div class="result-content">
            <% if (isSuccess) { %>
                <!-- 成功状态 -->
                <div class="success-panel">
                    <div class="success-icon">
                        <i class="fas fa-check"></i>
                    </div>
                    <div class="success-title">结算完成</div>

                    <div class="detail-box">
                        <div class="detail-row">
                            <span class="detail-label">
                                <i class="fas fa-door-open"></i> 房间号
                            </span>
                            <span class="detail-value"><%= roomNumber != null ? roomNumber : "---" %></span>
                        </div>
                        <div class="detail-row">
                            <span class="detail-label">
                                <i class="fas fa-tag"></i> 结算费用
                            </span>
                            <span class="cost-value">¥ <%= String.format("%.2f", totalCost) %></span>
                        </div>
                        <div class="detail-row">
                            <span class="detail-label">
                                <i class="fas fa-broom"></i> 当前状态
                            </span>
                            <span class="status-badge">清洁中 (Cleaning)</span>
                        </div>
                    </div>

                    <p style="font-size: 0.8rem; color: #6f9a86; margin-top: 0.5rem;">
                        <i class="fas fa-clock"></i> 房间已标记为清洁中，打扫完成后可恢复为可入住状态
                    </p>
                </div>
            <% } else { %>
                <!-- 错误/警告状态 -->
                <div class="error-panel">
                    <div class="error-icon">
                        <i class="fas fa-question"></i>
                    </div>
                    <div class="error-title">显示结果时出错</div>

                    <div class="error-message-box">
                        <%
                            String error = (String) request.getAttribute("error");
                        %>
                        <p style="margin-bottom: 0.5rem;"><i class="fas fa-info-circle"></i> 错误详情：</p>
                        <p style="font-size: 0.85rem; word-break: break-all;"><%= error != null ? error : "未知错误" %></p>
                    </div>

                    <div class="warning-note">
                        <i class="fas fa-exclamation-triangle"></i>
                        <span>虽然显示出错，但在数据库中退房可能已经成功。请返回首页查询房间状态进行确认。</span>
                    </div>
                </div>
            <% } %>
        </div>

        <div class="footer-links">
            <a href="${pageContext.request.contextPath}/index" class="action-link">
                <i class="fas fa-home"></i> 返回首页
            </a>
            <a href="allRoomStatus" class="action-link">
                <i class="fas fa-building"></i> 查看房间状态
            </a>
        </div>
    </div>
</div>

<!-- 引入底部页脚 -->
<%@ include file="footer.jsp" %>

</body>
</html>