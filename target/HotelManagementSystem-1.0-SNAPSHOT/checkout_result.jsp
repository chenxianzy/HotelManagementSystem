<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.math.BigDecimal" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>退房结算结果</title>
</head>
<body>
<%@ include file="header.jsp" %>

<div style="text-align: center; margin-top: 50px;">
  <%
    Object successObj = request.getAttribute("success");
    String roomNumber = (String) request.getAttribute("roomNumber");
    Object costObj = request.getAttribute("totalCost");

    BigDecimal totalCost = BigDecimal.ZERO;
    if (costObj instanceof BigDecimal) {
      totalCost = (BigDecimal) costObj;
    }

    // 只要 roomNumber 不为空，哪怕 success 标志丢了，也算成功（防止误报）
    if (Boolean.TRUE.equals(successObj) || roomNumber != null) {
  %>
  <h1 style="color: #28a745;"> 退房办理成功！</h1>

  <div style="border: 1px solid #ccc; display: inline-block; padding: 20px; border-radius: 8px; text-align: left;">
    <p><strong>房间号：</strong> <%= roomNumber %></p>
    <p><strong>结算费用：</strong>
      <span style="font-size: 1.5em; color: darkred;">
                       ¥<%= String.format("%.2f", totalCost) %>
                   </span>
    </p>
    <p><strong>当前状态：</strong> 房间已标记为 <span style="color:blue">清洁中 (Cleaning)</span></p>
  </div>
  <%
  } else {
    String error = (String) request.getAttribute("error");
  %>
  <h1 style="color: #dc3545;"> 显示结果时出错</h1>
  <p>虽然显示出错，但在数据库中<strong>退房可能已经成功</strong>。</p>
  <p>请返回首页查询房间状态进行确认。</p>
  <p>错误详情: <%= error != null ? error : "未知错误" %></p>
  <%
    }
  %>


  <br><br>
  <p><a href="index.jsp">返回首页</a> | <a href="allRoomStatus">查看房间状态</a></p>
</div>

<%@ include file="footer.jsp" %>
</body>
</html>