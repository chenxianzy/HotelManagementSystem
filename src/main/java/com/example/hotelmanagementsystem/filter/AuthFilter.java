package com.example.hotelmanagementsystem.filter;

import com.example.hotelmanagementsystem.model.User;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebFilter("/*")
public class AuthFilter implements Filter {

    // 不需要登录就可以访问的页面（白名单）
    private static final List<String> PUBLIC_PATHS = List.of(
            "/login.jsp",
            "/login",
            "/register.jsp",    // 添加注册页面
            "/register",        // 添加注册Servlet
            "/css/",
            "/js/",
            "/fonts/",
            "/favicon.ico",
            "/error.jsp"
    );

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String path = req.getRequestURI().substring(req.getContextPath().length());

        // 检查是否是公共路径（不需要登录）
        boolean isPublic = PUBLIC_PATHS.stream().anyMatch(path::startsWith);

        if (isPublic) {
            chain.doFilter(request, response);
            return;
        }

        // 检查是否已登录
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            // 未登录，跳转到登录页
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // 已登录，继续执行
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}