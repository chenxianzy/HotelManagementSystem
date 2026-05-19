-- ============================================================
-- 酒店信息管理系统 - MySQL 数据库初始化脚本
-- HotelManagementSystem
-- 技术栈：Java 17 + Tomcat 10 + MySQL 8.0+
-- 编码：UTF-8
-- ============================================================

-- 1. 创建数据库
DROP DATABASE IF EXISTS HotelManagementSystem;
CREATE DATABASE HotelManagementSystem
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE HotelManagementSystem;

-- ============================================================
-- 2. 创建数据表
-- ============================================================

-- 用户表 (Users)
-- 存储系统所有可登录账号，包括顾客、前台员工、前台经理
CREATE TABLE Users (
    UserID      INT PRIMARY KEY AUTO_INCREMENT COMMENT '用户唯一标识',
    Username    VARCHAR(50)  NOT NULL UNIQUE COMMENT '登录用户名',
    Password    VARCHAR(255) NOT NULL COMMENT 'SHA-256 + Base64 加密后的密码',
    Role        ENUM('guest', 'staff', 'manager') NOT NULL DEFAULT 'guest' COMMENT '角色：顾客/前台/经理',
    Status      TINYINT      NOT NULL DEFAULT 1 COMMENT '账号状态：1=正常，0=禁用',
    CreateTime  TIMESTAMP    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    UpdateTime  TIMESTAMP    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_username (Username),
    INDEX idx_role_status (Role, Status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统用户表';

-- 客人信息表 (Guests)
-- 存储顾客/客人的详细资料。注册用户(UserID有值)和前台直接登记的无账号客人都可录入
CREATE TABLE Guests (
    GuestID     INT PRIMARY KEY AUTO_INCREMENT COMMENT '客人唯一标识',
    UserID      INT          NULL COMMENT '关联的用户ID（NULL表示前台直接登记的非注册用户）',
    FirstName   VARCHAR(50)  NOT NULL COMMENT '名',
    LastName    VARCHAR(50)  NOT NULL COMMENT '姓',
    PhoneNumber VARCHAR(20)  NULL COMMENT '手机号',
    Email       VARCHAR(100) NULL COMMENT '邮箱',
    IDNumber    VARCHAR(18)  NULL COMMENT '身份证号',
    Gender      VARCHAR(10)  NULL COMMENT '性别',
    Nationality VARCHAR(50)  NULL COMMENT '国籍',
    CreateTime  TIMESTAMP    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    CONSTRAINT fk_guest_user FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE SET NULL ON UPDATE CASCADE,
    INDEX idx_guest_user (UserID),
    INDEX idx_guest_idnumber (IDNumber)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='客人信息表';

-- 房间类型表 (RoomTypes)
-- 定义不同房型的基本信息和价格
CREATE TABLE RoomTypes (
    RoomTypeID  INT PRIMARY KEY AUTO_INCREMENT COMMENT '房型唯一标识',
    TypeName    VARCHAR(50)  NOT NULL COMMENT '房型名称（如：标准间、豪华间）',
    Price       DECIMAL(10,2) NOT NULL COMMENT '每晚单价',
    Description VARCHAR(255) NULL COMMENT '房型描述',
    Capacity    INT          NULL COMMENT '可容纳人数',
    BedType     VARCHAR(20)  NULL COMMENT '床型（大床/双床）',
    INDEX idx_typename (TypeName)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='房间类型表';

-- 房间表 (Rooms)
-- 存储每一间具体房间的状态信息
CREATE TABLE Rooms (
    RoomID      INT PRIMARY KEY AUTO_INCREMENT COMMENT '房间唯一标识',
    RoomNumber  VARCHAR(10)  NOT NULL UNIQUE COMMENT '房间号（如：101）',
    RoomTypeID  INT          NOT NULL COMMENT '关联的房型ID',
    Status      ENUM('Available', 'Occupied', 'Cleaning') NOT NULL DEFAULT 'Available' COMMENT '房间状态',
    CONSTRAINT fk_room_type FOREIGN KEY (RoomTypeID) REFERENCES RoomTypes(RoomTypeID) ON DELETE RESTRICT ON UPDATE CASCADE,
    INDEX idx_room_status (Status),
    INDEX idx_room_number (RoomNumber)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='房间信息表';

-- 预订/入住记录表 (Bookings)
-- 记录每一次入住和退房的完整信息
CREATE TABLE Bookings (
    BookingID         INT PRIMARY KEY AUTO_INCREMENT COMMENT '订单唯一标识',
    GuestID           INT           NOT NULL COMMENT '入住客人ID',
    RoomID            INT           NOT NULL COMMENT '入住房间ID',
    CheckInDate       DATE          NOT NULL COMMENT '预计入住日期',
    CheckOutDate      DATE          NULL COMMENT '预计退房日期',
    ActualCheckIn     TIMESTAMP     NULL COMMENT '实际入住时间',
    ActualCheckOut    TIMESTAMP     NULL COMMENT '实际退房时间',
    TotalNights       INT           NOT NULL DEFAULT 1 COMMENT '入住晚数',
    TotalCost         DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '总费用',
    BookingStatus     ENUM('CheckedIn', 'CheckedOut', 'Cancelled') NOT NULL DEFAULT 'CheckedIn' COMMENT '订单状态',
    PaymentStatus     ENUM('Pending', 'Paid', 'Refunded') NOT NULL DEFAULT 'Pending' COMMENT '支付状态',
    SpecialRequests   TEXT          NULL COMMENT '特殊要求',
    EmployeeIdCheckIn INT           NULL COMMENT '办理入住员工ID',
    EmployeeIdCheckOut INT          NULL COMMENT '办理退房员工ID',
    CreateTime        TIMESTAMP     DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    UpdateTime        TIMESTAMP     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    CONSTRAINT fk_booking_guest FOREIGN KEY (GuestID) REFERENCES Guests(GuestID) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_booking_room  FOREIGN KEY (RoomID)  REFERENCES Rooms(RoomID)   ON DELETE RESTRICT ON UPDATE CASCADE,
    INDEX idx_booking_guest (GuestID),
    INDEX idx_booking_room (RoomID),
    INDEX idx_booking_status (BookingStatus),
    INDEX idx_booking_checkin (CheckInDate),
    INDEX idx_booking_dates_status (CheckInDate, CheckOutDate, BookingStatus)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='预订与入住记录表';

-- ============================================================
-- 3. 插入初始数据
-- ============================================================

-- 3.1 初始用户（密码使用 SHA-256 + Base64 加密）
-- manager / Manager123
-- staff   / Staff123
-- guest   / Guest123
INSERT INTO Users (Username, Password, Role, Status) VALUES
('manager', 'YbOtJDNsIFFVc9x9h1y5KV6EYs7GRcNgSsWPHiQeIOA=', 'manager', 1),
('staff',   'LwBeQqF9pG7FG6bxHXJeYHiJMaHa3TPZy4UIT7MrsWY=', 'staff',   1),
('guest',   '+5ImOiI5KECyLgm7/kWsIaC1HGjzbjtwcneEwWTxPf0=', 'guest',   1);

-- 3.2 初始客人信息（对应注册用户 guest）
INSERT INTO Guests (UserID, FirstName, LastName, PhoneNumber, Email, IDNumber, Gender, Nationality) VALUES
(3, '张', '三', '13800138000', 'guest@example.com', '110101199001011234', '男', '中国');

-- 3.3 房间类型
INSERT INTO RoomTypes (TypeName, Price, Description, Capacity, BedType) VALUES
('标准间', 299.00, '舒适整洁的标准客房，配备独立卫浴、Wi-Fi、空调', 2, '大床'),
('豪华间', 499.00, '宽敞明亮的豪华客房，配备落地窗、迷你吧、浴缸', 2, '双床'),
('行政套房', 899.00, '尊贵奢华的行政套房，配备客厅、书房、全景落地窗', 4, '大床');

-- 3.4 房间信息（共16间）
-- 101-106：标准间
-- 201-204：豪华间
-- 301-306：行政套房
INSERT INTO Rooms (RoomNumber, RoomTypeID, Status) VALUES
('101', 1, 'Available'),
('102', 1, 'Available'),
('103', 1, 'Available'),
('104', 1, 'Available'),
('105', 1, 'Available'),
('106', 1, 'Available'),
('201', 2, 'Available'),
('202', 2, 'Available'),
('203', 2, 'Available'),
('204', 2, 'Available'),
('301', 3, 'Available'),
('302', 3, 'Available'),
('303', 3, 'Available'),
('304', 3, 'Available'),
('305', 3, 'Available'),
('306', 3, 'Available');

-- ============================================================
-- 4. 完成提示
-- ============================================================
-- 数据库与初始数据已初始化完毕。
-- 建议的 DBConfig 配置：
--   URL  = jdbc:mysql://localhost:3306/HotelManagementSystem?serverTimezone=Asia/Shanghai&useUnicode=true&characterEncoding=utf8mb4
--   USER = 你的MySQL用户名（如：staff）
--   PASS = 你的MySQL密码
-- ============================================================
