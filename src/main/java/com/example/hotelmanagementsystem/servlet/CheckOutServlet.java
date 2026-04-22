package com.example.hotelmanagementsystem.servlet;

import com.example.hotelmanagementsystem.dao.BookingDAO;
import com.example.hotelmanagementsystem.dao.RoomDAO;
import com.example.hotelmanagementsystem.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/checkout")
public class CheckOutServlet extends HttpServlet {

    private RoomDAO roomDAO = new RoomDAO();
    private BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String role = (String) session.getAttribute("role");

        try {
            List<com.example.hotelmanagementsystem.model.Room> occupiedRooms;

            // 根据角色获取不同的房间列表
            if ("guest".equals(role)) {
                // 顾客只能看到自己入住的房间
                Integer userId = (Integer) session.getAttribute("userId");
                if (userId == null) {
                    request.setAttribute("error", "请先登录");
                    request.getRequestDispatcher("/login.jsp").forward(request, response);
                    return;
                }
                occupiedRooms = roomDAO.getRoomsOccupiedByGuest(userId);

                if (occupiedRooms == null || occupiedRooms.isEmpty()) {
                    request.setAttribute("error", "您当前没有入住的房间，无法办理退房");
                }
            } else {
                // 前台/经理可以看到所有入住的房间
                occupiedRooms = roomDAO.getCheckedInRooms();
            }

            request.setAttribute("occupiedRooms", occupiedRooms);
            request.getRequestDispatcher("/checkout_form.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "系统错误：" + e.getMessage());
            request.getRequestDispatcher("/checkout_form.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String role = (String) session.getAttribute("role");

        String roomIdStr = request.getParameter("roomID");

        if (roomIdStr == null || roomIdStr.isEmpty()) {
            request.setAttribute("error", "请选择要退房的房间");
            doGet(request, response);
            return;
        }

        try {
            int roomId = Integer.parseInt(roomIdStr);

            // 验证权限：顾客只能退自己入住的房间
            if ("guest".equals(role)) {
                Integer userId = (Integer) session.getAttribute("userId");
                if (userId == null) {
                    request.setAttribute("error", "请先登录");
                    request.getRequestDispatcher("/login.jsp").forward(request, response);
                    return;
                }
                boolean isGuestInRoom = roomDAO.isGuestOccupyingRoom(userId, roomId);
                if (!isGuestInRoom) {
                    request.setAttribute("error", "您没有权限退订这个房间");
                    doGet(request, response);
                    return;
                }
            }

            // 执行退房
            BigDecimal totalCost = bookingDAO.performCheckOutTransaction(roomId);

            // 获取房间号
            String roomNumber = roomDAO.getRoomNumberById(roomId);

            request.setAttribute("success", true);
            request.setAttribute("roomNumber", roomNumber);
            request.setAttribute("totalCost", totalCost);
            request.getRequestDispatcher("/checkout_result.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("error", "房间ID格式错误");
            doGet(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", e.getMessage());
            doGet(request, response);
        }
    }
}