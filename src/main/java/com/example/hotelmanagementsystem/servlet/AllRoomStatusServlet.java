package com.example.hotelmanagementsystem.servlet;

import com.example.hotelmanagementsystem.dao.RoomDAO; // 【新增导入】
import com.example.hotelmanagementsystem.model.Room;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

//@WebServlet("/allRoomStatus")
public class AllRoomStatusServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final RoomDAO roomDAO = new RoomDAO(); // 【修正】使用 RoomDAO 实例

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // 1. 调用 DAO 获取所有房间状态 (从 RoomDAO 调用)
            // 注意：我们假设 RoomDAO 中已经添加了 getAllRoomStatus() 方法
            List<Room> allRooms = roomDAO.getAllRoomStatus();

            // 2. 将结果设置到请求属性中
            request.setAttribute("rooms", allRooms);

            // 3. 转发到显示所有房间状态的 JSP 页面
            request.getRequestDispatcher("/all_room_status.jsp").forward(request, response);

        } catch (SQLException e) {
            // 数据库查询失败处理，打印堆栈供调试
            System.err.println("Error retrieving all room statuses:");
            e.printStackTrace();

            request.setAttribute("error", "数据库查询失败: " + e.getMessage());
            request.getRequestDispatcher("/all_room_status.jsp").forward(request, response);
        }
    }
}