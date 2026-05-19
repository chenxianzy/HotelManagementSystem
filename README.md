# HotelManagementSystem 酒店信息管理系统

<p align="center">
  <img src="https://img.shields.io/badge/Java-17-orange" alt="Java 17">
  <img src="https://img.shields.io/badge/Tomcat-10.1-blue" alt="Tomcat 10.1">
  <img src="https://img.shields.io/badge/MySQL-8.0-green" alt="MySQL 8.0">
  <img src="https://img.shields.io/badge/Maven-3.9+-red" alt="Maven">
</p>

基于 Java + Tomcat 10 + MySQL 的酒店信息管理系统，支持前台入住/退房、房间状态管理、顾客自助查询等功能。

---

## 📚 技术栈

| 层级 | 技术 |
|------|------|
| 后端 | Java 17, Jakarta Servlet 6.0 |
| 前端 | JSP, HTML5, CSS3, Font Awesome |
| 数据库 | MySQL 8.0 |
| 连接池 | HikariCP 5.1 |
| 构建工具 | Maven 3 |
| 服务器 | Apache Tomcat 10.1+ |

---

## 🏨 功能特性

- 🔑 **用户认证**：支持顾客、前台、前台经理三种角色登录
- 📝 **用户注册**：顾客可自助注册账号
- 📊 **仪表盘**：实时显示客房总数、空闲房间数、今日入住/退房数
- 🏨 **房间管理**：查看所有房间状态，支持按房型筛选
- 📅 **入住办理**：前台为顾客办理入住，自动创建客人档案和订单
- 🛑 **退房办理**：支持前台退房和顾客自助退房，自动计算费用
- 🔒 **权限控制**：AuthFilter 拦截未登录请求，不同角色访问不同功能

---

## 🚀 快速开始

### 环境要求

- JDK 17+
- Apache Tomcat **10.1+**（⚠️ 必须使用 Tomcat 10，本项目使用 Jakarta EE 命名空间）
- MySQL 8.0+
- Maven 3.9+
- IntelliJ IDEA（推荐）

### 1. 克隆/下载项目

```bash
git clone https://github.com/yourusername/HotelManagementSystem.git
cd HotelManagementSystem
```

### 2. 初始化数据库

在 MySQL Workbench 或命令行中执行：

```bash
mysql -u root -p < src/main/resources/schema.sql
```

该脚本会：
- 创建 `HotelManagementSystem` 数据库（utf8mb4）
- 创建 5 张核心数据表：`Users`、`Guests`、`RoomTypes`、`Rooms`、`Bookings`
- 插入初始数据（3 个默认账号、3 种房型、16 间客房）

### 3. 配置数据库连接

打开 `src/main/java/com/example/hotelmanagementsystem/dao/DBConfig.java`，修改为本地 MySQL 账号：

```java
public static final String URL = "jdbc:mysql://localhost:3306/HotelManagementSystem?serverTimezone=Asia/Shanghai&useUnicode=true&characterEncoding=utf8";
public static final String USER = "root";          // 你的 MySQL 用户名
public static final String PASSWORD = "your_password"; // 你的 MySQL 密码
```

### 4. 编译项目

```bash
mvn clean install
```

### 5. 部署运行

#### 方式一：IntelliJ IDEA + SmartTomcat（推荐开发方式）

1. 安装 SmartTomcat 插件
2. 点击右上角 `Add Configuration` → `SmartTomcat`
3. **Tomcat server**：选择 Tomcat 10.1 的安装目录
4. **Context path**：`/HotelManagementSystem`
5. 点击 `Apply` → `OK`
6. 点击绿色三角形启动

#### 方式二：传统 war 部署

```bash
mvn clean package
# 将生成的 target/HotelManagementSystem-1.0-SNAPSHOT.war
# 复制到 Tomcat 的 webapps/ 目录下
```

### 6. 访问系统

浏览器打开：

```
http://localhost:8080/HotelManagementSystem/login
```

---

## 🔐 默认账号

| 用户名 | 密码 | 角色 | 说明 |
|--------|------|------|------|
| `manager` | `Manager123` | 前台经理 | 最高权限，可查看所有功能 |
| `staff` | `Staff123` | 前台 | 办理入住/退房、查看房间状态 |
| `guest` | `Guest123` | 顾客 | 查询房间、自助退房 |

> 💡 密码使用 SHA-256 + Base64 加密存储。如需新增账号，可通过注册页面注册顾客账号。

---

## 🌐 项目结构

