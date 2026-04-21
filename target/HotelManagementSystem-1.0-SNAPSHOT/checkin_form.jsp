<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.example.hotelmanagementsystem.model.Room" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>办理入住</title>
</head>
<body>
<%@ include file="header.jsp" %>

<div style="text-align: center; margin-top: 20px;">
    <h2>办理入住手续</h2>

    <%
        List<Room> availableRooms = (List<Room>) request.getAttribute("availableRooms");
        String error = (String) request.getAttribute("error");
    %>

    <% if (error != null) { %>
    <p style="color: red; font-weight: bold;">错误: <%= error %></p>
    <% } %>

    <form action="checkin" method="post" style="display: inline-block; text-align: left; border: 1px solid #ccc; padding: 20px; border-radius: 8px;">

        <p><strong>客人信息</strong></p>
        姓氏: <input type="text" name="firstName" required><br><br>
        名字: <input type="text" name="lastName" required><br><br>
        电话: <input type="text" name="phone" required><br><br>
        证件: <input type="text" name="idNumber" required><br><br>
        邮箱: <input type="email" name="email"><br><br>

        <p><strong>房间选择</strong></p>
        房间:
        <select name="roomNumber" required>
            <%
                if (availableRooms != null && !availableRooms.isEmpty()) {
                    for (Room room : availableRooms) {
            %>
            <option value="<%= room.getRoomId() %>">
                <%= room.getRoomNumber() %> (<%= room.getTypeName() %> - ¥<%= room.getPrice() %>)
            </option>
            <%
                }
            } else {
            %>
            <option value="" disabled selected>无可用房间</option>
            <%
                }
            %>
        </select>
        <br><br>

        日期: <input type="date" name="checkInDate" required>
        <br><br>

        <input type="submit" value="办理入住" style="background-color: #28a745; color: white; padding: 10px 20px; border: none; cursor: pointer;">
    </form>
</div>

<p style="text-align: center;"><a href="index.jsp">返回首页</a></p>
<%@ include file="footer.jsp" %>
</body>
</html>