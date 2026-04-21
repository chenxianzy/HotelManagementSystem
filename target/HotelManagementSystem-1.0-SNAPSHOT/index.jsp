<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>系统主菜单</title>
</head>
<body>
<%@ include file="header.jsp" %>

<h2>系统主菜单</h2>

<ul class="main-menu-list">
    <li>
        <h3> 办理入住 </h3>
        <p>为客人办理入住手续，并登记订单记录</p>
        <a href="checkinForm">前往办理入住</a>
    </li>
    <li>
        <h3> 房间状态查询 </h3>
        <p>查看酒店内所有房间的详细状态（空闲/已入住/清洁中）</p>
        <a href="allRoomStatus">查询所有房间状态</a>
    </li>
    <li>
        <h3> 空闲房间查询 </h3>
        <p>快速查询当前所有可供客人入住的空闲房间</p>
        <a href="rooms/status">查询空闲房间</a>
    </li>
    <li>
        <h3> 办理退房 </h3>
        <p>为客人结算费用并办理退房手续（待开发）</p>
        <a href="checkout">办理退房</a>
    </li>
</ul>

<%@ include file="footer.jsp" %>