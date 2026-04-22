<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.example.hotelmanagementsystem.model.Room" %>
<%@ page import="com.example.hotelmanagementsystem.model.User" %>
<%
    User currentUser = (User) session.getAttribute("user");
    String userRole = currentUser != null ? currentUser.getRole() : "guest";
    boolean isStaffOrManager = "staff".equals(userRole) || "manager".equals(userRole);
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover">
    <title>房间状态管理 | 酒店管理系统</title>

    <link href="https://fonts.googleapis.com/css2?family=Inter:opsz,wght@14..32,300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(145deg, #f1f6fb 0%, #e8f0f5 100%);
            color: #1e2f3c;
            line-height: 1.5;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        .container { max-width: 1400px; margin: 0 auto; padding: 2rem 1.5rem; flex: 1; }
        .page-header { margin-bottom: 1.8rem; text-align: center; }
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
        .subtitle { color: #5f7e93; font-size: 0.9rem; margin-top: 8px; }
        .table-wrapper {
            background: white;
            border-radius: 28px;
            overflow-x: auto;
            box-shadow: 0 4px 12px rgba(0,0,0,0.04);
            border: 1px solid #eef2f7;
        }
        .room-table { width: 100%; border-collapse: collapse; font-size: 0.9rem; }
        .room-table th {
            text-align: left;
            padding: 1rem 1.2rem;
            background: #f8fafd;
            font-weight: 600;
            font-size: 0.85rem;
            color: #3a5a6e;
            border-bottom: 1px solid #e6edf4;
        }
        .room-table td { padding: 1rem 1.2rem; border-bottom: 1px solid #eff3f8; vertical-align: middle; }
        .room-table tbody tr:hover { background-color: #fefce8; }

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

        .status-select {
            padding: 0.5rem 0.8rem;
            border: 1.5px solid #e2eaf0;
            border-radius: 12px;
            font-size: 0.8rem;
            font-family: 'Inter', sans-serif;
            cursor: pointer;
        }
        .update-btn {
            background: #2c8b72;
            color: white;
            border: none;
            padding: 0.4rem 1rem;
            border-radius: 20px;
            font-size: 0.7rem;
            cursor: pointer;
            transition: all 0.2s;
            margin-left: 8px;
        }
        .update-btn:hover { background: #22664e; transform: translateY(-1px); }
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
            margin-top: 1.5rem;
        }
        .toast-msg {
            position: fixed;
            bottom: 30px;
            right: 30px;
            background: #2c8b72;
            color: white;
            padding: 0.8rem 1.5rem;
            border-radius: 50px;
            font-size: 0.85rem;
            display: none;
            z-index: 1000;
        }
        .toast-msg.error { background: #c96a52; }
        @keyframes slideIn {
            from { transform: translateX(100px); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }
    </style>
</head>
<body>
<%@ include file="header.jsp" %>

<div class="container">
    <div class="page-header">
        <h2><i class="fas fa-door-open"></i> 房间状态管理</h2>
        <div class="subtitle">实时查看房间状态 · 支持手动修改房间状态</div>
    </div>

    <div class="table-wrapper">
        <%
            List<Room> rooms = (List<Room>) request.getAttribute("rooms");
            String error = (String) request.getAttribute("error");
        %>
        <% if (error != null) { %>
            <div style="padding: 2rem; text-align: center; color: #bc5a42;">
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
                        <% if (isStaffOrManager) { %>
                            <th><i class="fas fa-cog"></i> 修改状态</th>
                        <% } %>
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
                %>
                    <tr data-room-id="<%= room.getRoomId() %>" data-room-number="<%= room.getRoomNumber() %>">
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
                        <% if (isStaffOrManager) { %>
                            <td>
                                <select class="status-select" data-room-id="<%= room.getRoomId() %>">
                                    <option value="Available" <%= "Available".equals(status) ? "selected" : "" %>>空闲</option>
                                    <option value="Occupied" <%= "Occupied".equals(status) ? "selected" : "" %>>已入住</option>
                                    <option value="Reserved" <%= "Reserved".equals(status) ? "selected" : "" %>>已预订</option>
                                    <option value="Cleaning" <%= "Cleaning".equals(status) ? "selected" : "" %>>清洁中</option>
                                    <option value="Maintenance" <%= "Maintenance".equals(status) ? "selected" : "" %>>维修中</option>
                                </select>
                                <button class="update-btn" onclick="updateRoomStatus(this)">更新</button>
                            </td>
                        <% } %>
                    </tr>
                <%
                    }
                %>
                </tbody>
            </table>
        <% } else { %>
            <div style="padding: 3rem; text-align: center; color: #6c879c;">
                <i class="fas fa-inbox" style="font-size: 2rem;"></i>
                <p>没有找到任何房间信息。</p>
            </div>
        <% } %>
    </div>

    <div style="text-align: center;">
        <a href="index.jsp" class="back-link"><i class="fas fa-arrow-left"></i> 返回首页</a>
    </div>
</div>

<div id="toastMsg" class="toast-msg"></div>

<%@ include file="footer.jsp" %>

<script>
    function showMessage(msg, isError) {
        var toast = document.getElementById('toastMsg');
        toast.textContent = msg;
        toast.className = 'toast-msg' + (isError ? ' error' : '');
        toast.style.display = 'block';
        toast.style.animation = 'slideIn 0.3s ease';
        setTimeout(function() {
            toast.style.display = 'none';
        }, 3000);
    }

    function updateRoomStatus(btn) {
        var row = btn.closest('tr');
        var select = row.querySelector('.status-select');
        var roomId = select.getAttribute('data-room-id');
        var newStatus = select.value;
        var roomNumber = row.querySelector('td:first-child').innerText;

        var statusText = {
            'Available': '空闲',
            'Occupied': '已入住',
            'Reserved': '已预订',
            'Cleaning': '清洁中',
            'Maintenance': '维修中'
        };

        if (confirm('确定将房间 ' + roomNumber + ' 的状态改为 "' + statusText[newStatus] + '" 吗？')) {
            fetch('${pageContext.request.contextPath}/updateRoomStatus', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'roomId=' + encodeURIComponent(roomId) + '&status=' + encodeURIComponent(newStatus)
            })
            .then(function(response) { return response.json(); })
            .then(function(result) {
                if (result.success) {
                    showMessage('房间 ' + roomNumber + ' 状态已更新为 ' + statusText[newStatus], false);
                    // 更新页面上的状态显示
                    var statusCell = row.querySelector('td:nth-child(4) .status-badge');
                    var iconClass = '';
                    var badgeClass = '';
                    if (newStatus === 'Available') {
                        iconClass = 'fas fa-check-circle';
                        badgeClass = 'status-available';
                    } else if (newStatus === 'Occupied') {
                        iconClass = 'fas fa-user';
                        badgeClass = 'status-occupied';
                    } else if (newStatus === 'Reserved') {
                        iconClass = 'fas fa-calendar-check';
                        badgeClass = 'status-reserved';
                    } else if (newStatus === 'Cleaning') {
                        iconClass = 'fas fa-broom';
                        badgeClass = 'status-cleaning';
                    } else {
                        iconClass = 'fas fa-tools';
                        badgeClass = 'status-maintenance';
                    }
                    statusCell.className = 'status-badge ' + badgeClass;
                    statusCell.innerHTML = '<i class="' + iconClass + '"></i> ' + statusText[newStatus];
                } else {
                    showMessage(result.message || '更新失败', true);
                }
            })
            .catch(function(err) {
                console.error('Error:', err);
                showMessage('网络错误，请稍后重试', true);
            });
        }
    }
</script>
</body>
</html>