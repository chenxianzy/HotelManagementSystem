package com.example.hotelmanagementsystem.servlet;

import com.example.hotelmanagementsystem.dao.DatabaseConnection;
import com.example.hotelmanagementsystem.dao.RoomDAO;
import com.example.hotelmanagementsystem.model.Room;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

// 关键修正：所有 Servlet 相关的导入都必须是 jakarta.*
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet; // 【重要】这里必须是 jakarta.servlet.annotation
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

// 确保 URL 映射正确
//@WebServlet("/rooms/status")
public class RoomStatusServlet extends HttpServlet {

    // 处理 GET 请求 (查询操作使用 GET)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        RoomDAO roomDAO = new RoomDAO();
        Connection conn = null;
        String errorMessage = null;

        try {
            // 1. 获取数据库连接
            conn = DatabaseConnection.getConnection();

            // 2. 查询所有可用的房间 (状态为 'Available')
            String status = "Available"; // 确保这与数据库中的房间状态值一致
            List<Room> availableRooms = roomDAO.getAvailableRooms(conn, status);

            // 3. 将结果存储在请求属性中
            request.setAttribute("rooms", availableRooms);

        } catch (SQLException e) {
            errorMessage = " 数据库查询失败：" + e.getMessage();
            e.printStackTrace();
        } finally {
            // 4. 关闭连接
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException closeEx) {
                    closeEx.printStackTrace();
                }
            }
        }

        // 5. 存储错误信息（如果有）
        if (errorMessage != null) {
            request.setAttribute("errorMessage", errorMessage);
        }

        // 6. 转发到结果展示页面
        request.getRequestDispatcher("/available_rooms.jsp").forward(request, response);
    }
}