package com.example.hotelmanagementsystem.dao;

import com.example.hotelmanagementsystem.model.Room;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;

public class RoomDAO {

    // =================================================================================
    // 1. 查询类方法 (Query Methods)
    // =================================================================================

    public List<Room> getCheckedInRooms() throws SQLException {
        List<Room> checkedInRooms = new ArrayList<>();

        System.out.println("--- DEBUG: getCheckedInRooms START ---");

        String sql = "SELECT R.RoomID, R.RoomNumber, R.Status, RT.TypeName, RT.Price " +
                "FROM Rooms R INNER JOIN RoomTypes RT ON R.RoomTypeID = RT.RoomTypeID " +
                "WHERE TRIM(R.Status) = 'Occupied' " +
                "ORDER BY R.RoomNumber";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                Room room = new Room();
                room.setRoomId(rs.getInt("RoomID"));
                room.setRoomNumber(rs.getString("RoomNumber"));
                room.setStatus(rs.getString("Status"));
                room.setTypeName(rs.getString("TypeName"));
                room.setPrice(rs.getBigDecimal("Price"));
                checkedInRooms.add(room);
                System.out.println("--- DEBUG: Found Occupied Room: " + room.getRoomNumber());
            }
        } catch (SQLException e) {
            System.err.println("Error in getCheckedInRooms: " + e.getMessage());
            throw e;
        }

        System.out.println("--- DEBUG: Total Occupied Rooms Found: " + checkedInRooms.size());
        return checkedInRooms;
    }

    public List<Room> getAllRoomStatus() throws SQLException {
        List<Room> rooms = new ArrayList<>();

        String sql = "SELECT R.RoomID, R.RoomNumber, R.Status, RT.TypeName, RT.Price " +
                "FROM Rooms R INNER JOIN RoomTypes RT ON R.RoomTypeID = RT.RoomTypeID " +
                "ORDER BY R.RoomNumber";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                rooms.add(mapResultSetToRoom(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error in getAllRoomStatus: " + e.getMessage());
            throw e;
        }
        return rooms;
    }

    public List<Room> getAvailableRooms(String status) throws SQLException {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            return getAvailableRooms(conn, status);
        } finally {
            if (conn != null) conn.close();
        }
    }

    public List<Room> getAvailableRooms(Connection conn, String status) throws SQLException {
        List<Room> rooms = new ArrayList<>();

        String sql = "SELECT R.RoomID, R.RoomNumber, R.Status, RT.TypeName, RT.Price " +
                "FROM Rooms R " +
                "INNER JOIN RoomTypes RT ON R.RoomTypeID = RT.RoomTypeID " +
                "WHERE R.Status = ?";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, status);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    rooms.add(mapResultSetToRoom(rs));
                }
            }
        }
        return rooms;
    }

    /**
     * 获取客房总数
     */
    public int getTotalRooms() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Rooms";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    /**
     * 获取空闲房间数 (Status = 'Available')
     */
    public int getAvailableRoomsCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Rooms WHERE Status = 'Available'";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    /**
     * 获取顾客当前入住的房间列表（顾客自助退房用）
     */
    public List<Room> getRoomsOccupiedByGuest(int userId) throws SQLException {
        List<Room> rooms = new ArrayList<>();

        String sql = "SELECT DISTINCT r.RoomID, r.RoomNumber, r.Status, rt.TypeName, rt.Price " +
                "FROM Rooms r " +
                "INNER JOIN RoomTypes rt ON r.RoomTypeID = rt.RoomTypeID " +
                "INNER JOIN Bookings b ON r.RoomID = b.RoomID " +
                "INNER JOIN Guests g ON b.GuestID = g.GuestID " +
                "WHERE g.UserID = ? AND b.BookingStatus = 'CheckedIn' " +
                "ORDER BY r.RoomNumber";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Room room = new Room();
                    room.setRoomId(rs.getInt("RoomID"));
                    room.setRoomNumber(rs.getString("RoomNumber"));
                    room.setStatus(rs.getString("Status"));
                    room.setTypeName(rs.getString("TypeName"));
                    room.setPrice(rs.getBigDecimal("Price"));
                    rooms.add(room);
                }
            }
        }
        return rooms;
    }

    /**
     * 验证顾客是否入住了指定房间（顾客退房权限验证用）
     */
    public boolean isGuestOccupyingRoom(int userId, int roomId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Bookings b " +
                "INNER JOIN Guests g ON b.GuestID = g.GuestID " +
                "WHERE g.UserID = ? AND b.RoomID = ? AND b.BookingStatus = 'CheckedIn'";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            pstmt.setInt(2, roomId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    /**
     * 根据房间ID获取房间号
     */
    public String getRoomNumberById(int roomId) throws SQLException {
        String sql = "SELECT RoomNumber FROM Rooms WHERE RoomID = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, roomId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("RoomNumber");
                }
            }
        }
        return null;
    }

    // =================================================================================
    // 2. 更新与辅助方法 (Update & Utility Methods)
    // =================================================================================

    public boolean updateRoomStatus(Connection conn, String roomNumber, String newStatus) throws SQLException {
        String sql = "UPDATE Rooms SET Status = ? WHERE RoomNumber = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, newStatus);
            pstmt.setString(2, roomNumber);
            return pstmt.executeUpdate() > 0;
        }
    }

    public boolean updateRoomStatus(Connection conn, int roomID, String newStatus) throws SQLException {
        String sql = "UPDATE Rooms SET Status = ? WHERE RoomID = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, newStatus);
            pstmt.setInt(2, roomID);
            return pstmt.executeUpdate() > 0;
        }
    }

    /**
     * 更新房间状态 (通过 RoomID) - 无需事务的简单更新
     */
    public boolean updateRoomStatus(int roomID, String newStatus) throws SQLException {
        String sql = "UPDATE Rooms SET Status = ? WHERE RoomID = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, newStatus);
            pstmt.setInt(2, roomID);
            return pstmt.executeUpdate() > 0;
        }
    }

    public int getRoomIdByNumber(Connection conn, String roomNumber) throws SQLException {
        String sql = "SELECT RoomID FROM Rooms WHERE RoomNumber = ?";
        int roomId = -1;
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, roomNumber);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    roomId = rs.getInt("RoomID");
                }
            }
        }
        return roomId;
    }

    public List<Room> getOccupiedRooms() throws SQLException {
        List<Room> rooms = new ArrayList<>();

        String sql = "SELECT R.RoomID, R.RoomNumber, R.Status, RT.TypeName, RT.Price " +
                "FROM Rooms R " +
                "INNER JOIN RoomTypes RT ON R.RoomTypeID = RT.RoomTypeID " +
                "WHERE R.Status = 'Occupied' " +
                "ORDER BY R.RoomNumber";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                Room room = new Room();
                room.setRoomId(rs.getInt("RoomID"));
                room.setRoomNumber(rs.getString("RoomNumber"));
                room.setStatus(rs.getString("Status"));
                room.setTypeName(rs.getString("TypeName"));
                room.setPrice(rs.getBigDecimal("Price"));
                rooms.add(room);
            }
        }
        return rooms;
    }

    // =================================================================================
    // 3. 私有辅助工具 (Private Helper)
    // =================================================================================

    private Room mapResultSetToRoom(ResultSet rs) throws SQLException {
        Room room = new Room();
        room.setRoomId(rs.getInt("RoomID"));
        room.setRoomNumber(rs.getString("RoomNumber"));
        room.setStatus(rs.getString("Status"));
        room.setTypeName(rs.getString("TypeName"));
        room.setPrice(rs.getBigDecimal("Price"));
        return room;
    }
}