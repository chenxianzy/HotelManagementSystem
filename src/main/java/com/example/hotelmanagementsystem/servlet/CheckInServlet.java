package com.example.hotelmanagementsystem.servlet;

import com.example.hotelmanagementsystem.dao.BookingDAO;
import com.example.hotelmanagementsystem.model.Guest;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;

public class CheckInServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("checkinForm");
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 设置响应内容类型，确保报错能正常显示中文
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String roomIdentifierStr = request.getParameter("roomNumber");
        String checkInDateStr = request.getParameter("checkInDate");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String phone = request.getParameter("phone");
        String idNumber = request.getParameter("idNumber");
        String email = request.getParameter("email");

        // 校验输入
        if (roomIdentifierStr == null || roomIdentifierStr.trim().isEmpty() ||
                checkInDateStr == null || checkInDateStr.trim().isEmpty() ||
                firstName == null || firstName.trim().isEmpty() ||
                lastName == null || lastName.trim().isEmpty()) {

            request.setAttribute("error", "所有必填项（房间、日期、姓名）都不能为空。");
            request.getRequestDispatcher("/checkinForm").forward(request, response);
            return;
        }

        int roomID = -1;

        try {
            roomID = Integer.parseInt(roomIdentifierStr);
            LocalDate checkInDate = LocalDate.parse(checkInDateStr);

            Guest newGuest = new Guest();
            // 拼接姓名
            newGuest.setName(firstName + " " + lastName);
            newGuest.setPhone(phone);
            newGuest.setIdNumber(idNumber);
            newGuest.setEmail(email);

            // 执行事务
            boolean success = bookingDAO.performCheckInTransaction(roomID, newGuest, checkInDate);

            if (success) {
                // 【修改】入住成功后跳转到首页，这样统计数据会重新加载
                response.sendRedirect(request.getContextPath() + "/index");
            } else {
                // 如果是业务逻辑失败（如房间已被占用），也直接打印出来查看原因
                PrintWriter out = response.getWriter();
                out.println("<h1>办理入住失败</h1>");
                out.println("<h3>DAO 返回了 false</h3>");
                out.println("<p>可能原因：房间状态不是 Available，或者数据库插入失败。</p>");
                out.println("<p><a href='checkinForm'>返回表单</a></p>");
            }

        } catch (Exception e) {
            // 【强制调试模式】：捕获所有异常（包括 SQLException），直接打印到浏览器
            e.printStackTrace(); // 同时也打印到 IDE 控制台

            PrintWriter out = response.getWriter();
            out.println("<html><body>");
            out.println("<h1 style='color:red;'>系统发生严重错误！</h1>");
            out.println("<h3>错误类型: " + e.getClass().getName() + "</h3>");
            out.println("<h3>错误信息: " + e.getMessage() + "</h3>");

            out.println("<hr/>");
            out.println("<h3>完整堆栈跟踪 (Stack Trace):</h3>");
            out.println("<pre style='background:#f4f4f4; padding:10px; border:1px solid #ccc;'>");
            e.printStackTrace(out); // 将堆栈信息输出到网页
            out.println("</pre>");
            out.println("</body></html>");
        }
    }
}