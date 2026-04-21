<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.example.hotelmanagementsystem.model.Room" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>所有房间状态查询结果</title>
</head>
<body>

<h2>所有房间状态查询结果</h2>

<% List<Room> rooms = (List<Room>) request.getAttribute("rooms"); %>

<table border="1">
    <thead>
    <tr>
        <th>房间号</th>
        <th>房型</th>
        <th>价格</th>
        <th>当前状态</th>
    </tr>
    </thead>
    <tbody>
    <%
        if (rooms != null && !rooms.isEmpty()) {
            for (Room room : rooms) {
    %>
    <tr style="background-color: <%= "Occupied".equals(room.getStatus()) ? "#ffdddd" : "#ddffdd" %>;">
        <td><%= room.getRoomNumber() %></td>
        <td><%= room.getTypeName() %></td>
        <td>¥<%= room.getPrice() %></td>
        <td><%= room.getStatus() %></td>
    </tr>
    <%
        }
    } else {
    %>
    <tr>
        <td colspan="4">没有找到任何房间信息。</td>
    </tr>
    <%
        }
    %>
    </tbody>
</table>

<p><a href="index.jsp">返回首页</a></p>

</body>
</html>