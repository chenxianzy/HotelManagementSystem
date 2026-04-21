package com.example.hotelmanagementsystem.dao;

import com.example.hotelmanagementsystem.model.Booking;
import com.example.hotelmanagementsystem.model.Guest;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.sql.Types;
import java.time.Instant;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {

    private final RoomDAO roomDAO = new RoomDAO(); // 依赖 RoomDAO

    // 入住功能
    public boolean performCheckInTransaction(int roomID, Guest guest, LocalDate checkInDate) throws SQLException {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false); // 开启事务

            // 1. 处理客人信息 (智能判断：是新客还是老客？)
            int guestID = findGuestIdByIdNumber(conn, guest.getIdNumber());

            if (guestID != -1) {
                // --- 老客人 ---
                // (可选) 这里可以添加 UPDATE 语句来更新老客人的电话或姓名
                System.out.println("Found existing guest ID: " + guestID);
            } else {
                // --- 新客人 ---
                guestID = insertGuest(conn, guest);
                if (guestID == -1) {
                    conn.rollback();
                    return false;
                }
            }

            // 2. 插入新的入住记录
            boolean bookingInserted = insertBooking(conn, guestID, roomID, checkInDate);
            if (!bookingInserted) {
                conn.rollback();
                return false;
            }

            // 3. 更新房间状态为 'Occupied'
            boolean statusUpdated = roomDAO.updateRoomStatus(conn, roomID, "Occupied");
            if (!statusUpdated) {
                conn.rollback();
                return false;
            }

            conn.commit(); // 提交事务
            return true;

        } catch (SQLException e) {
            System.err.println("Check-In Transaction failed, rolling back.");
            if (conn != null) {
                conn.rollback();
            }
            throw e;
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }

    // 【新增辅助方法】：根据身份证号查找客人ID
    private int findGuestIdByIdNumber(Connection conn, String idNumber) throws SQLException {
        String sql = "SELECT GuestID FROM Guests WHERE IDNumber = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, idNumber);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("GuestID"); // 找到了，返回 ID
                }
            }
        }
        return -1; // 没找到
    }

    // 辅助方法 1A: 插入 Guest 并返回 ID
    private int insertGuest(Connection conn, Guest guest) throws SQLException {
        String sql = "INSERT INTO Guests (FullName, PhoneNumber, IDNumber, Email) VALUES (?, ?, ?, ?)";
        int generatedId = -1;

        try (PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setString(1, guest.getName());
            pstmt.setString(2, guest.getPhone());
            pstmt.setString(3, guest.getIdNumber());

            if (guest.getEmail() != null && !guest.getEmail().trim().isEmpty()) {
                pstmt.setString(4, guest.getEmail());
            } else {
                pstmt.setNull(4, Types.VARCHAR);
            }

            int affectedRows = pstmt.executeUpdate();
            if (affectedRows == 0) return -1;

            try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    generatedId = generatedKeys.getInt(1);
                }
            }
        }
        return generatedId;
    }

    // 辅助方法 2A: 插入 Booking
    private boolean insertBooking(Connection conn, int guestID, int roomID, LocalDate checkInDate) throws SQLException {
        String sql = "INSERT INTO Bookings (GuestID, RoomID, CheckInTime, BookingStatus) VALUES (?, ?, ?, 'CheckedIn')";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, guestID);
            pstmt.setInt(2, roomID);
            pstmt.setDate(3, java.sql.Date.valueOf(checkInDate));
            return pstmt.executeUpdate() > 0;
        }
    }

    // =================================================================================
    // 退房功能 (Check-Out)
    // =================================================================================

    public BigDecimal performCheckOutTransaction(int roomID) throws SQLException {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false);

            Booking currentBooking = findActiveBookingByRoomID(conn, roomID);
            if (currentBooking == null) {
                throw new SQLException("RoomID " + roomID + " 当前没有活动的入住记录。");
            }

            BigDecimal roomPrice = getRoomPrice(conn, roomID);
            if (roomPrice == null || roomPrice.compareTo(BigDecimal.ZERO) <= 0) {
                roomPrice = BigDecimal.ZERO;
            }

            Timestamp checkInTimestamp = currentBooking.getCheckInTime();
            long days = 1;
            if (checkInTimestamp != null) {
                long diff = Instant.now().toEpochMilli() - checkInTimestamp.getTime();
                days = diff / (1000 * 60 * 60 * 24);
                if (days < 1) days = 1;
            }
            BigDecimal totalCost = roomPrice.multiply(new BigDecimal(days));

            updateBookingForCheckOut(conn, currentBooking.getBookingId(), totalCost);

            roomDAO.updateRoomStatus(conn, roomID, "Cleaning");

            conn.commit();
            return totalCost;

        } catch (SQLException e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }

    private Booking findActiveBookingByRoomID(Connection conn, int roomID) throws SQLException {
        String sql = "SELECT * FROM Bookings WHERE RoomID = ? AND BookingStatus = 'CheckedIn'";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, roomID);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Booking booking = new Booking();
                    booking.setBookingId(rs.getInt("BookingID"));
                    booking.setRoomId(rs.getInt("RoomID"));
                    booking.setGuestId(rs.getInt("GuestID"));
                    booking.setCheckInTime(rs.getTimestamp("CheckInTime"));
                    return booking;
                }
            }
        }
        return null;
    }

    private BigDecimal getRoomPrice(Connection conn, int roomID) throws SQLException {
        String sql = "SELECT RT.Price FROM Rooms R JOIN RoomTypes RT ON R.RoomTypeID = RT.RoomTypeID WHERE R.RoomID = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, roomID);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal("Price");
                }
            }
        }
        return BigDecimal.ZERO;
    }

    private boolean updateBookingForCheckOut(Connection conn, int bookingID, BigDecimal totalCost) throws SQLException {
        String sql = "UPDATE Bookings SET CheckOutTime = ?, TotalCost = ?, BookingStatus = 'CheckedOut' WHERE BookingID = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setTimestamp(1, Timestamp.from(Instant.now()));
            pstmt.setBigDecimal(2, totalCost);
            pstmt.setInt(3, bookingID);
            return pstmt.executeUpdate() > 0;
        }
    }
}

