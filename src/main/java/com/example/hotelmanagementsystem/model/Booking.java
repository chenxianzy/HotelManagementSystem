package com.example.hotelmanagementsystem.model;

import java.math.BigDecimal;
import java.sql.Timestamp; // 建议使用 Timestamp 存储日期和时间

/**
 * Booking 实体类，对应数据库中的 Booking 表，用于存储订单/入住记录。
 */
public class Booking {
    private int bookingId;
    private int guestId; // 外键：客人ID
    private int roomId; // 外键：房间ID
    private Timestamp checkInTime; // 入住时间（包含日期和时间）
    private Timestamp checkOutTime; // 预计/实际退房时间
    private BigDecimal totalCost; // 总费用
    private String bookingStatus; // 订单状态 (如: CheckedIn, CheckedOut, Cancelled)
    private Integer employeeIdCheckIn; // 办理入住的员工ID (可为空)
    private Integer employeeIdCheckOut; // 办理退房的员工ID (可为空)

    // ------------------------------------
    // 构造方法
    // ------------------------------------
    public Booking() {}

    // --- Getters and Setters ---

    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    public int getGuestId() {
        return guestId;
    }

    public void setGuestId(int guestId) {
        this.guestId = guestId;
    }

    public int getRoomId() {
        return roomId;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }

    public Timestamp getCheckInTime() {
        return checkInTime;
    }

    public void setCheckInTime(Timestamp checkInTime) {
        this.checkInTime = checkInTime;
    }

    public Timestamp getCheckOutTime() {
        return checkOutTime;
    }

    public void setCheckOutTime(Timestamp checkOutTime) {
        this.checkOutTime = checkOutTime;
    }

    public BigDecimal getTotalCost() {
        return totalCost;
    }

    public void setTotalCost(BigDecimal totalCost) {
        this.totalCost = totalCost;
    }

    public String getBookingStatus() {
        return bookingStatus;
    }

    public void setBookingStatus(String bookingStatus) {
        this.bookingStatus = bookingStatus;
    }

    public Integer getEmployeeIdCheckIn() {
        return employeeIdCheckIn;
    }

    public void setEmployeeIdCheckIn(Integer employeeIdCheckIn) {
        this.employeeIdCheckIn = employeeIdCheckIn;
    }

    public Integer getEmployeeIdCheckOut() {
        return employeeIdCheckOut;
    }

    public void setEmployeeIdCheckOut(Integer employeeIdCheckOut) {
        this.employeeIdCheckOut = employeeIdCheckOut;
    }
}