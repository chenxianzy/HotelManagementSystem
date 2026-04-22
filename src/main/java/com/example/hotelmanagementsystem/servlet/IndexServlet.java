package com.example.hotelmanagementsystem.servlet;

import com.example.hotelmanagementsystem.dao.BookingDAO;
import com.example.hotelmanagementsystem.dao.RoomDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;

@WebServlet("/index")
public class IndexServlet extends HttpServlet {

    private RoomDAO roomDAO = new RoomDAO();
    private BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // 获取客房总数
            int totalRooms = roomDAO.getTotalRooms();

            // 获取空闲房间数
            int availableRooms = roomDAO.getAvailableRoomsCount();

            // 获取今日入住数
            int todayCheckIns = bookingDAO.getTodayCheckIns(LocalDate.now());

            // 获取今日退房数
            int todayCheckOuts = bookingDAO.getTodayCheckOuts(LocalDate.now());

            // 设置到 request 属性
            request.setAttribute("totalRooms", totalRooms);
            request.setAttribute("availableRooms", availableRooms);
            request.setAttribute("todayCheckIns", todayCheckIns);
            request.setAttribute("todayCheckOuts", todayCheckOuts);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("totalRooms", 16);
            request.setAttribute("availableRooms", 10);
            request.setAttribute("todayCheckIns", 0);
            request.setAttribute("todayCheckOuts", 0);
        }

        // 转发到 index.jsp（注意：这里是转发，不是重定向）
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}