package com.example.hotelmanagementsystem.dao;

import com.example.hotelmanagementsystem.model.Guest;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;

public class GuestDAO {

    /**
     * 插入新客人信息到 Guest 表
     * @param guest 客人对象
     * @return 新生成的 GuestID，如果失败则返回 -1
     * @throws SQLException 数据库错误
     */
    public int insertNewGuest(Connection conn, Guest guest) throws SQLException {
        // SQL 语句：修正为使用 GuestName, Phone, IDNumber, Email
        String sql = "INSERT INTO Guest (GuestName, Phone, IDNumber, Email) VALUES (?, ?, ?, ?)";
        int generatedId = -1;

        // 注意：这里使用传入的 Connection 对象，不关闭它，以便在事务中使用
        try (PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            // 【修正 1】：使用 getName() 替换 getFirstname()/getLastname()
            pstmt.setString(1, guest.getName());

            // 【修正 2】：使用 getPhone()
            pstmt.setString(2, guest.getPhone());

            // 【修正 3】：使用 getIdNumber()
            pstmt.setString(3, guest.getIdNumber());

            // 【修正 4】：安全处理 Email 字段的 NULL 值
            if (guest.getEmail() != null && !guest.getEmail().trim().isEmpty()) {
                pstmt.setString(4, guest.getEmail());
            } else {
                pstmt.setNull(4, Types.VARCHAR); // 设置为 SQL NULL
            }

            pstmt.executeUpdate();

            // 获取自增主键 ID
            try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    generatedId = generatedKeys.getInt(1);
                }
            }

        } // Connection 对象不在这里关闭

        return generatedId;
    }

    // ... 其他 GuestDAO 方法（如果有的话）
}