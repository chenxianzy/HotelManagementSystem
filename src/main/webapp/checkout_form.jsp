<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.example.hotelmanagementsystem.model.Room" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>办理退房</title>
</head>
<body>
<%@ include file="header.jsp" %>

<div style="text-align: center; margin-top: 20px;">
  <h2>办理退房手续</h2>

  <%
    List<Room> occupiedRooms = (List<Room>) request.getAttribute("occupiedRooms");
    String error = (String) request.getAttribute("error");
  %>

  <% if (error != null) { %>
  <p style="color: red; font-weight: bold;">错误: <%= error %></p>
  <% } %>

  <form action="checkout" method="post" style="display: inline-block; text-align: left; border: 1px solid #ccc; padding: 20px; border-radius: 8px;">

    <p><strong>请选择要退房的房间：</strong></p>
    <select name="roomID" required style="padding: 5px; width: 200px;">
      <%
        if (occupiedRooms != null && !occupiedRooms.isEmpty()) {
          for (Room room : occupiedRooms) {
      %>
      <option value="<%= room.getRoomId() %>">
        <%= room.getRoomNumber() %> (当前状态: <%= room.getStatus() %>)
      </option>
      <%
        }
      } else {
      %>
      <option value="" disabled selected>无房间可退</option>
      <%
        }
      %>
    </select>
    <br><br>

    <input type="submit" value="确认退房 & 结算" style="background-color: #d9534f; color: white; padding: 10px 20px; border: none; cursor: pointer;">
  </form>
</div>

<p style="text-align: center;"><a href="index.jsp">返回首页</a></p>
<%@ include file="footer.jsp" %>
</body>
</html>