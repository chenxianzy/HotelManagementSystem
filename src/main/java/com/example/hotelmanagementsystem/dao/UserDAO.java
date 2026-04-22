package com.example.hotelmanagementsystem.dao;

import com.example.hotelmanagementsystem.model.User;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Base64;

public class UserDAO {

    /**
     * 根据用户名查找用户
     */
    public User findByUsername(String username) throws SQLException {
        String sql = "SELECT UserID, Username, Password, Role, Status FROM Users WHERE Username = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, username);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getInt("UserID"));
                    user.setUsername(rs.getString("Username"));
                    user.setPassword(rs.getString("Password"));
                    user.setRole(rs.getString("Role"));
                    user.setStatus(rs.getInt("Status"));
                    return user;
                }
            }
        }
        return null;
    }

    /**
     * 用户注册
     */
    public boolean registerUser(User user, String phone, String email, String idNumber) throws SQLException {
        String sql = "INSERT INTO Users (Username, Password, Role, Status) VALUES (?, ?, ?, ?)";
        int generatedUserId = -1;

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {

            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getPassword());
            pstmt.setString(3, user.getRole());
            pstmt.setInt(4, user.getStatus());

            int affected = pstmt.executeUpdate();
            if (affected == 0) {
                return false;
            }

            // 获取生成的 UserID
            try (ResultSet rs = pstmt.getGeneratedKeys()) {
                if (rs.next()) {
                    generatedUserId = rs.getInt(1);
                }
            }

            // 如果是顾客角色，同时创建客人记录
            if ("guest".equals(user.getRole()) && generatedUserId > 0) {
                insertGuest(conn, generatedUserId, user.getUsername(), phone, email, idNumber);
            }

            return true;
        }
    }

    /**
     * 插入客人信息
     */
    private void insertGuest(Connection conn, int userId, String username, String phone, String email, String idNumber) throws SQLException {
        // 将用户名拆分为姓和名（简单处理）
        String firstName = username;
        String lastName = "";
        if (username != null && username.contains(" ")) {
            int lastSpace = username.lastIndexOf(" ");
            firstName = username.substring(0, lastSpace);
            lastName = username.substring(lastSpace + 1);
        }

        String sql = "INSERT INTO Guests (UserID, FirstName, LastName, PhoneNumber, Email, IDNumber, Gender, Nationality) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            pstmt.setString(2, firstName);
            pstmt.setString(3, lastName);
            pstmt.setString(4, phone != null ? phone : "");
            pstmt.setString(5, email != null ? email : "");
            pstmt.setString(6, idNumber != null ? idNumber : "");
            pstmt.setString(7, "未知");
            pstmt.setString(8, "中国");
            pstmt.executeUpdate();
        }
    }

    /**
     * 验证用户登录
     */
    public User authenticate(String username, String password) throws SQLException {
        String sql = "SELECT UserID, Username, Password, Role, Status FROM Users WHERE Username = ? AND Status = 1";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, username);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    String dbPassword = rs.getString("Password");
                    // 简单密码验证（实际应使用BCrypt）
                    if (verifyPassword(password, dbPassword)) {
                        User user = new User();
                        user.setUserId(rs.getInt("UserID"));
                        user.setUsername(rs.getString("Username"));
                        user.setRole(rs.getString("Role"));
                        user.setStatus(rs.getInt("Status"));
                        return user;
                    }
                }
            }
        }
        return null;
    }

    /**
     * 验证密码 (SHA-256)
     */
    private boolean verifyPassword(String inputPassword, String storedPassword) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(inputPassword.getBytes());
            String encrypted = Base64.getEncoder().encodeToString(hash);
            return encrypted.equals(storedPassword);
        } catch (NoSuchAlgorithmException e) {
            // 如果加密失败，使用明文比较（仅用于演示）
            return inputPassword.equals(storedPassword);
        }
    }

    /**
     * 简单密码加密 (实际项目建议使用 BCrypt)
     */
    private String encryptPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(password.getBytes());
            return Base64.getEncoder().encodeToString(hash);
        } catch (NoSuchAlgorithmException e) {
            return password;
        }
    }
}