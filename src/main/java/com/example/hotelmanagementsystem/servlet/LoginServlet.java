package com.example.hotelmanagementsystem.servlet;

import com.example.hotelmanagementsystem.dao.UserDAO;
import com.example.hotelmanagementsystem.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 如果已经登录，跳转到首页
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }
        // 显示登录页面
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String selectedRole = request.getParameter("role");

        // 参数验证
        if (username == null || username.trim().isEmpty()) {
            request.setAttribute("errorMsg", "请输入用户名");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        if (password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMsg", "请输入密码");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        try {
            // 从数据库验证登录
            User user = userDAO.authenticate(username, password);

            if (user == null) {
                request.setAttribute("errorMsg", "用户名或密码错误");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }

            // 验证角色是否匹配
            if (!user.getRole().equals(selectedRole)) {
                String roleName = getRoleName(selectedRole);
                request.setAttribute("errorMsg", "该账号没有" + roleName + "权限，请选择正确的角色");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }

            // 检查账号状态
            if (user.getStatus() != 1) {
                request.setAttribute("errorMsg", "账号已被禁用，请联系管理员");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }

            // 登录成功
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("role", user.getRole());
            session.setAttribute("username", user.getUsername());
            session.setAttribute("userId", user.getUserId());

            response.sendRedirect(request.getContextPath() + "/index.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "系统错误：" + e.getMessage());
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    private String getRoleName(String role) {
        switch (role) {
            case "manager":
                return "前台经理";
            case "staff":
                return "前台";
            case "guest":
                return "顾客";
            default:
                return "未知";
        }
    }
}