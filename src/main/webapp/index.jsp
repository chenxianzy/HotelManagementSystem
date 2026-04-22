<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover">
    <title>系统主菜单 | 酒店管理系统</title>

    <!-- 现代字体系统: Inter 优先，优雅降级 -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:opsz,wght@14..32,300;400;500;600;700&display=swap" rel="stylesheet">
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

        /* 统计卡片 - 四个在一排 (响应式网格) */
        .stats-row {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 1.2rem;
            margin-bottom: 2.5rem;
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

        /* 各卡片图标配色 */
        .stat-card:nth-child(1) .stat-icon { background: #ecfdf5; }
        .stat-card:nth-child(1) .stat-icon i { color: #2c8b72; }

        .stat-card:nth-child(2) .stat-icon { background: #fff0e6; }
        .stat-card:nth-child(2) .stat-icon i { color: #c26e4a; }

        .stat-card:nth-child(3) .stat-icon { background: #e6f0fa; }
        .stat-card:nth-child(3) .stat-icon i { color: #4a8bbf; }

        .stat-card:nth-child(4) .stat-icon { background: #f0e6fa; }
        .stat-card:nth-child(4) .stat-icon i { color: #8b6ebf; }

        .stat-icon i {
            font-size: 1.4rem;
        }

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

        /* 各卡片主题色 */
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

        /* 响应式 - 小屏幕时统计卡片换行为两行 */
        @media (max-width: 768px) {
            .dashboard-wrapper {
                padding: 1rem;
            }
            .welcome-section h1 {
                font-size: 1.5rem;
            }
            .stats-row {
                grid-template-columns: repeat(2, 1fr);
                gap: 0.8rem;
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
            .stats-row {
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

        .stat-card:nth-child(1) { animation-delay: 0.05s; }
        .stat-card:nth-child(2) { animation-delay: 0.1s; }
        .stat-card:nth-child(3) { animation-delay: 0.15s; }
        .stat-card:nth-child(4) { animation-delay: 0.2s; }

        .menu-card {
            animation: fadeUp 0.4s ease-out;
            animation-fill-mode: backwards;
        }

        .menu-card:nth-child(1) { animation-delay: 0.25s; }
        .menu-card:nth-child(2) { animation-delay: 0.3s; }
        .menu-card:nth-child(3) { animation-delay: 0.35s; }
        .menu-card:nth-child(4) { animation-delay: 0.4s; }
    </style>
</head>
<body>

<!-- 引入头部导航 -->
<%@ include file="header.jsp" %>

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

        <!-- 统计卡片 - 四个在一排 (客房总数、空闲房间、今日入住、今日退房) -->
        <div class="stats-row">
            <!-- 客房总数 -->
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-building"></i>
                </div>
                <div class="stat-number">16</div>
                <div class="stat-label">客房总数</div>
            </div>

            <!-- 空闲房间 -->
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-door-open"></i>
                </div>
                <div class="stat-number">10</div>
                <div class="stat-label">空闲房间</div>
            </div>

            <!-- 今日入住 -->
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-user-check"></i>
                </div>
                <div class="stat-number">3</div>
                <div class="stat-label">今日入住</div>
            </div>

            <!-- 今日退房 -->
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-user-clock"></i>
                </div>
                <div class="stat-number">2</div>
                <div class="stat-label">今日退房</div>
            </div>
        </div>

        <!-- 功能菜单网格 -->
        <div class="menu-grid">
            <!-- 办理入住 -->
            <div class="menu-card card-checkin">
                <div class="card-header">
                    <div class="card-icon">
                        <i class="fas fa-key"></i>
                    </div>
                    <h3>办理入住</h3>
                    <p>为客人办理入住手续，并登记订单记录</p>
                </div>
                <div class="card-footer">
                    <a href="checkinForm" class="menu-link">
                        前往办理入住 <i class="fas fa-arrow-right"></i>
                    </a>
                </div>
            </div>

            <!-- 房间状态查询 -->
            <div class="menu-card card-query">
                <div class="card-header">
                    <div class="card-icon">
                        <i class="fas fa-chart-pie"></i>
                    </div>
                    <h3>房间状态查询</h3>
                    <p>查看酒店内所有房间的详细状态（空闲/已入住/清洁中）</p>
                </div>
                <div class="card-footer">
                    <a href="allRoomStatus" class="menu-link">
                        查询所有房间状态 <i class="fas fa-arrow-right"></i>
                    </a>
                </div>
            </div>

            <!-- 空闲房间查询 -->
            <div class="menu-card card-available">
                <div class="card-header">
                    <div class="card-icon">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <h3>空闲房间查询</h3>
                    <p>快速查询当前所有可供客人入住的空闲房间</p>
                </div>
                <div class="card-footer">
                    <a href="rooms/status" class="menu-link">
                        查询空闲房间 <i class="fas fa-arrow-right"></i>
                    </a>
                </div>
            </div>

            <!-- 办理退房 -->
            <div class="menu-card card-checkout">
                <div class="card-header">
                    <div class="card-icon">
                        <i class="fas fa-sign-out-alt"></i>
                    </div>
                    <h3>办理退房</h3>
                    <p>为客人结算费用并办理退房手续</p>
                </div>
                <div class="card-footer">
                    <a href="checkout" class="menu-link">
                        办理退房 <i class="fas fa-arrow-right"></i>
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 引入底部页脚 -->
<%@ include file="footer.jsp" %>

</body>
</html>