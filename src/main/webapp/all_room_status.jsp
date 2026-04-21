<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.example.hotelmanagementsystem.model.Room" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover">
    <title>客房状态 | 酒店管理系统</title>

    <!-- 现代字体系统: Inter 与优雅备选字体 -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:opsz,wght@14..32,300;14..32,400;14..32,500;14..32,600;14..32,700&display=swap" rel="stylesheet">
    <!-- Font Awesome 6 (纯图标库，增强视觉，不使用emoji) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

    <style>
        /* ---------- 全局重置 & 高级视觉设计 ---------- */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
            background: linear-gradient(135deg, #f0f5fa 0%, #e9f0f5 100%);
            color: #1e2f3e;
            line-height: 1.5;
            padding: 2rem 1.5rem;
            min-height: 100vh;
        }

        /* 主卡片容器 */
        .dashboard-container {
            max-width: 1280px;
            margin: 0 auto;
            background: #ffffff;
            border-radius: 32px;
            box-shadow: 0 25px 45px -12px rgba(0, 0, 0, 0.12), 0 2px 6px rgba(0, 0, 0, 0.02);
            overflow: hidden;
            transition: all 0.3s ease;
        }

        /* 页眉区域 */
        .page-header {
            padding: 2rem 2rem 0.75rem 2rem;
            background: #ffffff;
            border-bottom: 1px solid #eef2f8;
        }

        .title-section {
            display: flex;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
            justify-content: space-between;
        }

        .title-section h2 {
            font-size: 1.85rem;
            font-weight: 700;
            letter-spacing: -0.01em;
            background: linear-gradient(145deg, #1f4e6e, #2c7a6e);
            background-clip: text;
            -webkit-background-clip: text;
            color: transparent;
            display: inline-flex;
            align-items: center;
            gap: 12px;
        }

        .title-section h2 i {
            background: none;
            color: #2a7f6e;
            font-size: 1.7rem;
        }

        .stats-badge {
            background: #ecfdf5;
            padding: 0.4rem 1rem;
            border-radius: 60px;
            font-size: 0.85rem;
            font-weight: 500;
            color: #2b6e5c;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .stats-badge i {
            font-size: 0.8rem;
        }

        .subtitle {
            color: #5a6f82;
            font-size: 0.9rem;
            margin-top: 12px;
            border-left: 3px solid #48b5a0;
            padding-left: 14px;
            font-weight: 400;
        }

        /* 表格外层 - 滚动支持 */
        .table-wrapper {
            padding: 1.5rem 2rem 1rem 2rem;
            overflow-x: auto;
            background: #ffffff;
        }

        /* 现代表格设计 */
        .room-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            font-size: 0.95rem;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 1px 2px rgba(0, 0, 0, 0.03);
        }

        .room-table thead tr {
            background: #f8fafd;
            border-bottom: 1px solid #e6edf4;
        }

        .room-table th {
            text-align: left;
            padding: 1rem 1.2rem;
            font-weight: 600;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            color: #3a5a6e;
            background-color: #fafcff;
            border-bottom: 1px solid #e2eaf1;
        }

        .room-table td {
            padding: 1rem 1.2rem;
            border-bottom: 1px solid #eff3f8;
            vertical-align: middle;
            transition: all 0.2s;
        }

        /* 行悬停效果 */
        .room-table tbody tr:hover td {
            background-color: #fefce8 !important;
            cursor: default;
        }

        /* ----- 保留原有的状态样式类，但升级为更现代的卡片标签设计 ----- */
        /* 原有 .occupied, .available, .reserved, .cleaning 类保留，用于行背景，但进行色彩优化和圆角标签增强 */
        .occupied {
            background-color: #fff3f0;
        }
        .available {
            background-color: #f0faf4;
        }
        .reserved {
            background-color: #fffae6;
        }
        .cleaning {
            background-color: #eef5fc;
        }

        /* 状态标签样式（圆润独立徽章） */
        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 0.3rem 1rem;
            border-radius: 40px;
            font-size: 0.85rem;
            font-weight: 500;
            background: #ffffff;
            box-shadow: 0 1px 2px rgba(0, 0, 0, 0.04);
        }

        /* 各状态专属标签配色 */
        .status-occupied {
            background: #ffe6e1;
            color: #b34e3a;
        }
        .status-available {
            background: #e0f2e9;
            color: #2a785e;
        }
        .status-reserved {
            background: #fff0c8;
            color: #b87c2e;
        }
        .status-cleaning {
            background: #e2edf9;
            color: #3f6b8c;
        }
        .status-maintenance {
            background: #eceef2;
            color: #6f7a86;
        }

        /* 价格列数字样式 */
        .room-table td:nth-child(3) {
            font-weight: 600;
            color: #2c6e5c;
            letter-spacing: 0.01em;
        }

        /* 房间号突出 */
        .room-table td:first-child {
            font-weight: 600;
            color: #1f5575;
        }

        /* 错误信息卡片风格 */
        .error-card {
            background: #fff5f5;
            border-left: 4px solid #e07c6e;
            padding: 1rem 1.5rem;
            border-radius: 16px;
            margin: 2rem;
            display: flex;
            align-items: center;
            gap: 12px;
            color: #bc5442;
            font-weight: 500;
        }

        .empty-state {
            text-align: center;
            padding: 3rem 2rem;
            background: #fafdff;
            border-radius: 24px;
            color: #6c879c;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 12px;
        }

        .empty-state i {
            font-size: 2.8rem;
            color: #bdd4e2;
        }

        /* 底部操作栏 */
        .footer-action {
            padding: 1rem 2rem 2rem 2rem;
            border-top: 1px solid #edf2f7;
            background: #ffffff;
            display: flex;
            justify-content: center;
        }

        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            background: #f1f5f9;
            padding: 0.7rem 1.8rem;
            border-radius: 60px;
            text-decoration: none;
            font-weight: 500;
            font-size: 0.9rem;
            color: #2c5e72;
            transition: all 0.25s;
            border: 1px solid #e2eaf1;
        }

        .back-link i {
            font-size: 0.85rem;
            transition: transform 0.2s;
        }

        .back-link:hover {
            background: #e6edf5;
            color: #1a4a5e;
            border-color: #cbdde6;
            transform: translateY(-2px);
            box-shadow: 0 6px 12px -8px rgba(0, 0, 0, 0.1);
        }

        .back-link:hover i {
            transform: translateX(-4px);
        }

        /* 响应式 */
        @media (max-width: 760px) {
            body {
                padding: 1rem;
            }
            .page-header {
                padding: 1.2rem 1.2rem 0.5rem 1.2rem;
            }
            .title-section h2 {
                font-size: 1.4rem;
            }
            .table-wrapper {
                padding: 0.8rem 1rem 1rem 1rem;
            }
            .room-table th,
            .room-table td {
                padding: 0.7rem 0.8rem;
                font-size: 0.85rem;
            }
            .status-badge {
                padding: 0.2rem 0.7rem;
                font-size: 0.75rem;
            }
            .footer-action {
                padding: 1rem 1rem 1.5rem;
            }
        }

        /* 动画 */
        @keyframes fadeSlide {
            from {
                opacity: 0;
                transform: translateY(10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        .dashboard-container {
            animation: fadeSlide 0.4s ease-out;
        }

        /* 表格内图标辅助（视觉增强，无emoji） */
        .room-table th i {
            margin-right: 6px;
            font-size: 0.8rem;
            color: #6f8ea3;
        }
    </style>
</head>
<body>

<div class="dashboard-container">
    <div class="page-header">
        <div class="title-section">
            <h2>
                <i class="fas fa-hotel"></i>
                客房状态全景
            </h2>
            <div class="stats-badge">
                <i class="fas fa-chart-line"></i>
                实时数据 · 尽在掌握
            </div>
        </div>
        <div class="subtitle">
            房间状态一览 · 支持已入住 / 空闲 / 已预订 / 清洁中
        </div>
    </div>

    <div class="table-wrapper">
        <%
            List<Room> rooms = (List<Room>) request.getAttribute("rooms");
            String error = (String) request.getAttribute("error");
        %>

        <% if (error != null) { %>
            <div class="error-card">
                <i class="fas fa-exclamation-triangle" style="font-size: 1.2rem;"></i>
                <span>错误: <%= error %></span>
            </div>
        <% } else if (rooms != null && !rooms.isEmpty()) { %>
            <table class="room-table">
                <thead>
                    <tr>
                        <th><i class="fas fa-door-open"></i> 房间号</th>
                        <th><i class="fas fa-bed"></i> 房型</th>
                        <th><i class="fas fa-tag"></i> 价格</th>
                        <th><i class="fas fa-info-circle"></i> 当前状态</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    for (Room room : rooms) {
                        String status = room.getStatus();
                        String cssClass;
                        String displayStatus;
                        String badgeClass = "";

                        if ("Occupied".equals(status)) {
                            cssClass = "occupied";
                            displayStatus = "已入住";
                            badgeClass = "status-occupied";
                        } else if ("Available".equals(status)) {
                            cssClass = "available";
                            displayStatus = "空闲";
                            badgeClass = "status-available";
                        } else if ("Reserved".equals(status)) {
                            cssClass = "reserved";
                            displayStatus = "已预订";
                            badgeClass = "status-reserved";
                        } else if ("Cleaning".equals(status)) {
                            cssClass = "cleaning";
                            displayStatus = "清洁中";
                            badgeClass = "status-cleaning";
                        } else {
                            cssClass = "";
                            displayStatus = "维护中";
                            badgeClass = "status-maintenance";
                        }
                %>
                <tr class="<%= cssClass %>">
                    <td><i class="fas fa-hashtag" style="font-size: 0.7rem; color: #7e9eb5; margin-right: 6px;"></i><%= room.getRoomNumber() %></td>
                    <td><%= room.getTypeName() %></td>
                    <td>¥<%= String.format("%.2f", room.getPrice()) %></td>
                    <td>
                        <span class="status-badge <%= badgeClass %>">
                            <% if ("Occupied".equals(status)) { %>
                                <i class="fas fa-user-check"></i>
                            <% } else if ("Available".equals(status)) { %>
                                <i class="fas fa-check-circle"></i>
                            <% } else if ("Reserved".equals(status)) { %>
                                <i class="fas fa-calendar-check"></i>
                            <% } else if ("Cleaning".equals(status)) { %>
                                <i class="fas fa-broom"></i>
                            <% } else { %>
                                <i class="fas fa-tools"></i>
                            <% } %>
                            <%= displayStatus %>
                        </span>
                    </td>
                </tr>
                <%
                    }
                %>
                </tbody>
            </table>
        <% } else { %>
            <div class="empty-state">
                <i class="fas fa-bed-empty"></i>
                <span>暂无房间信息</span>
                <small style="font-size: 0.8rem;">请稍后重试或联系管理员</small>
            </div>
        <% } %>
    </div>

    <div class="footer-action">
        <a href="index.jsp" class="back-link">
            <i class="fas fa-arrow-left"></i>
            返回首页
        </a>
    </div>
</div>

<!-- 细微视觉增强：确保所有原有状态类背景与新版标签完美融合，无功能改动 -->
</body>
</html>