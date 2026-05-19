<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.example.hotelmanagementsystem.model.Room" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover">
    <title>客房状态 | 酒店管理系统</title>

    <!-- 现代字体系统: Inter 为主要字体，提升屏幕易读性，优雅备降系统字体 -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:opsz,wght@14..32,300;14..32,400;14..32,500;14..32,600;14..32,700&display=swap" rel="stylesheet">
    <!-- Font Awesome 6 (免费纯图标库，增强视觉但不依赖emoji) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
            background: #f4f7fc;   /* 柔和清爽背景色 */
            color: #1a2c3e;
            line-height: 1.5;
            padding: 2rem 1.5rem;
        }

        /* 优雅主容器：最大宽度与舒适留白 */
        .container {
            max-width: 1280px;
            margin: 0 auto;
            background: #ffffff;
            border-radius: 32px;
            box-shadow: 0 20px 35px -12px rgba(0, 0, 0, 0.08), 0 1px 3px rgba(0, 0, 0, 0.02);
            overflow: hidden;
            transition: all 0.2s ease;
        }

        /* 页眉区域：标题 + 副线 */
        .page-header {
            padding: 2rem 2rem 0.75rem 2rem;
            border-bottom: 1px solid #eef2f6;
            background: #ffffff;
        }

        .page-header h2 {
            font-size: 1.9rem;
            font-weight: 600;
            letter-spacing: -0.01em;
            background: linear-gradient(135deg, #1f3b4c, #2a5f7a);
            background-clip: text;
            -webkit-background-clip: text;
            color: transparent;
            margin-bottom: 0.4rem;
            display: inline-flex;
            align-items: center;
            gap: 12px;
        }

        .page-header h2 i {
            background: none;
            color: #2a7f6e;
            font-size: 1.8rem;
            background-clip: unset;
            -webkit-background-clip: unset;
            color: #2c7a6e;
        }

        .subtitle {
            color: #5b6f82;
            font-size: 0.95rem;
            font-weight: 400;
            margin-top: 6px;
            border-left: 3px solid #48b5a0;
            padding-left: 14px;
        }

        /* 表格区域 - 干净易读，悬停优化 */
        .table-wrapper {
            padding: 1.5rem 2rem 2rem 2rem;
            overflow-x: auto;
            background: #ffffff;
        }

        /* 现代卡片风格表格 */
        .room-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.95rem;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 1px 2px rgba(0, 0, 0, 0.03);
        }

        .room-table thead tr {
            background: #f0f4f9;
            border-bottom: 1px solid #e2e8f0;
        }

        .room-table th {
            text-align: left;
            padding: 1rem 1.2rem;
            font-weight: 600;
            font-size: 0.9rem;
            letter-spacing: 0.02em;
            color: #1f3e48;
            text-transform: uppercase;
            font-weight: 600;
            background-color: #f8fafc;
        }

        .room-table td {
            padding: 1rem 1.2rem;
            border-bottom: 1px solid #ecf3f8;
            vertical-align: middle;
            transition: background 0.2s;
        }

        /* 行悬停微交互，增强易读性 */
        .room-table tbody tr:hover td {
            background-color: #fefce8 !important;  /* 温柔暖调悬停 */
        }

        /* 状态样式 - 圆润标签设计，不用emoji只用文字+几何感 */
        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 0.3rem 0.9rem;
            border-radius: 40px;
            font-size: 0.85rem;
            font-weight: 500;
            letter-spacing: 0.01em;
            background: #eef2ff;
            color: #1e3a5f;
        }

        .status-badge i {
            font-size: 0.8rem;
            opacity: 0.8;
        }

        /* 不同状态的特定配色 (保留原有业务逻辑里的颜色区分，但设计得更精致)
           原有逻辑 background-color 条件判断依然保留，但为了美观增加覆盖并柔化。
           注意: 原 JSP 中 style="background-color: <%= ... %>" 会保留，我们通过CSS进一步美化覆盖，
           保证不破坏业务判断同时提供更优雅视觉 */
        .room-table tbody tr[data-status="Occupied"] td,
        .room-table tbody tr:has(td:last-child:contains("Occupied")) {
            /* 备用占位，实际由原有style和class共同作用，但不影响逻辑 */
        }

        /* 优雅覆盖原有背景色 (原有背景为 #ffdddd 或 #ddffdd，这里增强柔和度并转成更现代颜色)
           同时保证样式优先级略高于行内style (使用 !important 或者更高权重选择器)
           因为需求是"不要动代码的其他部分，只做UI设计"，我们可以通过增加额外类覆盖行内背景，使视觉更高级。
           行内style依然存在，但我们可以用CSS覆盖让颜色更舒适，而不删除任何原有代码。 */
        .room-table tbody tr {
            transition: all 0.2s;
        }

        /* 针对入住状态(Occupied)的行背景优化: 柔和水蜜桃色调，增加微渐变 */
        .room-table tbody tr[style*="background-color: #ffdddd"],
        .room-table tbody tr[style*="background-color: #ffdddd;"],
        .room-table tbody tr[style*="background-color:#ffdddd"] {
            background-color: #fff1f0 !important;
        }

        /* 针对空闲状态(Available / 非Occupied)的行背景优化 */
        .room-table tbody tr[style*="background-color: #ddffdd"],
        .room-table tbody tr[style*="background-color: #ddffdd;"],
        .room-table tbody tr[style*="background-color:#ddffdd"] {
            background-color: #effaf3 !important;
        }

        /* 同时增强维护性: 如果状态字段为 Occupied，也辅助加上优雅底色 (不干扰原有逻辑) */
        /* 注: 因为原JSP里 tr 的 background-color 依赖room.getStatus()，所以我们利用属性选择器覆盖后达到更柔和配色 */

        /* 价格数字样式更清晰 */
        .room-table td:nth-child(3) {
            font-weight: 600;
            color: #2c6e5c;
            letter-spacing: 0.01em;
        }

        /* 房间号加强可读 */
        .room-table td:first-child {
            font-weight: 500;
            color: #1a4b6e;
        }

        /* 空数据状态优雅提示 */
        .empty-message {
            text-align: center;
            padding: 3rem 2rem;
            background: #fafcff;
            border-radius: 24px;
            color: #5c6f87;
            font-size: 1rem;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 12px;
        }

        .empty-message i {
            font-size: 2.8rem;
            color: #b9cedb;
            margin-bottom: 0.25rem;
        }

        /* 底部返回链接区域 - 干净现代 */
        .footer-action {
            padding: 1rem 2rem 2rem 2rem;
            border-top: 1px solid #eef2f8;
            background: #ffffff;
            display: flex;
            justify-content: flex-start;
        }

        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            background: #f0f4fa;
            padding: 0.65rem 1.5rem;
            border-radius: 60px;
            text-decoration: none;
            font-weight: 500;
            font-size: 0.9rem;
            color: #2c5a6e;
            transition: all 0.25s ease;
            border: 1px solid #e2edf2;
        }

        .back-link i {
            font-size: 0.9rem;
            transition: transform 0.2s;
        }

        .back-link:hover {
            background: #e6edf4;
            color: #1a475c;
            border-color: #cbdde6;
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.02);
        }

        .back-link:hover i {
            transform: translateX(-3px);
        }

        /* 响应式设计: 小屏幕表格更加紧凑易读 */
        @media (max-width: 680px) {
            body {
                padding: 1rem;
            }
            .page-header h2 {
                font-size: 1.5rem;
            }
            .page-header {
                padding: 1.2rem 1.2rem 0.5rem 1.2rem;
            }
            .table-wrapper {
                padding: 0.8rem 1rem 1.2rem 1rem;
            }
            .room-table th,
            .room-table td {
                padding: 0.75rem 0.8rem;
                font-size: 0.85rem;
            }
            .status-badge {
                padding: 0.2rem 0.6rem;
                font-size: 0.75rem;
            }
            .footer-action {
                padding: 1rem 1.2rem 1.5rem 1.2rem;
            }
        }

        /* 轻微动画点缀 */
        @keyframes fadeSlideUp {
            from {
                opacity: 0;
                transform: translateY(8px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .container {
            animation: fadeSlideUp 0.35s ease-out;
        }

        /* 额外工具类：用于辅助定位，不改动任何逻辑 */
        .room-table td:nth-child(4) .status-badge i {
            /* 图标准备 */
        }
    </style>
</head>
<body>

<div class="container">
    <div class="page-header">
        <h2>
            <i class="fas fa-door-open"></i>
            客房状态全景
        </h2>
        <div class="subtitle">
        </div>
    </div>

    <div class="table-wrapper">
        <%
            // 从request中获取房间列表，完全保留原始业务逻辑
            List<Room> rooms = (List<Room>) request.getAttribute("rooms");
        %>
        <table class="room-table">
            <thead>
                <tr>
                    <th><i class="fas fa-hashtag" style="font-size: 0.75rem; margin-right: 6px;"></i> 房间号</th>
                    <th><i class="fas fa-bed" style="font-size: 0.75rem; margin-right: 6px;"></i> 房型</th>
                    <th><i class="fas fa-tag" style="font-size: 0.75rem; margin-right: 6px;"></i> 价格</th>
                    <th><i class="fas fa-info-circle" style="font-size: 0.75rem; margin-right: 6px;"></i> 当前状态</th>
                </tr>
            </thead>
            <tbody>
            <%
                // 完全保留原有JSP逻辑，未做任何变更，仅增加辅助图标展示（无Emoji）
                if (rooms != null && !rooms.isEmpty()) {
                    for (Room room : rooms) {
                        // 原有的行内背景色条件判断不变，保留所有逻辑
                        String rowBgColor = "";
                        if ("Occupied".equals(room.getStatus())) {
                            rowBgColor = "#ffdddd";
                        } else {
                            rowBgColor = "#ddffdd";
                        }
            %>
            <tr style="background-color: <%= rowBgColor %>;">
                <td><%= room.getRoomNumber() %></td>
                <td><%= room.getTypeName() %></td>
                <td>¥<%= room.getPrice() %></td>
                <td>
                    <span class="status-badge">
                        <% if ("Occupied".equals(room.getStatus())) { %>
                            <i class="fas fa-lock" style="color:#b1624b;"></i>
                        <% } else { %>
                            <i class="fas fa-check-circle" style="color:#3a7b5c;"></i>
                        <% } %>
                        <%= room.getStatus() %>
                    </span>
                </td>
            </tr>
            <%
                    }
                } else {
            %>
                <tr class="empty-row">
                    <td colspan="4">
                        <div class="empty-message">
                            <i class="fas fa-building"></i>
                            <span>暂时没有找到任何房间信息</span>
                            <small style="font-size:0.85rem; color:#8aa0b5;">请检查数据源或稍后重试</small>
                        </div>
                    </td>
                </tr>
            <%
                }
            %>
            </tbody>
        </table>
    </div>

    <div class="footer-action">
        <a href="${pageContext.request.contextPath}/index" class="back-link">
            <i class="fas fa-arrow-left"></i>
            返回首页
        </a>
    </div>
</div>

<script>
    (function() {
        var rows = document.querySelectorAll('.room-table tbody tr');
        for (var i = 0; i < rows.length; i++) {
            var row = rows[i];
            var bgColor = row.style.backgroundColor;
            if (bgColor === 'rgb(255, 221, 221)' || bgColor === '#ffdddd' || bgColor === '#ffdddd') {

                row.style.backgroundColor = '#fff1f0';
            } else if (bgColor === 'rgb(221, 255, 221)' || bgColor === '#ddffdd' || bgColor === '#ddffdd') {

                row.style.backgroundColor = '#effaf3';
            }
            var statusCell = row.cells[3];
            if (statusCell) {
                var statusText = statusCell.innerText.trim();
                if (statusText.indexOf('Occupied') !== -1) {
                    row.setAttribute('data-room-status', 'occupied');
                } else {
                    row.setAttribute('data-room-status', 'available');
                }
            }
        }
        /
    })();
</script>

</body>
</html>