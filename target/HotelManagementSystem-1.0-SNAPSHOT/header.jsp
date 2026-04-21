<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
  body {
    font-family: Arial, sans-serif;
    margin: 0;
    padding: 0;
    background-color: #f4f4f4;
    /* 【关键修正 1】：让主体文字默认居中 */
    text-align: center;
  }

  /* 头部条：内容居中 */
  .header-bar {
    background-color: #333;
    color: white;
    padding: 15px 30px;
    display: flex;
    /* 让标题在头部居中 */
    justify-content: center;
    align-items: center;
  }
  .header-bar h1 { margin: 0; font-size: 1.5em; }

  /* 内容容器 */
  .container {
    width: 80%;
    max-width: 900px; /* 增加最大宽度限制 */
    margin: 30px auto; /* 保持容器本身在页面中央 */
    padding: 20px;
    background-color: white;
    border-radius: 8px;
    box-shadow: 0 0 10px rgba(0,0,0,0.1);
    /* 【关键修正 2】：覆盖 text-align: center; 以便内部元素保持居中，但不影响块级元素 */
    text-align: center;
  }

  /* 菜单列表的样式 */
  .main-menu-list {
    list-style: none;
    padding: 0;
    /* 关键：让列表本身居中，而不是让列表项居中 */
    display: inline-block;
    text-align: left; /* 保持列表内的文字左对齐，但列表块本身居中 */
  }

  .main-menu-list li {
    margin: 15px 0;
    padding: 10px;
    background-color: #f0f8ff;
    border: 1px solid #cceeff;
    border-radius: 5px;
  }
  .main-menu-list a {
    text-decoration: none;
    color: #007bff;
    font-weight: bold;
    display: block;
    padding: 5px 0;
  }
  .main-menu-list a:hover {
    text-decoration: underline;
  }
</style>
<div class="header-bar">
  <h1>酒店管理系统</h1>
</div>
<div class="container">