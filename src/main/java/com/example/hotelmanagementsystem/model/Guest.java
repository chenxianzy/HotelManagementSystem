package com.example.hotelmanagementsystem.model;

public class Guest {
    private int guestID;
    private String name; // 统一使用 name (代替 Firstname/Lastname)
    private String phone;
    private String idNumber;
    private String email; // 假设您保留了 email 属性

    public Guest() {}

    // 【Setter 方法】
    public void setName(String name) {
        this.name = name;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public void setIdNumber(String idNumber) {
        this.idNumber = idNumber;
    }

    public void setEmail(String email) { // 添加 Email 的 Setter
        this.email = email;
    }

    // 【Getter 方法】(用于 DAO 访问)
    public int getGuestID() {
        return guestID;
    }

    public void setGuestID(int guestID) {
        this.guestID = guestID;
    }

    public String getName() {
        return name;
    }

    public String getPhone() {
        return phone;
    }

    public String getIdNumber() {
        return idNumber;
    }

    public String getEmail() {
        return email;
    }
}