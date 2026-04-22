<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.example.hotelmanagementsystem.model.Room" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover">
    <title>空闲客房 | 酒店管理系统</title>

    <!-- 现代字体: Inter 优先，优雅降级 -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:opsz,wght@14..32,300;14..32,400;14..32,500;14..32,600;14..32,700&display=swap" rel="stylesheet">
    <!-- Font Awesome 6 图标库 (纯图形，无emoji) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

    <style>
        /* ---------- 全局样式 · 宁静专业 ---------- */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
            background: linear-gradient(145deg, #f4f9fe 0%, #ecf3f8 100%);
            color: #1e2f3c;
            line-height: 1.5;
            padding: 2rem 1.5rem;
            min-height: 100vh;
        }

        /* 主容器 - 优雅卡片 */
        .card-container {
            max-width: 1280px;
            margin: 0 auto;
            background: #ffffff;
            border-radius: 36px;
            box-shadow: 0 25px 45px -12px rgba(0, 0, 0, 0.12), 0 2px 10px rgba(0, 0, 0, 0.02);
            overflow: hidden;
            transition: all 0.3s ease;
        }

        /* 头部区域 */
        .hero-section {
            background: linear-gradient(120deg, #ffffff 0%, #fefefe 100%);
            padding: 2rem 2rem 0.5rem 2rem;
            border-bottom: 1px solid #eef2f7;
        }

        .title-wrapper {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .title-wrapper h1 {
            font-size: 2rem;
            font-weight: 700;
            letter-spacing: -0.01em;
            background: linear-gradient(145deg, #22664e, #2c8b72);
            background-clip: text;
            -webkit-background-clip: text;
            color: transparent;
            display: inline-flex;
            align-items: center;
            gap: 14px;
        }

        .title-wrapper h1 i {
            background: none;
            color: #2c8b72;
            font-size: 1.9rem;
        }

        .air-badge {
            background: #e6f9f0;
            padding: 0.45rem 1.2rem;
            border-radius: 60px;
            font-size: 0.85rem;
            font-weight: 500;
            color: #1f6e58;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .air-badge i {
            font-size: 0.85rem;
        }

        .subhead {
            margin-top: 1rem;
            margin-bottom: 0.5rem;
            color: #57758c;
            font-size: 0.95rem;
            border-left: 3px solid #3dab8f;
            padding-left: 15px;
            font-weight: 400;
        }

        /* 内容区域 */
        .content-pane {
            padding: 1.8rem 2rem 2rem 2rem;
        }

        /* 统计摘要卡片 */
        .summary-card {
            background: #f6fbf9;
            border-radius: 24px;
            padding: 1rem 1.8rem;
            margin-bottom: 2rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 1rem;
            border: 1px solid #e0ede8;
        }

        .count-info {
            display: flex;
            align-items: baseline;
            gap: 12px;
            flex-wrap: wrap;
        }

        .count-number {
            font-size: 2rem;
            font-weight: 800;
            color: #2a7a62;
            line-height: 1;
        }

        .count-label {
            font-size: 1rem;
            font-weight: 500;
            color: #436d5c;
        }

        .status-tag {
            background: #e2f3ed;
            padding: 0.3rem 1rem;
            border-radius: 32px;
            font-size: 0.8rem;
            color: #1c6a53;
            font-weight: 500;
        }

        /* 现代表格设计 */
        .elegant-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            border-radius: 24px;
            overflow: hidden;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04);
        }

        .elegant-table thead tr {
            background: #f9fdfb;
        }

        .elegant-table th {
            text-align: left;
            padding: 1rem 1.2rem;
            font-weight: 600;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            color: #376952;
            background-color: #fafefc;
            border-bottom: 1px solid #e2ede7;
        }

        .elegant-table td {
            padding: 1rem 1.2rem;
            border-bottom: 1px solid #eef5f1;
            vertical-align: middle;
            transition: background 0.2s;
        }

        .elegant-table tbody tr:hover td {
            background-color: #fefce8;
        }

        /* 房间号高亮 */
        .room-number {
            font-weight: 700;
            color: #1c5d74;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .room-number i {
            font-size: 0.85rem;
            color: #4f9b82;
        }

        /* 价格样式 */
        .price-value {
            font-weight: 700;
            color: #2b7a5e;
            letter-spacing: 0.01em;
        }

        /* 状态徽章 (可用) */
        .status-badge-available {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: #e0f2e9;
            color: #1f6e50;
            padding: 0.3rem 1rem;
            border-radius: 40px;
            font-size: 0.85rem;
            font-weight: 500;
        }

        /* 错误/空状态卡片 */
        .message-card {
            background: #ffffff;
            border-radius: 24px;
            padding: 2rem;
            text-align: center;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.02);
            border: 1px solid #edf2f0;
        }

        .error-message {
            color: #cd7a5c;
            background: #fff7f5;
            border-left: 4px solid #e28c6e;
            padding: 1rem 1.5rem;
            border-radius: 18px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-weight: 500;
        }

        .empty-message {
            color: #6b8da3;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 14px;
        }

        .empty-message i {
            font-size: 2.8rem;
            color: #bdd8e6;
        }

        /* 底部返回链接 */
        .footer-nav {
            padding: 1rem 2rem 2rem 2rem;
            border-top: 1px solid #eaf0f5;
            text-align: center;
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

        /* 响应式 */
        @media (max-width: 680px) {
            body {
                padding: 1rem;
            }
            .hero-section {
                padding: 1.2rem 1.2rem 0.2rem 1.2rem;
            }
            .title-wrapper h1 {
                font-size: 1.55rem;
            }
            .content-pane {
                padding: 1rem 1rem 1.2rem 1rem;
            }
            .summary-card {
                padding: 0.8rem 1.2rem;
            }
            .count-number {
                font-size: 1.6rem;
            }
            .elegant-table th,
            .elegant-table td {
                padding: 0.7rem 0.8rem;
                font-size: 0.85rem;
            }
            .status-badge-available {
                padding: 0.2rem 0.7rem;
                font-size: 0.75rem;
            }
            .footer-nav {
                padding: 1rem 1rem 1.5rem;
            }
        }

        /* 动画 */
        @keyframes fadeUp {
            from {
                opacity: 0;
                transform: translateY(12px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .card-container {
            animation: fadeUp 0.4s ease-out;
        }

        /* 表头图标辅助 */
        .elegant-table th i {
            margin-right: 8px;
            font-size: 0.8rem;
            color: #578f7a;
        }
    </style>
</head>
<body>

<div class="card-container">
    <div class="hero-section">
        <div class="title-wrapper">
            <h1>
                <i class="fas fa-bed"></i>
                空闲客房
            </h1>
            <div class="air-badge">
                <i class="fas fa-calendar-alt"></i>
                可供即时预订
            </div>
        </div>
        <div class="subhead">
            仅显示状态为「Available」的房间 · 清新舒适，即刻入住
        </div>
    </div>

    <div class="content-pane">
        <%
            // 完全保留原有业务逻辑：获取错误信息或房间列表
            String errorMessage = (String) request.getAttribute("errorMessage");
            if (errorMessage != null) {
        %>
        <div class="message-card">
            <div class="error-message">
                <i class="fas fa-exclamation-circle" style="font-size: 1.2rem;"></i>
                <span><%= errorMessage %></span>
            </div>
        </div>
        <%
        } else {
            List<Room> rooms = (List<Room>) request.getAttribute("rooms");
            if (rooms != null && !rooms.isEmpty()) {
        %>
        <!-- 统计摘要 -->
        <div class="summary-card">
            <div class="count-info">
                <span class="count-number"><%= rooms.size() %></span>
                <span class="count-label">间空闲客房</span>
                <span class="status-tag"><i class="fas fa-check-circle"></i> 可立即办理入住</span>
            </div>
            <div>
                <i class="fas fa-building" style="color: #86b3a2; font-size: 1.2rem;"></i>
                <span style="font-size: 0.8rem; color: #5e8876;"> 今日好房推荐</span>
            </div>
        </div>

        <table class="elegant-table">
            <thead>
                <tr>
                    <th><i class="fas fa-door-open"></i> 房间号</th>
                    <th><i class="fas fa-couch"></i> 房间类型</th>
                    <th><i class="fas fa-tag"></i> 价格 (RMB/晚)</th>
                    <th><i class="fas fa-info-circle"></i> 状态</th>
                </tr>
            </thead>
            <tbody>
            <% for (Room room : rooms) { %>
                <tr>
                    <td>
                        <span class="room-number">
                            <i class="fas fa-hashtag"></i>
                            <%= room.getRoomNumber() %>
                        </span>
                    </td>
                    <td><%= room.getTypeName() %></td>
                    <td><span class="price-value">¥ <%= String.format("%.2f", room.getPrice()) %></span></td>
                    <td>
                        <span class="status-badge-available">
                            <i class="fas fa-check-circle"></i>
                            <%= "Available".equals(room.getStatus()) ? "空闲" : room.getStatus() %>
                        </span>
                    </td>
                </tr>
            <% } %>
            </tbody>
        </table>
        <%
            } else {
        %>
        <div class="message-card">
            <div class="empty-message">
                <i class="fas fa-bed-empty"></i>
                <span>抱歉，当前没有可供入住的空闲房间</span>
                <small style="font-size: 0.85rem; color: #88a4b5;">请稍后再来查询或联系前台</small>
            </div>
        </div>
        <%
                }
            }
        %>
    </div>

    <div class="footer-nav">
        <a href="${pageContext.request.contextPath}/index.jsp" class="back-home">
            <i class="fas fa-arrow-left"></i>
            返回首页
        </a>
    </div>
</div>

</body>
</html>