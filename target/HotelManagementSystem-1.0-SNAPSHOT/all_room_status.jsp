<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.example.hotelmanagementsystem.model.Room" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>所有房间状态查询结果</title>
  <style>
    /* 样式代码：新增 Reserved 和 Cleaning 样式 */
    .occupied { background-color: #ffcccc; }   /* 已入住：红色 */
    .available { background-color: #ccffcc; }  /* 空闲：绿色 */
    .reserved { background-color: #ffffcc; }   /* 已预订：黄色 */
    .cleaning { background-color: #cceeff; }   /* 清洁中：蓝色 */

    table { border-collapse: collapse; width: 60%; margin: 20px auto; }
    th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
  </style>
</head>
<body>

<h2 style="text-align:center;">所有房间状态查询结果</h2>

<%
  List<Room> rooms = (List<Room>) request.getAttribute("rooms");
  String error = (String) request.getAttribute("error");
%>

<% if (error != null) { %>
<p style="color: red; text-align: center;">错误: <%= error %></p>
<% } else if (rooms != null && !rooms.isEmpty()) { %>
<table class="room-status-table">
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
    for (Room room : rooms) {
      String status = room.getStatus(); // 获取状态字符串

      String cssClass;
      String displayStatus;

      // 核心逻辑：根据状态设置 CSS 样式和中文显示文本
      if ("Occupied".equals(status)) {
        cssClass = "occupied";
        displayStatus = "已入住";
      } else if ("Available".equals(status)) {
        cssClass = "available";
        displayStatus = "空闲";
      } else if ("Reserved".equals(status)) { // 【新增】Reserved 状态
        cssClass = "reserved";
        displayStatus = "已预订";
      } else if ("Cleaning".equals(status)) { // 【新增】Cleaning 状态
        cssClass = "cleaning";
        displayStatus = "清洁中";
      } else {
        cssClass = "Maintenance"; // 默认无背景色
        displayStatus = "维护中"; // 打印原始状态
      }
  %>
  <tr class="<%= cssClass %>">
    <td><%= room.getRoomNumber() %></td>
    <td><%= room.getTypeName() %></td>
    <td>¥<%= String.format("%.2f", room.getPrice()) %></td>
    <td>
      <%= displayStatus %>
    </td>
  </tr>
  <%
    }
  %>
  </tbody>
</table>
<% } else { %>
<p style="text-align: center;">没有找到任何房间信息。</p>
<% } %>

<p style="text-align: center;"><a href="index.jsp">返回首页</a></p>

</body>
</html>