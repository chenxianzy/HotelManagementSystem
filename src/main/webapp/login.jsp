<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover">
    <title>登录 | 酒店管理系统</title>

    <!-- 现代字体系统 -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:opsz,wght@14..32,300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Font Awesome 6 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
            background: linear-gradient(145deg, #1a5f4c 0%, #1a3f35 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 1.5rem;
        }

        /* 登录卡片 */
        .login-container {
            max-width: 460px;
            width: 100%;
            animation: fadeInUp 0.5s ease-out;
        }

        .login-card {
            background: #ffffff;
            border-radius: 40px;
            overflow: hidden;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.3);
        }

        /* 头部装饰 */
        .login-header {
            background: linear-gradient(135deg, #22664e, #1a4f3c);
            padding: 2rem 2rem 1.8rem;
            text-align: center;
        }

        .hotel-icon {
            width: 70px;
            height: 70px;
            background: rgba(255, 255, 255, 0.15);
            border-radius: 30px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
        }

        .hotel-icon i {
            font-size: 2.2rem;
            color: white;
        }

        .login-header h1 {
            color: white;
            font-size: 1.6rem;
            font-weight: 700;
            letter-spacing: -0.01em;
            margin-bottom: 0.25rem;
        }

        .login-header p {
            color: rgba(255, 255, 255, 0.7);
            font-size: 0.85rem;
        }

        /* 表单区域 */
        .login-form {
            padding: 2rem 2rem 1.8rem;
        }

        .input-group {
            margin-bottom: 1.2rem;
        }

        .input-group label {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.8rem;
            font-weight: 500;
            color: #4f6f82;
            margin-bottom: 0.5rem;
        }

        .input-group label i {
            width: 20px;
            color: #2c8b72;
        }

        .input-field {
            position: relative;
        }

        .input-field input {
            width: 100%;
            padding: 0.9rem 1rem;
            border: 1.5px solid #e2eaf0;
            border-radius: 20px;
            font-size: 0.95rem;
            font-family: 'Inter', sans-serif;
            transition: all 0.2s;
            outline: none;
        }

        .input-field input:focus {
            border-color: #2c8b72;
            box-shadow: 0 0 0 3px rgba(44, 139, 114, 0.1);
        }

        /* 角色选择 */
        .role-group {
            margin-bottom: 1.5rem;
        }

        .role-label {
            font-size: 0.8rem;
            font-weight: 500;
            color: #4f6f82;
            margin-bottom: 0.6rem;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .role-label i {
            color: #2c8b72;
        }

        .role-options {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 0.6rem;
        }

        .role-option {
            position: relative;
            cursor: pointer;
        }

        .role-option input {
            position: absolute;
            opacity: 0;
            width: 0;
            height: 0;
        }

        .role-card {
            background: #f8fafc;
            border: 1.5px solid #e2eaf0;
            border-radius: 18px;
            padding: 0.7rem 0.3rem;
            text-align: center;
            transition: all 0.2s;
            cursor: pointer;
        }

        .role-card i {
            font-size: 1.3rem;
            color: #8ba3b5;
            margin-bottom: 0.25rem;
            display: block;
        }

        .role-card span {
            font-size: 0.7rem;
            font-weight: 500;
            color: #5f7e93;
        }

        .role-option input:checked + .role-card {
            background: #ecfdf5;
            border-color: #2c8b72;
        }

        .role-option input:checked + .role-card i {
            color: #2c8b72;
        }

        .role-option input:checked + .role-card span {
            color: #22664e;
        }

        /* 登录按钮 */
        .login-btn {
            width: 100%;
            background: linear-gradient(135deg, #2c8b72, #22664e);
            color: white;
            border: none;
            padding: 1rem;
            font-size: 1rem;
            font-weight: 600;
            border-radius: 44px;
            cursor: pointer;
            transition: all 0.25s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            font-family: 'Inter', sans-serif;
            margin-top: 0.5rem;
        }

        .login-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(34, 102, 78, 0.3);
        }

        /* 错误提示 */
        .error-message {
            background: #fff5f2;
            border-left: 3px solid #e28c6e;
            padding: 0.7rem 1rem;
            border-radius: 16px;
            margin-bottom: 1.2rem;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 0.8rem;
            color: #bc5a42;
        }

        /* 演示账号提示 */
        .demo-note {
            margin-top: 1.2rem;
            padding-top: 1rem;
            border-top: 1px solid #eef2f8;
            text-align: center;
        }

        .demo-note p {
            font-size: 0.7rem;
            color: #8ba3b5;
        }

        /* 注册链接 */
        .register-link {
            text-align: center;
            margin-top: 1rem;
            padding-top: 0.5rem;
            font-size: 0.8rem;
        }

        .register-link a {
            color: #2c8b72;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.2s;
        }

        .register-link a:hover {
            color: #1a5f4c;
            text-decoration: underline;
        }

        /* 动画 */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @media (max-width: 480px) {
            body {
                padding: 1rem;
            }
            .login-form {
                padding: 1.5rem;
            }
            .role-options {
                gap: 0.4rem;
            }
            .role-card {
                padding: 0.5rem 0.2rem;
            }
            .role-card i {
                font-size: 1rem;
            }
            .role-card span {
                font-size: 0.6rem;
            }
        }
    </style>
</head>
<body>

<div class="login-container">
    <div class="login-card">
        <div class="login-header">
            <div class="hotel-icon">
                <i class="fas fa-hotel"></i>
            </div>
            <h1>酒店管理系统</h1>
            <p>请登录以继续</p>
        </div>

        <div class="login-form">
            <%
                String errorMsg = (String) request.getAttribute("errorMsg");
                if (errorMsg != null && !errorMsg.isEmpty()) {
            %>
            <div class="error-message">
                <i class="fas fa-exclamation-circle"></i>
                <span><%= errorMsg %></span>
            </div>
            <% } %>

            <form action="${pageContext.request.contextPath}/login" method="post">
                <div class="input-group">
                    <label><i class="fas fa-user"></i> 用户名</label>
                    <div class="input-field">
                        <input type="text" name="username" placeholder="请输入用户名" required autofocus>
                    </div>
                </div>

                <div class="input-group">
                    <label><i class="fas fa-lock"></i> 密码</label>
                    <div class="input-field">
                        <input type="password" name="password" placeholder="请输入密码" required>
                    </div>
                </div>

                <div class="role-group">
                    <div class="role-label">
                        <i class="fas fa-users"></i> 选择角色
                    </div>
                    <div class="role-options">
                        <label class="role-option">
                            <input type="radio" name="role" value="guest" checked>
                            <div class="role-card">
                                <i class="fas fa-user"></i>
                                <span>顾客</span>
                            </div>
                        </label>
                        <label class="role-option">
                            <input type="radio" name="role" value="staff">
                            <div class="role-card">
                                <i class="fas fa-user-tie"></i>
                                <span>前台</span>
                            </div>
                        </label>
                        <label class="role-option">
                            <input type="radio" name="role" value="manager">
                            <div class="role-card">
                                <i class="fas fa-crown"></i>
                                <span>前台经理</span>
                            </div>
                        </label>
                    </div>
                </div>

                <button type="submit" class="login-btn">
                    <i class="fas fa-sign-in-alt"></i> 登录
                </button>
            </form>

            <div class="demo-note">
                <p><i class="fas fa-info-circle"></i> 演示账号：任意用户名 + 任意密码，选择角色即可登录</p>
            </div>

            <div class="register-link">
                还没有账号？ <a href="/HotelManagementSystem/register">立即注册</a>
            </div>
        </div>
    </div>
</div>

</body>
</html>