<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户注册 | 酒店管理系统</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(145deg, #1a5f4c 0%, #1a3f35 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 1.5rem;
        }
        .register-container { max-width: 500px; width: 100%; animation: fadeInUp 0.5s ease-out; }
        .register-card {
            background: white;
            border-radius: 40px;
            overflow: hidden;
            box-shadow: 0 25px 50px -12px rgba(0,0,0,0.3);
        }
        .register-header {
            background: linear-gradient(135deg, #22664e, #1a4f3c);
            padding: 2rem;
            text-align: center;
        }
        .register-header h1 { color: white; font-size: 1.6rem; margin-bottom: 0.25rem; }
        .register-header p { color: rgba(255,255,255,0.7); font-size: 0.85rem; }
        .register-form { padding: 2rem; }
        .input-group { margin-bottom: 1rem; }
        .input-group label {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.8rem;
            font-weight: 500;
            color: #4f6f82;
            margin-bottom: 0.5rem;
        }
        .input-group label i { color: #2c8b72; width: 20px; }
        .input-group input {
            width: 100%;
            padding: 0.85rem 1rem;
            border: 1.5px solid #e2eaf0;
            border-radius: 20px;
            font-size: 0.9rem;
            font-family: 'Inter', sans-serif;
            transition: all 0.2s;
            outline: none;
        }
        .input-group input:focus {
            border-color: #2c8b72;
            box-shadow: 0 0 0 3px rgba(44,139,114,0.1);
        }

        /* 角色提示信息 */
        .role-info {
            background: #ecfdf5;
            border-radius: 16px;
            padding: 0.8rem 1rem;
            margin-bottom: 1.2rem;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 0.75rem;
            color: #22664e;
        }
        .role-info i {
            font-size: 1rem;
        }

        .register-btn {
            width: 100%;
            background: linear-gradient(135deg, #2c8b72, #22664e);
            color: white;
            border: none;
            padding: 1rem;
            font-size: 1rem;
            font-weight: 600;
            border-radius: 44px;
            cursor: pointer;
            margin-top: 1rem;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        .register-btn:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(34,102,78,0.3); }
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
        .success-message {
            background: #ecfdf5;
            border-left: 3px solid #2c8b72;
            padding: 0.7rem 1rem;
            border-radius: 16px;
            margin-bottom: 1.2rem;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 0.8rem;
            color: #22664e;
        }
        .login-link {
            text-align: center;
            margin-top: 1.2rem;
            padding-top: 1rem;
            border-top: 1px solid #eef2f8;
            font-size: 0.8rem;
        }
        .login-link a { color: #2c8b72; text-decoration: none; font-weight: 500; }
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        @media (max-width: 480px) {
            .register-form { padding: 1.5rem; }
        }
    </style>
</head>
<body>
<div class="register-container">
    <div class="register-card">
        <div class="register-header">
            <h1>创建新账号</h1>
            <p>注册成为酒店会员</p>
        </div>
        <div class="register-form">
            <%
                String errorMsg = (String) request.getAttribute("errorMsg");
                String successMsg = (String) request.getAttribute("successMsg");
                if (errorMsg != null && !errorMsg.isEmpty()) {
            %>
            <div class="error-message"><i class="fas fa-exclamation-circle"></i><span><%= errorMsg %></span></div>
            <% } else if (successMsg != null && !successMsg.isEmpty()) { %>
            <div class="success-message"><i class="fas fa-check-circle"></i><span><%= successMsg %></span></div>
            <% } %>

            <!-- 角色提示 -->
            <div class="role-info">
                <i class="fas fa-info-circle"></i>
                <span>注册后默认为<b>顾客</b>角色，可查询房间状态。前台/经理账号由管理员后台创建。</span>
            </div>

            <form action="register" method="post">
                <div class="input-group">
                    <label><i class="fas fa-user"></i> 用户名 *</label>
                    <input type="text" name="username" placeholder="请输入用户名" required autofocus>
                </div>
                <div class="input-group">
                    <label><i class="fas fa-lock"></i> 密码 *</label>
                    <input type="password" name="password" placeholder="请输入密码" required>
                </div>
                <div class="input-group">
                    <label><i class="fas fa-lock"></i> 确认密码 *</label>
                    <input type="password" name="confirmPassword" placeholder="请再次输入密码" required>
                </div>
                <div class="input-group">
                    <label><i class="fas fa-phone"></i> 手机号</label>
                    <input type="tel" name="phone" placeholder="请输入手机号">
                </div>
                <div class="input-group">
                    <label><i class="fas fa-envelope"></i> 邮箱</label>
                    <input type="email" name="email" placeholder="请输入邮箱">
                </div>
                <div class="input-group">
                    <label><i class="fas fa-id-card"></i> 证件号码</label>
                    <input type="text" name="idNumber" placeholder="身份证/护照号">
                </div>

                <!-- 隐藏角色字段，固定为 guest -->
                <input type="hidden" name="role" value="guest">

                <button type="submit" class="register-btn"><i class="fas fa-user-plus"></i> 立即注册</button>
            </form>
            <div class="login-link">
                已有账号？ <a href="login">立即登录</a>
            </div>
        </div>
    </div>
</div>
</body>
</html>