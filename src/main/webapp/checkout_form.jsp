<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.example.hotelmanagementsystem.model.Room" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover">
    <title>办理退房 | 酒店管理系统</title>

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
        .checkout-wrapper {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 2rem 1.5rem;
        }

        .checkout-card {
            max-width: 560px;
            width: 100%;
            background: #ffffff;
            border-radius: 36px;
            box-shadow: 0 25px 45px -12px rgba(0, 0, 0, 0.15), 0 2px 10px rgba(0, 0, 0, 0.02);
            overflow: hidden;
            transition: all 0.3s ease;
            animation: fadeSlideUp 0.4s ease-out;
        }

        /* 头部区域 */
        .card-header {
            background: linear-gradient(120deg, #ffffff 0%, #fafefc 100%);
            padding: 2rem 2rem 0.75rem 2rem;
            border-bottom: 1px solid #eef2f7;
            text-align: center;
        }

        .card-header h2 {
            font-size: 1.9rem;
            font-weight: 700;
            letter-spacing: -0.01em;
            background: linear-gradient(145deg, #8b5a3c, #c26e4a);
            background-clip: text;
            -webkit-background-clip: text;
            color: transparent;
            display: inline-flex;
            align-items: center;
            gap: 12px;
        }

        .card-header h2 i {
            background: none;
            color: #c26e4a;
            font-size: 1.8rem;
        }

        .header-sub {
            color: #5f7e93;
            font-size: 0.9rem;
            margin-top: 12px;
            border-left: 3px solid #c26e4a;
            padding-left: 16px;
            display: inline-block;
            text-align: left;
        }

        /* 表单区域 */
        .form-container {
            padding: 1.8rem 2rem 2rem 2rem;
        }

        /* 错误提示 */
        .error-message {
            background: #fff5f2;
            border-left: 4px solid #e28c6e;
            padding: 1rem 1.2rem;
            border-radius: 20px;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 12px;
            color: #bc5a42;
            font-weight: 500;
        }

        /* 房间信息卡片 */
        .info-card {
            background: #f8fafc;
            border-radius: 24px;
            padding: 1.2rem 1.5rem;
            margin-bottom: 1.8rem;
            border: 1px solid #e8edf2;
        }

        .info-card p {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 0.5rem;
            color: #4a6a7c;
            font-size: 0.9rem;
        }

        .info-card p:last-child {
            margin-bottom: 0;
        }

        .info-card i {
            width: 24px;
            color: #c26e4a;
        }

        .info-card strong {
            color: #2c5a6e;
        }

        /* 表单字段 */
        .form-field {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
            margin-bottom: 1.5rem;
        }

        .form-field label {
            font-weight: 600;
            font-size: 0.9rem;
            color: #2c5a6e;
        }

        .form-field label i {
            margin-right: 8px;
            color: #c26e4a;
        }

        select {
            padding: 0.9rem 1rem;
            border: 1.5px solid #e2eaf0;
            border-radius: 20px;
            font-size: 0.95rem;
            font-family: 'Inter', sans-serif;
            transition: all 0.2s;
            background: #ffffff;
            outline: none;
            cursor: pointer;
            width: 100%;
        }

        select:focus {
            border-color: #c26e4a;
            box-shadow: 0 0 0 3px rgba(194, 110, 74, 0.1);
        }

        /* 提交按钮 */
        .submit-area {
            margin-top: 1.5rem;
            text-align: center;
        }

        .btn-checkout {
            background: linear-gradient(135deg, #c26e4a, #a85432);
            color: white;
            border: none;
            padding: 1rem 2rem;
            font-size: 1rem;
            font-weight: 600;
            border-radius: 44px;
            cursor: pointer;
            transition: all 0.25s;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            font-family: 'Inter', sans-serif;
            box-shadow: 0 4px 10px rgba(162, 84, 50, 0.25);
        }

        .btn-checkout:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(162, 84, 50, 0.3);
            background: linear-gradient(135deg, #a85432, #8b4528);
        }

        .btn-checkout:active {
            transform: translateY(1px);
        }

        /* 空状态提示 */
        .empty-state {
            text-align: center;
            padding: 2rem;
            background: #fafcff;
            border-radius: 24px;
            color: #6c879c;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 12px;
        }

        .empty-state i {
            font-size: 2.8rem;
            color: #c9dae8;
        }

        /* 底部链接 */
        .footer-links {
            padding: 1rem 2rem 2rem 2rem;
            border-top: 1px solid #eef2f8;
            text-align: center;
            background: #ffffff;
        }

        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: #f0f5f9;
            padding: 0.65rem 1.8rem;
            border-radius: 60px;
            text-decoration: none;
            font-weight: 500;
            font-size: 0.9rem;
            color: #2f6e5a;
            transition: all 0.25s;
            border: 1px solid #dee9ef;
        }

        .back-link i {
            transition: transform 0.2s;
        }

        .back-link:hover {
            background: #e6edf4;
            color: #1c5a48;
            transform: translateY(-2px);
        }

        .back-link:hover i {
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
        @media (max-width: 560px) {
            .checkout-wrapper {
                padding: 1rem;
            }
            .card-header h2 {
                font-size: 1.5rem;
            }
            .form-container {
                padding: 1.2rem 1.2rem 1.5rem;
            }
            .card-header {
                padding: 1.2rem 1.2rem 0.5rem;
            }
            .footer-links {
                padding: 1rem 1rem 1.5rem;
            }
            .info-card {
                padding: 1rem;
            }
        }
    </style>
</head>
<body>

<!-- 引入头部导航 -->
<%@ include file="header.jsp" %>

<div class="checkout-wrapper">
    <div class="checkout-card">
        <div class="card-header">
            <h2>
                <i class="fas fa-sign-out-alt"></i>
                办理退房
            </h2>
            <div class="header-sub">
                选择已入住房间，确认退房并结算费用
            </div>
        </div>

        <div class="form-container">
            <%
                List<Room> occupiedRooms = (List<Room>) request.getAttribute("occupiedRooms");
                String error = (String) request.getAttribute("error");
            %>

            <% if (error != null) { %>
                <div class="error-message">
                    <i class="fas fa-exclamation-triangle" style="font-size: 1.1rem;"></i>
                    <span>错误: <%= error %></span>
                </div>
            <% } %>

            <!-- 提示信息卡片 -->
            <div class="info-card">
                <p><i class="fas fa-info-circle"></i> 退房后房间状态将变为 <strong>清洁中</strong></p>
                <p><i class="fas fa-calculator"></i> 费用将根据实际入住天数自动计算</p>
                <p><i class="fas fa-clock"></i> 退房完成后可立即打扫房间</p>
            </div>

            <form action="checkout" method="post">
                <div class="form-field">
                    <label><i class="fas fa-door-open"></i> 选择要退房的房间</label>
                    <select name="roomID" required>
                        <%
                            if (occupiedRooms != null && !occupiedRooms.isEmpty()) {
                                for (Room room : occupiedRooms) {
                        %>
                        <option value="<%= room.getRoomId() %>">
                            <%= room.getRoomNumber() %> · <%= room.getTypeName() %> · 状态: <%= "Occupied".equals(room.getStatus()) ? "已入住" : room.getStatus() %>
                        </option>
                        <%
                                }
                            } else {
                        %>
                        <option value="" disabled selected>暂无已入住的房间</option>
                        <%
                            }
                        %>
                    </select>
                </div>

                <div class="submit-area">
                    <button type="submit" class="btn-checkout">
                        <i class="fas fa-check-circle"></i> 确认退房并结算
                    </button>
                </div>
            </form>

            <% if (occupiedRooms == null || occupiedRooms.isEmpty()) { %>
                <div class="empty-state" style="margin-top: 1.5rem;">
                    <i class="fas fa-bed-empty"></i>
                    <span>当前没有已入住的房间</span>
                    <small style="font-size: 0.8rem;">请先办理入住后再进行退房操作</small>
                </div>
            <% } %>
        </div>

        <div class="footer-links">
            <a href="index.jsp" class="back-link">
                <i class="fas fa-arrow-left"></i> 返回首页
            </a>
        </div>
    </div>
</div>

<!-- 引入底部页脚 -->
<%@ include file="footer.jsp" %>

</body>
</html>