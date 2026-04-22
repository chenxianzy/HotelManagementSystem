package com.example.hotelmanagementsystem.servlet;

import com.example.hotelmanagementsystem.dao.RoomDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/updateRoomStatus")
public class UpdateRoomStatusServlet extends HttpServlet {

    private RoomDAO roomDAO = new RoomDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            // 获取参数
            String roomIdStr = request.getParameter("roomId");
            String status = request.getParameter("status");

            if (roomIdStr == null || status == null) {
                out.print("{\"success\": false, \"message\": \"参数不完整\"}");
                return;
            }

            int roomId = Integer.parseInt(roomIdStr);

            // 更新房间状态
            boolean success = roomDAO.updateRoomStatus(roomId, status);

            if (success) {
                out.print("{\"success\": true, \"message\": \"房间状态已更新\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"更新失败，请重试\"}");
            }

        } catch (NumberFormatException e) {
            out.print("{\"success\": false, \"message\": \"房间ID格式错误\"}");
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"系统错误: " + e.getMessage() + "\"}");
        }
    }
}