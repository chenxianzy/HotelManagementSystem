package com.example.hotelmanagementsystem.model;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.time.LocalDate;

/**
 * Booking 实体类，对应数据库中的 Booking 表
 */
public class Booking {
    private int bookingId;
    private int guestId;
    private int roomId;
    private LocalDate checkInDate;      // 入住日期 (DATE)
    private LocalDate checkOutDate;     // 离店日期 (DATE)
    private Timestamp actualCheckIn;    // 实际入住时间 (TIMESTAMP)
    private Timestamp actualCheckOut;   // 实际离店时间 (TIMESTAMP)
    private int totalNights;            // 入住晚数
    private BigDecimal totalCost;       // 总费用
    private String bookingStatus;       // 订单状态
    private String paymentStatus;       // 支付状态
    private String specialRequests;     // 特殊要求
    private Integer employeeIdCheckIn;  // 办理入住员工ID
    private Integer employeeIdCheckOut; // 办理离店员工ID
    private Timestamp createTime;       // 创建时间
    private Timestamp updateTime;       // 更新时间

    public Booking() {}

    // Getters and Setters
    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }

    public int getGuestId() { return guestId; }
    public void setGuestId(int guestId) { this.guestId = guestId; }

    public int getRoomId() { return roomId; }
    public void setRoomId(int roomId) { this.roomId = roomId; }

    public LocalDate getCheckInDate() { return checkInDate; }
    public void setCheckInDate(LocalDate checkInDate) { this.checkInDate = checkInDate; }

    public LocalDate getCheckOutDate() { return checkOutDate; }
    public void setCheckOutDate(LocalDate checkOutDate) { this.checkOutDate = checkOutDate; }

    public Timestamp getActualCheckIn() { return actualCheckIn; }
    public void setActualCheckIn(Timestamp actualCheckIn) { this.actualCheckIn = actualCheckIn; }

    public Timestamp getActualCheckOut() { return actualCheckOut; }
    public void setActualCheckOut(Timestamp actualCheckOut) { this.actualCheckOut = actualCheckOut; }

    public int getTotalNights() { return totalNights; }
    public void setTotalNights(int totalNights) { this.totalNights = totalNights; }

    public BigDecimal getTotalCost() { return totalCost; }
    public void setTotalCost(BigDecimal totalCost) { this.totalCost = totalCost; }

    public String getBookingStatus() { return bookingStatus; }
    public void setBookingStatus(String bookingStatus) { this.bookingStatus = bookingStatus; }

    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }

    public String getSpecialRequests() { return specialRequests; }
    public void setSpecialRequests(String specialRequests) { this.specialRequests = specialRequests; }

    public Integer getEmployeeIdCheckIn() { return employeeIdCheckIn; }
    public void setEmployeeIdCheckIn(Integer employeeIdCheckIn) { this.employeeIdCheckIn = employeeIdCheckIn; }

    public Integer getEmployeeIdCheckOut() { return employeeIdCheckOut; }
    public void setEmployeeIdCheckOut(Integer employeeIdCheckOut) { this.employeeIdCheckOut = employeeIdCheckOut; }

    public Timestamp getCreateTime() { return createTime; }
    public void setCreateTime(Timestamp createTime) { this.createTime = createTime; }

    public Timestamp getUpdateTime() { return updateTime; }
    public void setUpdateTime(Timestamp updateTime) { this.updateTime = updateTime; }
}