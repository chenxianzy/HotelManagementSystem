package com.example.hotelmanagementsystem.servlet;

import com.example.hotelmanagementsystem.dao.BookingDAO;
import com.example.hotelmanagementsystem.dao.RoomDAO;
import com.example.hotelmanagementsystem.model.Room;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

public class CheckOutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final BookingDAO bookingDAO = new BookingDAO();
    private final RoomDAO roomDAO = new RoomDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // 1. 获取所有 "已入住" 的房间，供下拉菜单使用
            List<Room> occupiedRooms = roomDAO.getOccupiedRooms();
            request.setAttribute("occupiedRooms", occupiedRooms);

            // 2. 转发到退房页面
            request.getRequestDispatcher("/checkout_form.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "无法加载已入住房间列表");
        }
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // 获取前端提交的 RoomID (下拉菜单的 value)
        String roomIDStr = request.getParameter("roomID");

        if (roomIDStr == null || roomIDStr.trim().isEmpty()) {
            request.setAttribute("error", "请选择要退房的房间。");
            doGet(request, response); // 重新加载表单
            return;
        }

        try {
            int roomID = Integer.parseInt(roomIDStr);

            // 执行退房事务
            BigDecimal cost = bookingDAO.performCheckOutTransaction(roomID);

            // 成功：显示账单
            request.setAttribute("message", "退房成功！共计费用：¥" + cost);
            request.getRequestDispatcher("/checkout_result.jsp").forward(request, response); // 假设您有这个结果页，或者回到 index

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "退房失败：" + e.getMessage());
            doGet(request, response); // 重新加载表单
        }
    }
}