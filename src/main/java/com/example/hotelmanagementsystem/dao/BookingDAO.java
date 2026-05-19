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
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

public class BookingDAO {

    private final RoomDAO roomDAO = new RoomDAO();

    // 入住功能
    public boolean performCheckInTransaction(int roomID, Guest guest, LocalDate checkInDate) throws SQLException {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false);

            int guestID = findGuestIdByIdNumber(conn, guest.getIdNumber());

            if (guestID != -1) {
                System.out.println("Found existing guest ID: " + guestID);
            } else {
                guestID = insertGuest(conn, guest);
                if (guestID == -1) {
                    conn.rollback();
                    return false;
                }
            }

            boolean bookingInserted = insertBooking(conn, guestID, roomID, checkInDate);
            if (!bookingInserted) {
                conn.rollback();
                return false;
            }

            boolean statusUpdated = roomDAO.updateRoomStatus(conn, roomID, "Occupied");
            if (!statusUpdated) {
                conn.rollback();
                return false;
            }

            conn.commit();
            return true;

        } catch (SQLException e) {
            System.err.println("Check-In Transaction failed, rolling back.");
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    System.err.println("Rollback failed: " + ex.getMessage());
                }
            }
            throw e;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                } catch (SQLException ignored) {
                }
                try {
                    conn.close();
                } catch (SQLException ignored) {
                }
            }
        }
    }

    private int findGuestIdByIdNumber(Connection conn, String idNumber) throws SQLException {
        String sql = "SELECT GuestID FROM Guests WHERE IDNumber = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, idNumber);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("GuestID");
                }
            }
        }
        return -1;
    }

    private int insertGuest(Connection conn, Guest guest) throws SQLException {
        String sql = "INSERT INTO Guests (FirstName, LastName, PhoneNumber, IDNumber, Email, Gender, Nationality) VALUES (?, ?, ?, ?, ?, ?, ?)";
        int generatedId = -1;

        try (PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            String fullName = guest.getName();
            String firstName = fullName;
            String lastName = "";

            if (fullName != null && !fullName.trim().isEmpty()) {
                int lastSpace = fullName.lastIndexOf(" ");
                if (lastSpace > 0) {
                    firstName = fullName.substring(0, lastSpace);
                    lastName = fullName.substring(lastSpace + 1);
                } else {
                    firstName = fullName;
                    lastName = "";
                }
            }

            pstmt.setString(1, firstName);
            pstmt.setString(2, lastName);
            pstmt.setString(3, guest.getPhone());
            pstmt.setString(4, guest.getIdNumber());

            if (guest.getEmail() != null && !guest.getEmail().trim().isEmpty()) {
                pstmt.setString(5, guest.getEmail());
            } else {
                pstmt.setNull(5, Types.VARCHAR);
            }

            pstmt.setString(6, "未知");
            pstmt.setString(7, "中国");

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

    private boolean insertBooking(Connection conn, int guestID, int roomID, LocalDate checkInDate) throws SQLException {
        LocalDate tempCheckOutDate = checkInDate.plusDays(1);
        int totalNights = 1;

        BigDecimal roomPrice = getRoomPrice(conn, roomID);
        BigDecimal totalCost = roomPrice.multiply(new BigDecimal(totalNights));

        String sql = "INSERT INTO Bookings (GuestID, RoomID, CheckInDate, CheckOutDate, TotalNights, TotalCost, BookingStatus) VALUES (?, ?, ?, ?, ?, ?, 'CheckedIn')";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, guestID);
            pstmt.setInt(2, roomID);
            pstmt.setDate(3, java.sql.Date.valueOf(checkInDate));
            pstmt.setDate(4, java.sql.Date.valueOf(tempCheckOutDate));
            pstmt.setInt(5, totalNights);
            pstmt.setBigDecimal(6, totalCost);
            return pstmt.executeUpdate() > 0;
        }
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

    // =================================================================================
    // 统计方法 (Statistics Methods)
    // =================================================================================

    /**
     * 获取今日入住数
     */
    public int getTodayCheckIns(LocalDate date) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Bookings WHERE CheckInDate = ? AND BookingStatus = 'CheckedIn'";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setDate(1, java.sql.Date.valueOf(date));
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    /**
     * 获取今日退房数
     */
    public int getTodayCheckOuts(LocalDate date) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Bookings WHERE CheckOutDate = ? AND BookingStatus = 'CheckedOut'";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setDate(1, java.sql.Date.valueOf(date));
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
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

            LocalDate checkInDate = currentBooking.getCheckInDate();
            LocalDate checkOutDate = LocalDate.now();
            long days = ChronoUnit.DAYS.between(checkInDate, checkOutDate);
            if (days < 1) days = 1;

            BigDecimal totalCost = roomPrice.multiply(new BigDecimal(days));

            updateBookingForCheckOut(conn, currentBooking.getBookingId(), totalCost, checkOutDate, (int) days);

            roomDAO.updateRoomStatus(conn, roomID, "Cleaning");

            conn.commit();
            return totalCost;

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    System.err.println("Rollback failed: " + ex.getMessage());
                }
            }
            throw e;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                } catch (SQLException ignored) {
                }
                try {
                    conn.close();
                } catch (SQLException ignored) {
                }
            }
        }
    }

    private Booking findActiveBookingByRoomID(Connection conn, int roomID) throws SQLException {
        String sql = "SELECT BookingID, GuestID, RoomID, CheckInDate, CheckOutDate, TotalCost FROM Bookings WHERE RoomID = ? AND BookingStatus = 'CheckedIn'";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, roomID);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Booking booking = new Booking();
                    booking.setBookingId(rs.getInt("BookingID"));
                    booking.setRoomId(rs.getInt("RoomID"));
                    booking.setGuestId(rs.getInt("GuestID"));
                    booking.setCheckInDate(rs.getDate("CheckInDate").toLocalDate());
                    booking.setCheckOutDate(rs.getDate("CheckOutDate").toLocalDate());
                    booking.setTotalCost(rs.getBigDecimal("TotalCost"));
                    return booking;
                }
            }
        }
        return null;
    }

    private boolean updateBookingForCheckOut(Connection conn, int bookingID, BigDecimal totalCost, LocalDate checkOutDate, int totalNights) throws SQLException {
        String sql = "UPDATE Bookings SET CheckOutDate = ?, TotalCost = ?, TotalNights = ?, BookingStatus = 'CheckedOut' WHERE BookingID = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setDate(1, java.sql.Date.valueOf(checkOutDate));
            pstmt.setBigDecimal(2, totalCost);
            pstmt.setInt(3, totalNights);
            pstmt.setInt(4, bookingID);
            return pstmt.executeUpdate() > 0;
        }
    }
}