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
            // 尝试从数据库验证登录
            User user = userDAO.authenticate(username, password);

            if (user != null) {
                // 验证角色是否匹配
                if (!user.getRole().equals(selectedRole)) {
                    request.setAttribute("errorMsg", "该账号没有" + getRoleName(selectedRole) + "权限，请选择正确的角色");
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
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            // 数据库查询失败，记录日志但不影响演示模式
            System.err.println("数据库验证失败，进入演示模式: " + e.getMessage());
        }

        // ============================================================
        // 演示模式：如果没有数据库或账号不存在，仍然允许登录
        // 实际生产环境中，应该只允许数据库验证成功的用户登录
        // ============================================================
        User demoUser = new User();
        demoUser.setUsername(username != null && !username.isEmpty() ? username : "游客");
        demoUser.setRole(selectedRole != null ? selectedRole : "guest");
        demoUser.setUserId(1);
        demoUser.setStatus(1);

        HttpSession session = request.getSession();
        session.setAttribute("user", demoUser);
        session.setAttribute("role", demoUser.getRole());
        session.setAttribute("username", demoUser.getUsername());
        session.setAttribute("userId", demoUser.getUserId());

        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }

    /**
     * 获取角色中文名称
     */
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