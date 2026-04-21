package com.example.hotelmanagementsystem.servlet;

import com.example.hotelmanagementsystem.dao.RoomDAO;
import com.example.hotelmanagementsystem.model.Room;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

// 注意：已移除 @WebServlet 注解，因为您使用 web.xml 进行了注册
public class CheckInFormServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final RoomDAO roomDAO = new RoomDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // =================================================================
            // 【临时修复开关】：如果您在页面上仍然看不到房间，请取消下面这行代码的注释
            // 这将强制把所有房间重置为 'Available'。
            // 修复成功看到房间后，请务必再次将其注释掉！
            // =================================================================

            // roomDAO.updateAllRoomsToAvailable();

            // =================================================================

            // 1. 查找空闲房间
            // 确保 RoomDAO 中有 getAvailableRooms(String status) 方法
            String status = "Available";
            List<Room> availableRooms = roomDAO.getAvailableRooms(status);

            // 2. 将结果放入请求域
            request.setAttribute("availableRooms", availableRooms);

            // 3. 转发到 JSP
            request.getRequestDispatcher("/checkin_form.jsp").forward(request, response);

        } catch (SQLException e) {
            System.err.println("Error loading checkin form rooms:");
            e.printStackTrace();

            request.setAttribute("error", "加载房间列表失败，请检查数据库服务: " + e.getMessage());
            request.getRequestDispatcher("/checkin_form.jsp").forward(request, response);
        }
    }
}