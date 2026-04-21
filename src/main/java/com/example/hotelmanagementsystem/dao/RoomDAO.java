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

    /**
     * 【新增方法】获取所有处于 'Occupied' (已入住) 状态的房间
     * 供 CheckOutServlet 的 doGet 方法调用，用于加载房间下拉列表。
     */
    // RoomDAO.java

    /**
     * 获取所有处于 'Occupied' (已入住) 状态的房间列表。
     */
    /**
     * 获取所有处于 'Occupied' (已入住) 状态的房间列表。
     */
    public List<Room> getCheckedInRooms() throws SQLException {
        List<Room> checkedInRooms = new ArrayList<>();
        Connection conn = null;

        // 【调试信息】：开始查询
        System.out.println("--- DEBUG: getCheckedInRooms START ---");

        // 【核心修正】：使用 TRIM() 函数防止空格干扰，确保匹配 'Occupied'
        String sql = "SELECT R.RoomID, R.RoomNumber, R.Status, RT.TypeName, RT.Price " +
                "FROM Rooms R INNER JOIN RoomTypes RT ON R.RoomTypeID = RT.RoomTypeID " +
                "WHERE TRIM(R.Status) = 'Occupied' " +
                "ORDER BY R.RoomNumber";

        try {
            conn = DatabaseConnection.getConnection();
            try (PreparedStatement pstmt = conn.prepareStatement(sql);
                 ResultSet rs = pstmt.executeQuery()) {

                while (rs.next()) {
                    Room room = new Room();
                    room.setRoomId(rs.getInt("RoomID"));
                    room.setRoomNumber(rs.getString("RoomNumber"));
                    room.setStatus(rs.getString("Status"));
                    room.setTypeName(rs.getString("TypeName"));
                    room.setPrice(rs.getBigDecimal("Price"));

                    checkedInRooms.add(room);

                    // 【调试信息】：打印查到的房间
                    System.out.println("--- DEBUG: Found Occupied Room: " + room.getRoomNumber());
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in getCheckedInRooms: " + e.getMessage());
            throw e;
        } finally {
            if (conn != null) {
                conn.close();
            }
        }

        // 【调试信息】：查询结束
        System.out.println("--- DEBUG: Total Occupied Rooms Found: " + checkedInRooms.size());

        return checkedInRooms;
    }

    /**
     * 【修正】获取所有房间的状态 (包括 Available, Occupied, Reserved 等)
     * 供 AllRoomStatusServlet 调用。
     */
    public List<Room> getAllRoomStatus() throws SQLException {
        List<Room> rooms = new ArrayList<>();
        Connection conn = null;

        String sql = "SELECT R.RoomID, R.RoomNumber, R.Status, RT.TypeName, RT.Price " +
                "FROM Rooms R INNER JOIN RoomTypes RT ON R.RoomTypeID = RT.RoomTypeID " +
                "ORDER BY R.RoomNumber";

        try {
            conn = DatabaseConnection.getConnection();
            try (PreparedStatement pstmt = conn.prepareStatement(sql);
                 ResultSet rs = pstmt.executeQuery()) {

                while (rs.next()) {
                    rooms.add(mapResultSetToRoom(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in getAllRoomStatus: " + e.getMessage());
            throw e;
        } finally {
            if (conn != null) conn.close();
        }
        return rooms;
    }

    /**
     * 【简化方法】获取所有可用于办理入住的房间 (Status = 'Available')
     * 供 CheckInFormServlet 调用，方法内部自动管理连接。
     */
    public List<Room> getAvailableRooms(String status) throws SQLException {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            // 调用下方支持事务的核心方法
            return getAvailableRooms(conn, status);
        } finally {
            if (conn != null) conn.close();
        }
    }

    /**
     * 【核心方法】根据状态查询房间列表 (支持事务)
     * 被简化方法和 BookingDAO 调用。
     */
    public List<Room> getAvailableRooms(Connection conn, String status) throws SQLException {
        List<Room> rooms = new ArrayList<>();

        // 【关键修正】：使用 INNER JOIN 确保只查询出类型有效的房间
        String sql = "SELECT R.RoomID, R.RoomNumber, R.Status, RT.TypeName, RT.Price " +
                "FROM Rooms R " +
                "INNER JOIN RoomTypes RT ON R.RoomTypeID = RT.RoomTypeID " +
                "WHERE R.Status = ?";

        // 注意：不关闭传入的 conn
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

    // =================================================================================
    // 2. 更新与辅助方法 (Update & Utility Methods)
    // =================================================================================

    /**
     * 更新房间状态 (通过 RoomNumber)
     */
    public boolean updateRoomStatus(Connection conn, String roomNumber, String newStatus) throws SQLException {
        String sql = "UPDATE Rooms SET Status = ? WHERE RoomNumber = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, newStatus);
            pstmt.setString(2, roomNumber);
            return pstmt.executeUpdate() > 0;
        }
    }

    /**
     * 更新房间状态 (通过 RoomID) - 退房事务需要
     */
    public boolean updateRoomStatus(Connection conn, int roomID, String newStatus) throws SQLException {
        String sql = "UPDATE Rooms SET Status = ? WHERE RoomID = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, newStatus);
            pstmt.setInt(2, roomID);
            return pstmt.executeUpdate() > 0;
        }
    }

    /**
     * 根据房间号获取房间ID
     */
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

    // =================================================================================
    // 3. 私有辅助工具 (Private Helper)
    // =================================================================================

    // 将 ResultSet 映射为 Room 对象的辅助方法，减少代码重复
    private Room mapResultSetToRoom(ResultSet rs) throws SQLException {
        Room room = new Room();
        room.setRoomId(rs.getInt("RoomID"));
        room.setRoomNumber(rs.getString("RoomNumber"));
        room.setStatus(rs.getString("Status"));
        room.setTypeName(rs.getString("TypeName"));
        // 确保使用 getBigDecimal 匹配 Room 模型
        room.setPrice(rs.getBigDecimal("Price"));
        return room;
    }
    // RoomDAO.java

// ... 其他方法 ...

    /**
     * 获取所有状态为 'Occupied' (已入住) 的房间列表
     * 用于退房页面的下拉菜单
     */
    public List<Room> getOccupiedRooms() throws SQLException {
        List<Room> rooms = new ArrayList<>();

        // 联表查询，获取房间信息和类型信息
        String sql = "SELECT R.RoomID, R.RoomNumber, R.Status, RT.TypeName, RT.Price " +
                "FROM Rooms R " +
                "INNER JOIN RoomTypes RT ON R.RoomTypeID = RT.RoomTypeID " +
                "WHERE R.Status = 'Occupied' " +  // 只查已入住的
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
}