package com.example.hotelmanagementsystem.model;

import java.math.BigDecimal; // 用于Price字段

public class Room {
    private int roomId;
    private String roomNumber;
    private int roomTypeID; // 外键，指向 RoomType 表
    private String status;  // 房间状态 (如: Available, Occupied, Cleaning)

    // 方便 DAO 联查时携带房间类型的名称和价格
    private String typeName;
    private BigDecimal price;

    // --- 构造方法 ---
    public Room() {}

    public Room(int roomId, String roomNumber, int roomTypeID, String status, String typeName, BigDecimal price) {
        this.roomId = roomId;
        this.roomNumber = roomNumber;
        this.roomTypeID = roomTypeID;
        this.status = status;
        this.typeName = typeName;
        this.price = price;
    }

    // --- Getters and Setters ---

    public int getRoomId() {
        return roomId;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }

    public String getRoomNumber() {
        return roomNumber;
    }

    public void setRoomNumber(String roomNumber) {
        this.roomNumber = roomNumber;
    }

    public int getRoomTypeID() {
        return roomTypeID;
    }

    public void setRoomTypeID(int roomTypeID) {
        this.roomTypeID = roomTypeID;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status; // 修正：添加了赋值逻辑
    }

    public String getTypeName() {
        return typeName;
    }

    public void setTypeName(String typeName) {
        this.typeName = typeName; // 修正：添加了赋值逻辑
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price; // 修正：添加了赋值逻辑
    }

    public void setRoomID(int roomID) {
    }
}