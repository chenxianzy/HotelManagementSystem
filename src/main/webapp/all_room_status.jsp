<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.example.hotelmanagementsystem.model.Room" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover">
    <title>所有房间状态 | 酒店管理系统</title>

    <!-- 现代字体系统 -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:opsz,wght@14..32,300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Font Awesome 6 图标库 -->
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

        .container {
            max-width: 1280px;
            margin: 0 auto;
            padding: 2rem 1.5rem;
            flex: 1;
        }

        /* 头部 */
        .page-header {
            margin-bottom: 1.8rem;
            text-align: center;
        }

        .page-header h2 {
            font-size: 1.9rem;
            font-weight: 700;
            background: linear-gradient(145deg, #22664e, #2c8b72);
            background-clip: text;
            -webkit-background-clip: text;
            color: transparent;
            display: inline-flex;
            align-items: center;
            gap: 12px;
        }

        .page-header h2 i {
            color: #2c8b72;
            font-size: 1.8rem;
        }

        .subtitle {
            color: #5f7e93;
            font-size: 0.9rem;
            margin-top: 8px;
            border-left: 3px solid #48b5a0;
            padding-left: 14px;
            display: inline-block;
        }

        /* 表格容器 */
        .table-wrapper {
            background: #ffffff;
            border-radius: 28px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.04);
            overflow-x: auto;
            border: 1px solid #eef2f7;
        }

        .room-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.9rem;
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
        }

        .room-table td {
            padding: 1rem 1.2rem;
            border-bottom: 1px solid #eff3f8;
            vertical-align: middle;
        }

        .room-table tbody tr:hover {
            background-color: #fefce8;
        }

        /* 状态标签 */
        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 0.3rem 1rem;
            border-radius: 40px;
            font-size: 0.8rem;
            font-weight: 500;
        }

        .status-available { background: #e0f2e9; color: #2a785e; }
        .status-occupied { background: #ffe6e1; color: #b34e3a; }
        .status-reserved { background: #fff0c8; color: #b87c2e; }
        .status-cleaning { background: #e2edf9; color: #3f6b8c; }
        .status-maintenance { background: #eceef2; color: #6f7a86; }

        /* 操作按钮 */
        .action-btn {
            background: #f0f5f9;
            border: 1px solid #dee9ef;
            padding: 0.45rem 1rem;
            border-radius: 40px;
            font-size: 0.75rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            color: #2f6e5a;
        }

        .action-btn i {
            font-size: 0.7rem;
        }

        .action-btn:hover {
            background: #2c8b72;
            border-color: #2c8b72;
            color: white;
            transform: translateY(-1px);
        }

        /* 提示消息 */
        .toast-msg {
            position: fixed;
            bottom: 30px;
            right: 30px;
            background: #2c8b72;
            color: white;
            padding: 0.8rem 1.5rem;
            border-radius: 50px;
            font-size: 0.85rem;
            font-weight: 500;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
            z-index: 1000;
            animation: slideIn 0.3s ease;
            display: none;
        }

        .toast-msg.error {
            background: #c96a52;
        }

        @keyframes slideIn {
            from { transform: translateX(100px); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }

        /* 空状态 */
        .empty-state {
            text-align: center;
            padding: 3rem;
            color: #6c879c;
        }

        /* 底部链接 */
        .footer-action {
            margin-top: 1.5rem;
            text-align: center;
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

        .back-link:hover {
            background: #e6edf4;
            color: #1c5a48;
            transform: translateY(-2px);
        }

        /* 响应式 */
        @media (max-width: 768px) {
            .container { padding: 1rem; }
            .room-table th, .room-table td { padding: 0.7rem 0.8rem; }
            .action-btn { padding: 0.3rem 0.7rem; font-size: 0.7rem; }
        }
    </style>
</head>
<body>

<%@ include file="header.jsp" %>

<div class="container">
    <div class="page-header">
        <h2><i class="fas fa-door-open"></i> 所有房间状态查询结果</h2>
        <div class="subtitle">实时查看房间状态 · 支持将清洁/维修中房间设为空闲</div>
    </div>

    <div class="table-wrapper">
        <%
            List<Room> rooms = (List<Room>) request.getAttribute("rooms");
            String error = (String) request.getAttribute("error");
        %>

        <% if (error != null) { %>
            <div class="empty-state" style="color: #bc5a42;">
                <i class="fas fa-exclamation-triangle" style="font-size: 2rem;"></i>
                <p>错误: <%= error %></p>
            </div>
        <% } else if (rooms != null && !rooms.isEmpty()) { %>
            <table class="room-table">
                <thead>
                    <tr>
                        <th><i class="fas fa-hashtag"></i> 房间号</th>
                        <th><i class="fas fa-bed"></i> 房型</th>
                        <th><i class="fas fa-tag"></i> 价格</th>
                        <th><i class="fas fa-info-circle"></i> 当前状态</th>
                        <th><i class="fas fa-cog"></i> 操作</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    for (Room room : rooms) {
                        String status = room.getStatus();
                        String badgeClass;
                        String displayStatus;

                        if ("Available".equals(status)) {
                            badgeClass = "status-available";
                            displayStatus = "空闲";
                        } else if ("Occupied".equals(status)) {
                            badgeClass = "status-occupied";
                            displayStatus = "已入住";
                        } else if ("Reserved".equals(status)) {
                            badgeClass = "status-reserved";
                            displayStatus = "已预订";
                        } else if ("Cleaning".equals(status)) {
                            badgeClass = "status-cleaning";
                            displayStatus = "清洁中";
                        } else if ("Maintenance".equals(status)) {
                            badgeClass = "status-maintenance";
                            displayStatus = "维修中";
                        } else {
                            badgeClass = "status-maintenance";
                            displayStatus = status;
                        }

                        // 判断是否显示“设为空闲”按钮（仅清洁中或维修中）
                        boolean showSetAvailableBtn = "Cleaning".equals(status) || "Maintenance".equals(status);
                %>
                    <tr data-room-id="<%= room.getRoomId() %>" data-room-number="<%= room.getRoomNumber() %>" data-current-status="<%= status %>">
                        <td><strong><%= room.getRoomNumber() %></strong></td>
                        <td><%= room.getTypeName() %></td>
                        <td>¥<%= String.format("%.2f", room.getPrice()) %></td>
                        <td>
                            <span class="status-badge <%= badgeClass %>">
                                <i class="<%= "Available".equals(status) ? "fas fa-check-circle" :
                                           "Occupied".equals(status) ? "fas fa-user" :
                                           "Reserved".equals(status) ? "fas fa-calendar-check" :
                                           "Cleaning".equals(status) ? "fas fa-broom" : "fas fa-tools" %>"></i>
                                <%= displayStatus %>
                            </span>
                        </td>
                        <td>
                            <% if (showSetAvailableBtn) { %>
                                <button class="action-btn set-available-btn"
                                        data-room-id="<%= room.getRoomId() %>"
                                        data-room-number="<%= room.getRoomNumber() %>">
                                    <i class="fas fa-check-circle"></i> 设为空闲
                                </button>
                            <% } else { %>
                                <span style="color: #b7cdde; font-size: 0.75rem;">—</span>
                            <% } %>
                        </td>
                    </tr>
                <%
                    }
                %>
                </tbody>
            </table>
        <% } else { %>
            <div class="empty-state">
                <i class="fas fa-inbox" style="font-size: 2rem; color: #bdd4e2;"></i>
                <p>没有找到任何房间信息。</p>
            </div>
        <% } %>
    </div>

    <div class="footer-action">
        <a href="index.jsp" class="back-link">
            <i class="fas fa-arrow-left"></i> 返回首页
        </a>
    </div>
</div>

<!-- 提示浮层 -->
<div id="toastMsg" class="toast-msg"></div>

<%@ include file="footer.jsp" %>

<script>
    (function() {
        // 获取所有“设为空闲”按钮
        const buttons = document.querySelectorAll('.set-available-btn');
        const toast = document.getElementById('toastMsg');

        function showMessage(msg, isError) {
            toast.textContent = msg;
            toast.className = 'toast-msg' + (isError ? ' error' : '');
            toast.style.display = 'block';
            setTimeout(() => {
                toast.style.display = 'none';
            }, 3000);
        }

        async function setRoomAvailable(roomId, roomNumber, rowElement) {
            try {
                const response = await fetch('updateRoomStatus', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'roomId=' + encodeURIComponent(roomId) + '&status=Available'
                });

                const result = await response.json();

                if (result.success) {
                    showMessage('房间 ' + roomNumber + ' 已设为空闲', false);

                    // 更新页面上的状态显示
                    const statusCell = rowElement.querySelector('td:nth-child(4) .status-badge');
                    if (statusCell) {
                        statusCell.className = 'status-badge status-available';
                        statusCell.innerHTML = '<i class="fas fa-check-circle"></i> 空闲';
                    }

                    // 隐藏操作按钮
                    const btn = rowElement.querySelector('.set-available-btn');
                    if (btn) {
                        btn.remove();
                    }

                    // 更新行数据属性
                    rowElement.setAttribute('data-current-status', 'Available');

                    // 在操作列显示占位符
                    const actionCell = rowElement.querySelector('td:nth-child(5)');
                    if (actionCell && !actionCell.querySelector('.set-available-btn')) {
                        actionCell.innerHTML = '<span style="color: #b7cdde; font-size: 0.75rem;">—</span>';
                    }
                } else {
                    showMessage(result.message || '操作失败，请重试', true);
                }
            } catch (err) {
                console.error('Error:', err);
                showMessage('网络错误，请稍后重试', true);
            }
        }

        // 绑定点击事件
        buttons.forEach(btn => {
            btn.addEventListener('click', function(e) {
                e.preventDefault();
                const roomId = this.getAttribute('data-room-id');
                const roomNumber = this.getAttribute('data-room-number');
                const rowElement = this.closest('tr');

                if (confirm(`确定将房间 ${roomNumber} 的状态设为“空闲”吗？`)) {
                    setRoomAvailable(roomId, roomNumber, rowElement);
                }
            });
        });
    })();
</script>

</body>
</html>