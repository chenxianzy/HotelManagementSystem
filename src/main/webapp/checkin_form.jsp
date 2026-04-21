<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.example.hotelmanagementsystem.model.Room" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover">
    <title>办理入住 | 酒店管理系统</title>

    <!-- 现代字体系统: Inter 优先，优雅降级 -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:opsz,wght@14..32,300;14..32,400;14..32,500;14..32,600;14..32,700&display=swap" rel="stylesheet">
    <!-- Font Awesome 6 图标库 (纯图标，无emoji) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <!-- flatpickr 日期选择器 (优雅的日历控件) -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/zh.js"></script>

    <style>
        /* ---------- 全局样式重置 ---------- */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
            background: linear-gradient(145deg, #f1f6fb 0%, #e8f0f5 100%);
            color: #1e2f3c;
            line-height: 1.5;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* 主容器 - 优雅卡片布局 */
        .checkin-wrapper {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 2rem 1.5rem;
        }

        .checkin-card {
            max-width: 560px;
            width: 100%;
            background: #ffffff;
            border-radius: 36px;
            box-shadow: 0 25px 45px -12px rgba(0, 0, 0, 0.15), 0 2px 10px rgba(0, 0, 0, 0.02);
            overflow: hidden;
            transition: all 0.3s ease;
        }

        /* 头部区域 */
        .card-header {
            background: linear-gradient(120deg, #ffffff 0%, #fafefc 100%);
            padding: 2rem 2rem 0.75rem 2rem;
            border-bottom: 1px solid #eef2f7;
            text-align: center;
        }

        .card-header h2 {
            font-size: 1.9rem;
            font-weight: 700;
            letter-spacing: -0.01em;
            background: linear-gradient(145deg, #22664e, #2c8b72);
            background-clip: text;
            -webkit-background-clip: text;
            color: transparent;
            display: inline-flex;
            align-items: center;
            gap: 12px;
        }

        .card-header h2 i {
            background: none;
            color: #2c8b72;
            font-size: 1.8rem;
        }

        .header-sub {
            color: #5f7e93;
            font-size: 0.9rem;
            margin-top: 12px;
            border-left: 3px solid #3dab8f;
            padding-left: 16px;
            display: inline-block;
            text-align: left;
        }

        /* 表单区域 */
        .form-container {
            padding: 1.8rem 2rem 2rem 2rem;
        }

        /* 分组标题 - 居中 */
        .section-title {
            font-weight: 600;
            font-size: 1.1rem;
            color: #2a6b58;
            margin-bottom: 1.2rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid #e0efe8;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

        .section-title i {
            color: #3dab8f;
            font-size: 1rem;
        }

        /* 表单字段 - 每个独立一行，居中 */
        .form-field {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
            margin-bottom: 1.2rem;
            width: 100%;
        }

        .form-field label {
            font-weight: 500;
            font-size: 0.85rem;
            color: #4f6f82;
            letter-spacing: 0.02em;
            text-align: left;
        }

        .form-field label i {
            margin-right: 8px;
            width: 20px;
            color: #6f9a86;
        }

        .form-field input,
        .form-field select {
            padding: 0.85rem 1rem;
            border: 1.5px solid #e2eaf0;
            border-radius: 18px;
            font-size: 0.95rem;
            font-family: 'Inter', sans-serif;
            transition: all 0.2s;
            background: #ffffff;
            outline: none;
            width: 100%;
        }

        .form-field input:focus,
        .form-field select:focus {
            border-color: #3dab8f;
            box-shadow: 0 0 0 3px rgba(61, 171, 143, 0.1);
        }

        /* flatpickr 日期输入框样式 */
        .form-field input.flatpickr-input {
            cursor: pointer;
            background-color: #ffffff;
        }

        /* 错误提示 */
        .error-message {
            background: #fff5f2;
            border-left: 4px solid #e28c6e;
            padding: 1rem 1.2rem;
            border-radius: 20px;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 12px;
            color: #bc5a42;
            font-weight: 500;
        }

        /* 提交按钮 - 居中 */
        .submit-area {
            margin-top: 1.8rem;
            text-align: center;
        }

        .btn-submit {
            background: linear-gradient(135deg, #2c8b72, #22664e);
            color: white;
            border: none;
            padding: 1rem 2rem;
            font-size: 1rem;
            font-weight: 600;
            border-radius: 44px;
            cursor: pointer;
            transition: all 0.25s;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            font-family: 'Inter', sans-serif;
            box-shadow: 0 4px 10px rgba(34, 102, 78, 0.2);
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(34, 102, 78, 0.25);
            background: linear-gradient(135deg, #237a63, #1b5a47);
        }

        .btn-submit:active {
            transform: translateY(1px);
        }

        /* 返回链接区域 - 居中 */
        .footer-links {
            padding: 1rem 2rem 2rem 2rem;
            border-top: 1px solid #eef2f8;
            text-align: center;
            background: #ffffff;
        }

        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: #f0f5f9;
            padding: 0.65rem 1.8rem;
            border-radius: 60px;
            text-decoration: none;
            font-weight: 500;
            font-size: 0.9rem;
            color: #2f6e5a;
            transition: all 0.25s;
            border: 1px solid #dee9ef;
        }

        .back-link i {
            transition: transform 0.2s;
        }

        .back-link:hover {
            background: #e6edf4;
            color: #1c5a48;
            transform: translateY(-2px);
        }

        .back-link:hover i {
            transform: translateX(-3px);
        }

        /* 响应式 */
        @media (max-width: 600px) {
            .checkin-wrapper {
                padding: 1rem;
            }
            .card-header h2 {
                font-size: 1.5rem;
            }
            .form-container {
                padding: 1.2rem 1.2rem 1.5rem;
            }
            .card-header {
                padding: 1.2rem 1.2rem 0.5rem;
            }
            .footer-links {
                padding: 1rem 1rem 1.5rem;
            }
        }

        /* 动画 */
        @keyframes fadeSlideUp {
            from {
                opacity: 0;
                transform: translateY(15px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .checkin-card {
            animation: fadeSlideUp 0.4s ease-out;
        }

        /* flatpickr 日历主题微调 */
        .flatpickr-calendar {
            border-radius: 20px;
            box-shadow: 0 20px 35px -12px rgba(0, 0, 0, 0.2);
            font-family: 'Inter', sans-serif;
        }
        .flatpickr-day.selected {
            background: #2c8b72;
            border-color: #2c8b72;
        }
        .flatpickr-day.today {
            border-color: #3dab8f;
        }
        .flatpickr-day.today:hover {
            background: #3dab8f;
            border-color: #3dab8f;
        }
    </style>
</head>
<body>

<!-- 引入头部导航（保留原有include） -->
<%@ include file="header.jsp" %>

<div class="checkin-wrapper">
    <div class="checkin-card">
        <div class="card-header">
            <h2>
                <i class="fas fa-key"></i>
                办理入住
            </h2>
            <div class="header-sub">
                请填写客人信息并选择空闲客房
            </div>
        </div>

        <div class="form-container">
            <%
                List<Room> availableRooms = (List<Room>) request.getAttribute("availableRooms");
                String error = (String) request.getAttribute("error");
            %>

            <% if (error != null) { %>
                <div class="error-message">
                    <i class="fas fa-exclamation-triangle" style="font-size: 1.1rem;"></i>
                    <span>错误: <%= error %></span>
                </div>
            <% } %>

            <!-- 完全保留原始表单结构: action="checkin" method="post" 所有字段名不变 -->
            <form action="checkin" method="post">
                <div class="section-title">
                    <i class="fas fa-user-circle"></i>
                    客人信息
                </div>

                <!-- 每个输入框独立一行 -->
                <div class="form-field">
                    <label><i class="fas fa-user"></i> 姓氏</label>
                    <input type="text" name="firstName" placeholder="请输入姓氏" required>
                </div>

                <div class="form-field">
                    <label><i class="fas fa-user-friends"></i> 名字</label>
                    <input type="text" name="lastName" placeholder="请输入名字" required>
                </div>

                <div class="form-field">
                    <label><i class="fas fa-phone-alt"></i> 电话</label>
                    <input type="text" name="phone" placeholder="手机号码" required>
                </div>

                <div class="form-field">
                    <label><i class="fas fa-id-card"></i> 证件</label>
                    <input type="text" name="idNumber" placeholder="身份证/护照号" required>
                </div>

                <div class="form-field">
                    <label><i class="fas fa-envelope"></i> 邮箱</label>
                    <input type="email" name="email" placeholder="example@domain.com">
                </div>

                <div class="section-title" style="margin-top: 0.5rem;">
                    <i class="fas fa-bed"></i>
                    房间选择
                </div>

                <div class="form-field">
                    <label><i class="fas fa-door-open"></i> 选择房间</label>
                    <select name="roomNumber" required>
                        <%
                            if (availableRooms != null && !availableRooms.isEmpty()) {
                                for (Room room : availableRooms) {
                        %>
                        <option value="<%= room.getRoomId() %>">
                            <%= room.getRoomNumber() %> · <%= room.getTypeName() %> · ¥ <%= String.format("%.2f", room.getPrice()) %> /晚
                        </option>
                        <%
                                }
                            } else {
                        %>
                        <option value="" disabled selected>暂无可用房间</option>
                        <%
                            }
                        %>
                    </select>
                </div>

                <div class="form-field">
                    <label><i class="fas fa-calendar-alt"></i> 入住日期</label>
                    <!-- 使用 flatpickr 日期选择器，点击弹出日历，格式为 YYYY-MM-DD -->
                    <input type="text" name="checkInDate" id="checkinDate" required
                           placeholder="点击选择日期" readonly
                           style="background-color: #ffffff; cursor: pointer;">
                </div>

                <div class="submit-area">
                    <button type="submit" class="btn-submit">
                        <i class="fas fa-check-circle"></i> 办理入住
                    </button>
                </div>
            </form>
        </div>

        <div class="footer-links">
            <a href="index.jsp" class="back-link">
                <i class="fas fa-arrow-left"></i> 返回首页
            </a>
        </div>
    </div>
</div>

<!-- 引入底部页脚（保留原有include） -->
<%@ include file="footer.jsp" %>

<!-- flatpickr 初始化脚本 -->
<script>
    flatpickr("#checkinDate", {
        locale: "zh",           // 中文界面
        dateFormat: "Y-m-d",    // 日期格式：2025-03-21
        minDate: "today",       // 不能选择今天之前的日期
        allowInput: false,      // 禁止手动输入，只能通过日历选择
        placeholder: "请选择入住日期"
    });
</script>

</body>
</html>