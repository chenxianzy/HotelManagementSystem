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
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String idNumber = request.getParameter("idNumber");

        if (username == null || username.trim().isEmpty()) {
            request.setAttribute("errorMsg", "请输入用户名");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMsg", "请输入密码");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (password.length() < 6) {
            request.setAttribute("errorMsg", "密码长度不能少于6位");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMsg", "两次输入的密码不一致");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        try {
            User existingUser = userDAO.findByUsername(username);
            if (existingUser != null) {
                request.setAttribute("errorMsg", "用户名已存在");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }

            String encryptedPassword = encryptPassword(password);

            User newUser = new User();
            newUser.setUsername(username);
            newUser.setPassword(encryptedPassword);
            newUser.setRole("guest");
            newUser.setStatus(1);

            boolean success = userDAO.registerUser(newUser, phone, email, idNumber);

            if (success) {
                request.setAttribute("successMsg", "注册成功！请登录");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMsg", "注册失败");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "系统错误：" + e.getMessage());
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }

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