<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover">
    <title>系统主菜单 | 酒店管理系统</title>

    <!-- 现代字体系统 -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:opsz,wght@14..32,300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Font Awesome 6 -->
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
        .dashboard-wrapper {
            flex: 1;
            padding: 2rem 1.5rem;
        }

        .dashboard-container {
            max-width: 1280px;
            margin: 0 auto;
        }

        /* 欢迎区域 */
        .welcome-section {
            margin-bottom: 2rem;
            text-align: center;
        }

        .welcome-section h1 {
            font-size: 2rem;
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

        .welcome-section h1 i {
            background: none;
            color: #2c8b72;
            font-size: 1.8rem;
        }

        .welcome-sub {
            color: #5f7e93;
            font-size: 0.9rem;
            margin-top: 0.5rem;
            border-left: 3px solid #3dab8f;
            padding-left: 16px;
            display: inline-block;
        }

        /* 统计卡片容器 */
        .stats-row {
            display: grid;
            gap: 1.2rem;
            margin-bottom: 2.5rem;
        }

        /* 顾客视图：2个卡片，居中显示 */
        .stats-row.customer-view {
            grid-template-columns: repeat(2, 1fr);
            max-width: 500px;
            margin-left: auto;
            margin-right: auto;
        }

        /* 员工/经理视图：4个卡片 */
        .stats-row.staff-view {
            grid-template-columns: repeat(4, 1fr);
        }

        .stat-card {
            background: #ffffff;
            border-radius: 24px;
            padding: 1.2rem 0.8rem;
            text-align: center;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.03);
            border: 1px solid #eef2f7;
            transition: all 0.25s;
        }

        .stat-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 20px -12px rgba(0, 0, 0, 0.12);
        }

        .stat-icon {
            width: 48px;
            height: 48px;
            border-radius: 28px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 0.8rem auto;
        }

        .stat-icon i {
            font-size: 1.4rem;
        }

        .stat-card:nth-child(1) .stat-icon { background: #ecfdf5; }
        .stat-card:nth-child(1) .stat-icon i { color: #2c8b72; }

        .stat-card:nth-child(2) .stat-icon { background: #fff0e6; }
        .stat-card:nth-child(2) .stat-icon i { color: #c26e4a; }

        .stat-card:nth-child(3) .stat-icon { background: #e6f0fa; }
        .stat-card:nth-child(3) .stat-icon i { color: #4a8bbf; }

        .stat-card:nth-child(4) .stat-icon { background: #f0e6fa; }
        .stat-card:nth-child(4) .stat-icon i { color: #8b6ebf; }

        .stat-number {
            font-size: 1.6rem;
            font-weight: 800;
            color: #1e2f3c;
        }

        .stat-label {
            font-size: 0.75rem;
            color: #6f8ea3;
            margin-top: 0.25rem;
            letter-spacing: 0.02em;
        }

        /* 功能卡片网格 */
        .menu-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
            gap: 1.5rem;
            margin-top: 0.5rem;
        }

        .menu-card {
            background: #ffffff;
            border-radius: 28px;
            overflow: hidden;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.04);
            border: 1px solid #eef2f8;
            text-decoration: none;
            display: block;
            color: inherit;
        }

        .menu-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 20px 30px -12px rgba(0, 0, 0, 0.12);
        }

        .card-header {
            padding: 1.5rem 1.5rem 0.75rem 1.5rem;
        }

        .card-icon {
            width: 56px;
            height: 56px;
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 1rem;
        }

        .card-checkin .card-icon { background: linear-gradient(135deg, #e0f2e9, #c8e6d9); }
        .card-checkin .card-icon i { color: #2c8b72; font-size: 1.5rem; }

        .card-query .card-icon { background: linear-gradient(135deg, #e6f0fa, #d4e5f5); }
        .card-query .card-icon i { color: #4a8bbf; font-size: 1.5rem; }

        .card-available .card-icon { background: linear-gradient(135deg, #fff0e6, #ffe0d0); }
        .card-available .card-icon i { color: #c26e4a; font-size: 1.5rem; }

        .card-checkout .card-icon { background: linear-gradient(135deg, #f0e6fa, #e4d5f5); }
        .card-checkout .card-icon i { color: #8b6ebf; font-size: 1.5rem; }

        .card-header h3 {
            font-size: 1.25rem;
            font-weight: 700;
            color: #1e2f3c;
            margin-bottom: 0.5rem;
        }

        .card-header p {
            font-size: 0.8rem;
            color: #6f8ea3;
            line-height: 1.4;
        }

        .card-footer {
            padding: 1rem 1.5rem 1.5rem 1.5rem;
            border-top: 1px solid #f0f4f8;
        }

        .menu-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: #f0f5f9;
            padding: 0.55rem 1.2rem;
            border-radius: 40px;
            text-decoration: none;
            font-weight: 500;
            font-size: 0.8rem;
            color: #2f6e5a;
            transition: all 0.25s;
            border: 1px solid #dee9ef;
        }

        .menu-link i {
            font-size: 0.7rem;
            transition: transform 0.2s;
        }

        .menu-link:hover {
            background: #e6edf4;
            color: #1c5a48;
            transform: translateX(2px);
        }

        .menu-link:hover i {
            transform: translateX(3px);
        }

        /* 响应式 */
        @media (max-width: 768px) {
            .dashboard-wrapper {
                padding: 1rem;
            }
            .welcome-section h1 {
                font-size: 1.5rem;
            }
            .stats-row.customer-view {
                grid-template-columns: repeat(2, 1fr);
                max-width: 100%;
            }
            .stats-row.staff-view {
                grid-template-columns: repeat(2, 1fr);
            }
            .stat-number {
                font-size: 1.3rem;
            }
            .stat-icon {
                width: 42px;
                height: 42px;
            }
            .stat-icon i {
                font-size: 1.2rem;
            }
            .menu-grid {
                gap: 1rem;
            }
            .card-header {
                padding: 1.2rem 1.2rem 0.5rem 1.2rem;
            }
            .card-footer {
                padding: 0.8rem 1.2rem 1.2rem;
            }
            .card-header h3 {
                font-size: 1.1rem;
            }
        }

        @media (max-width: 480px) {
            .stats-row.customer-view {
                grid-template-columns: repeat(2, 1fr);
                gap: 0.6rem;
            }
            .stats-row.staff-view {
                grid-template-columns: repeat(2, 1fr);
                gap: 0.6rem;
            }
            .stat-card {
                padding: 0.8rem 0.5rem;
            }
            .stat-number {
                font-size: 1.1rem;
            }
            .stat-label {
                font-size: 0.65rem;
            }
        }

        /* 动画 */
        @keyframes fadeUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .dashboard-container {
            animation: fadeUp 0.4s ease-out;
        }

        .stat-card {
            animation: fadeUp 0.4s ease-out;
            animation-fill-mode: backwards;
        }

        .menu-card {
            animation: fadeUp 0.4s ease-out;
            animation-fill-mode: backwards;
        }
    </style>
</head>
<body>

<!-- 引入头部导航 -->
<%@ include file="header.jsp" %>

<%
    // 从 session 获取用户角色
    String userRole = (String) session.getAttribute("role");
    if (userRole == null) {
        userRole = "guest";
    }
    // 判断是否是前台或经理
    boolean isStaffOrManager = "staff".equals(userRole) || "manager".equals(userRole);

    // 从 request 获取统计数据（由 IndexServlet 设置）
    Integer totalRooms = (Integer) request.getAttribute("totalRooms");
    Integer availableRooms = (Integer) request.getAttribute("availableRooms");
    Integer todayCheckIns = (Integer) request.getAttribute("todayCheckIns");
    Integer todayCheckOuts = (Integer) request.getAttribute("todayCheckOuts");

    // 如果统计数为 null，设置默认值
    if (totalRooms == null) totalRooms = 0;
    if (availableRooms == null) availableRooms = 0;
    if (todayCheckIns == null) todayCheckIns = 0;
    if (todayCheckOuts == null) todayCheckOuts = 0;
%>

<div class="dashboard-wrapper">
    <div class="dashboard-container">
        <!-- 欢迎区域 -->
        <div class="welcome-section">
            <h1>
                <i class="fas fa-hotel"></i>
                系统主菜单
            </h1>
            <div class="welcome-sub">
                酒店管理 · 便捷高效
            </div>
        </div>

        <!-- 统计卡片 - 根据角色显示不同内容，数据从数据库动态获取 -->
        <% if (isStaffOrManager) { %>
            <!-- 员工/经理视图：显示4个卡片 -->
            <div class="stats-row staff-view">
                <div class="stat-card">
                    <div class="stat-icon"><i class="fas fa-building"></i></div>
                    <div class="stat-number"><%= totalRooms %></div>
                    <div class="stat-label">客房总数</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon"><i class="fas fa-door-open"></i></div>
                    <div class="stat-number"><%= availableRooms %></div>
                    <div class="stat-label">空闲房间</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon"><i class="fas fa-user-check"></i></div>
                    <div class="stat-number"><%= todayCheckIns %></div>
                    <div class="stat-label">今日入住</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon"><i class="fas fa-user-clock"></i></div>
                    <div class="stat-number"><%= todayCheckOuts %></div>
                    <div class="stat-label">今日退房</div>
                </div>
            </div>
        <% } else { %>
            <!-- 顾客视图：只显示2个卡片（客房总数、空闲房间） -->
            <div class="stats-row customer-view">
                <div class="stat-card">
                    <div class="stat-icon"><i class="fas fa-building"></i></div>
                    <div class="stat-number"><%= totalRooms %></div>
                    <div class="stat-label">客房总数</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon"><i class="fas fa-door-open"></i></div>
                    <div class="stat-number"><%= availableRooms %></div>
                    <div class="stat-label">空闲房间</div>
                </div>
            </div>
        <% } %>

        <!-- 功能菜单网格 - 所有角色都能看到办理入住和办理退房 -->
        <div class="menu-grid">
            <!-- 办理入住 - 所有角色可见 -->
            <a href="${pageContext.request.contextPath}/checkinForm" class="menu-card card-checkin">
                <div class="card-header">
                    <div class="card-icon"><i class="fas fa-key"></i></div>
                    <h3>办理入住</h3>
                </div>
                <div class="card-footer">
                    <div class="menu-link">前往办理入住 <i class="fas fa-arrow-right"></i></div>
                </div>
            </a>

            <!-- 房间状态查询 - 所有角色可见 -->
            <a href="${pageContext.request.contextPath}/allRoomStatus" class="menu-card card-query">
                <div class="card-header">
                    <div class="card-icon"><i class="fas fa-chart-pie"></i></div>
                    <h3>房间状态查询</h3>
                </div>
                <div class="card-footer">
                    <div class="menu-link">查看状态 <i class="fas fa-arrow-right"></i></div>
                </div>
            </a>

            <!-- 空闲房间查询 - 所有角色可见 -->
            <a href="${pageContext.request.contextPath}/rooms/status" class="menu-card card-available">
                <div class="card-header">
                    <div class="card-icon"><i class="fas fa-check-circle"></i></div>
                    <h3>空闲房间查询</h3>
                </div>
                <div class="card-footer">
                    <div class="menu-link">查询空闲 <i class="fas fa-arrow-right"></i></div>
                </div>
            </a>

            <!-- 办理退房 - 所有角色可见 -->
            <a href="${pageContext.request.contextPath}/checkout" class="menu-card card-checkout">
                <div class="card-header">
                    <div class="card-icon"><i class="fas fa-sign-out-alt"></i></div>
                    <h3>办理退房</h3>
                </div>
                <div class="card-footer">
                    <div class="menu-link">办理退房 <i class="fas fa-arrow-right"></i></div>
                </div>
            </a>
        </div>
    </div>
</div>

<!-- 引入底部页脚 -->
<%@ include file="footer.jsp" %>

</body>
</html>