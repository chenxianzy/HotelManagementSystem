package com.example.hotelmanagementsystem.servlet;

import com.example.hotelmanagementsystem.dao.UserDAO;
import com.example.hotelmanagementsystem.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 显示注册页面
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        // 角色固定为 guest，不从页面获取
        String role = "guest";
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String idNumber = request.getParameter("idNumber");

        // 验证用户名
        if (username == null || username.trim().isEmpty()) {
            request.setAttribute("errorMsg", "请输入用户名");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // 验证密码
        if (password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMsg", "请输入密码");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // 验证密码长度
        if (password.length() < 6) {
            request.setAttribute("errorMsg", "密码长度不能少于6位");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // 验证密码是否一致
        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMsg", "两次输入的密码不一致");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        try {
            // 验证用户名是否已存在
            User existingUser = userDAO.findByUsername(username);
            if (existingUser != null) {
                request.setAttribute("errorMsg", "用户名已存在，请选择其他用户名");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }

            // 加密密码
            String encryptedPassword = encryptPassword(password);

            // 创建新用户（角色固定为 guest）
            User newUser = new User();
            newUser.setUsername(username);
            newUser.setPassword(encryptedPassword);
            newUser.setRole("guest");  // 固定为顾客
            newUser.setStatus(1);

            boolean success = userDAO.registerUser(newUser, phone, email, idNumber);

            if (success) {
                // 注册成功，跳转到登录页
                request.setAttribute("successMsg", "注册成功！请登录");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMsg", "注册失败，请稍后重试");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "系统错误：" + e.getMessage());
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }

    /**
     * 简单密码加密 (SHA-256)
     */
    private String encryptPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(password.getBytes());
            return Base64.getEncoder().encodeToString(hash);
        } catch (NoSuchAlgorithmException e) {
            return password;
        }
    }
}