```
HotelManagementSystem/
├── pom.xml                              # Maven 构建配置
├── README.md                            # 项目说明文档
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/example/hotelmanagementsystem/
│   │   │       ├── dao/                 # 数据访问层
│   │   │       │   ├── DatabaseConnection.java  # HikariCP 连接池
│   │   │       │   ├── DBConfig.java           # 数据库配置
│   │   │       │   ├── UserDAO.java            # 用户数据操作
│   │   │       │   ├── RoomDAO.java            # 房间数据操作
│   │   │       │   └── BookingDAO.java         # 订单数据操作
│   │   │       ├── model/               # 实体类
│   │   │       │   ├── User.java
│   │   │       │   ├── Guest.java
│   │   │       │   ├── Room.java
│   │   │       │   └── Booking.java
│   │   │       ├── servlet/             # Servlet 控制器
│   │   │       │   ├── LoginServlet.java
│   │   │       │   ├── RegisterServlet.java
│   │   │       │   ├── LogoutServlet.java
│   │   │       │   ├── IndexServlet.java
│   │   │       │   ├── CheckInServlet.java
│   │   │       │   ├── CheckInFormServlet.java
│   │   │       │   ├── CheckOutServlet.java
│   │   │       │   ├── RoomStatusServlet.java
│   │   │       │   ├── AllRoomStatusServlet.java
│   │   │       │   └── UpdateRoomStatusServlet.java
│   │   │       └── filter/
│   │   │           └── AuthFilter.java      # 登录认证过滤器
│   │   └── webapp/                  # Web 资源
│   │       ├── WEB-INF/
│   │       │   └── web.xml            # Servlet 配置
│   │       ├── login.jsp                # 登录页
│   │       ├── register.jsp             # 注册页
│   │       ├── index.jsp                # 首页仪表盘
│   │       ├── header.jsp               # 公共头部导航
│   │       ├── checkin_form.jsp         # 入住表单
│   │       ├── checkout_form.jsp        # 退房表单
│   │       ├── all_room_status.jsp      # 所有房间状态
│   │       ├── available_rooms.jsp      # 可用房间列表
│   │       └── ...                      # 其他页面
│   └── resources/
│       └── schema.sql                   # 数据库初始化脚本
└── ...
```

---

## 📝 数据库设计

### 核心表关系

```
Users (1) ----< (0..1) ----> Guests
Guests (1) ----< (0..N) ----> Bookings
Rooms (1) ----< (0..N) ----> Bookings
RoomTypes (1) ----< (1..N) ----> Rooms
```

### 表说明

| 表名 | 说明 |
|------|------|
| `Users` | 系统登录账号（顾客/前台/经理） |
| `Guests` | 客人详细资料（关联 Users 或独立录入） |
| `RoomTypes` | 房型定义（标准间、豪华间、行政套房） |
| `Rooms` | 具体客房（房号、房型、状态） |
| `Bookings` | 入住/退房订单记录 |

---

## ⚠️ 常见问题

### 1. 登录提示"用户名或密码错误"

请先确认 `schema.sql` 已正确执行，数据库中存在初始账号：

```sql
USE HotelManagementSystem;
SELECT Username, Password, Role, Status FROM Users;
```

如果 `Users` 表为空，请重新执行 `schema.sql`。

### 2. Tomcat 启动报 JSP 编译错误（User cannot be resolved）

确保：
- 运行了 `mvn clean install` 生成 `.class` 文件
- Tomcat 版本为 **10.1+**（本项目使用 `jakarta.servlet`，Tomcat 9 不支持）

### 3. 数据库连接报错（Unsupported character encoding）

检查 `DBConfig.java` 中的 URL，`characterEncoding` 应设置为 `utf8`（Java 识别的编码名），而不是 `utf8mb4`（MySQL 字符集名）：

```java
"jdbc:mysql://localhost:3306/HotelManagementSystem?serverTimezone=Asia/Shanghai&useUnicode=true&characterEncoding=utf8"
```

---

## 📖 开发备注

- 项目密码加密方式：**SHA-256 + Base64**（注册时自动加密）
- 数据库连接池：**HikariCP**（最大连接数 10，最小空闲连接 2）
- 认证方式：基于 **HttpSession**，由 `AuthFilter` 全局拦截
- 事务控制：`BookingDAO` 中的入住/退房操作使用 JDBC 手动事务（`setAutoCommit(false)`）

---

## 👨‍💻 作者

本项目为酒店信息管理系统课程设计/毕业设计示例项目。

如有问题，欢迎提交 Issue。
