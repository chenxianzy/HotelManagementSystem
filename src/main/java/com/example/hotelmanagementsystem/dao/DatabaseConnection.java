package com.example.hotelmanagementsystem.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {

    // 私有构造函数，防止实例化工具类
    private DatabaseConnection() {}

    /**
     * 获取数据库连接
     * @return 数据库连接对象
     * @throws SQLException 如果连接失败（例如密码错误、服务器未运行）
     */
    public static Connection getConnection() throws SQLException {
        // 确保驱动已加载 (在现代JDBC中通常自动加载，但保留此代码增加兼容性)
        try {
            // 假设 DBConfig 包含 DRIVER 字段
            Class.forName(DBConfig.DRIVER);
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC Driver Not Found.");
            // 抛出 SQLException 终止操作
            throw new SQLException("数据库驱动加载失败，请检查项目依赖。", e);
        }

        // 返回连接对象，参数从 DBConfig 类中获取
        // 假设 DBConfig 包含 URL, USER, PASSWORD 字段
        return DriverManager.getConnection(DBConfig.URL, DBConfig.USER, DBConfig.PASSWORD);
    }
}