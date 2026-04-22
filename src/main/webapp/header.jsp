<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.example.hotelmanagementsystem.model.User" %>
<%
    // 使用不同的变量名，避免与其他 JSP 冲突
    User headerUser = (User) session.getAttribute("user");
    String headerRole = (headerUser != null) ? headerUser.getRole() : "guest";
    String headerUsername = (headerUser != null) ? headerUser.getUsername() : "游客";
%>
<!DOCTYPE html>
<html>
<head>
    <style>
        .header {
            background: linear-gradient(135deg, #22664e, #1a4f3c);
            color: white;
            padding: 0.8rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1rem;
        }
        .logo {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 1.2rem;
            font-weight: 600;
        }
        .logo i {
            font-size: 1.5rem;
        }
        .user-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .user-info span {
            font-size: 0.85rem;
        }
        .role-badge {
            background: rgba(255,255,255,0.2);
            padding: 0.2rem 0.7rem;
            border-radius: 30px;
            font-size: 0.7rem;
        }
        .logout-btn {
            background: rgba(255,255,255,0.15);
            border: none;
            color: white;
            padding: 0.4rem 1rem;
            border-radius: 30px;
            cursor: pointer;
            font-size: 0.8rem;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: background 0.2s;
        }
        .logout-btn:hover {
            background: rgba(255,255,255,0.3);
        }
        @media (max-width: 600px) {
            .header {
                padding: 0.8rem 1rem;
                flex-direction: column;
                text-align: center;
            }
        }
    </style>
</head>
<body>
<div class="header">
    <div class="logo">
        <i class="fas fa-hotel"></i>
        <span>酒店管理系统</span>
    </div>
    <div class="user-info">
        <i class="fas fa-user-circle"></i>
        <span><%= headerUsername %></span>
        <span class="role-badge">
            <% if ("manager".equals(headerRole)) { %>
                前台经理
            <% } else if ("staff".equals(headerRole)) { %>
                前台
            <% } else { %>
                顾客
            <% } %>
        </span>
        <a href="${pageContext.request.contextPath}/logout" class="logout-btn">
            <i class="fas fa-sign-out-alt"></i> 退出
        </a>
    </div>
</div>
</body>
</html>