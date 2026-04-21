<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.example.hotelmanagementsystem.model.Room" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>空闲房间状态</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 50px; }
        h1 { color: #007bff; }
        table { width: 80%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: left; }
        th { background-color: #f2f2f2; }
        .error { color: red; font-weight: bold; }
    </style>
</head>
<body>
<h1> 空闲房间状态查询结果</h1>

<%
    // 尝试获取错误信息
    String errorMessage = (String) request.getAttribute("errorMessage");
    if (errorMessage != null) {
%>
<p class="error"><%= errorMessage %></p>
<%
} else {
    // 尝试获取房间列表
    List<Room> rooms = (List<Room>) request.getAttribute("rooms");

    if (rooms != null && !rooms.isEmpty()) {
%>
<p>当前共有 **<%= rooms.size() %>** 个房间处于空闲 (Available) 状态：</p>
<table>
    <thead>
    <tr>
        <th>房间号</th>
        <th>房间类型</th>
        <th>价格 (RMB/晚)</th>
        <th>状态</th>
    </tr>
    </thead>
    <tbody>
    <% for (Room room : rooms) { %>
    <tr>
        <td><strong><%= room.getRoomNumber() %></strong></td>
        <td><%= room.getTypeName() %></td>
        <td><%= room.getPrice() %></td>
        <td style="color: #28a745;"><%= room.getStatus() %></td>
    </tr>
    <% } %>
    </tbody>
</table>
<%
} else {
%>
<p style="color: orange; font-weight: bold;">抱歉，当前没有可供入住的空闲房间。</p>
<%
        }
    }
%>

<p style="margin-top: 30px;"><a href="${pageContext.request.contextPath}/index.jsp">返回首页</a></p>

</body>
</html>