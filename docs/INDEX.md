# OmniCommerce — Tổng quan Dự án

> **Đây là file ENTRY-POINT.** Bất kỳ AI Agent hoặc Developer mới nào tiếp cận dự án, hãy đọc file này TRƯỚC TIÊN trước khi đọc bất kỳ thứ gì khác.

---

## 1. Tech Stack

| Layer | Công nghệ |
|---|---|
| **Backend** | Laravel 11 (PHP 8.2+) |
| **Frontend** | Vue 3 (Composition API) + Inertia.js |
| **Styling** | TailwindCSS v3 |
| **Build Tool** | Vite |
| **Database** | MySQL |
| **Auth** | Laravel Breeze (Guard `web` cho Admin, Guard `customer` cho Client) |
| **Permissions** | Spatie Laravel Permission |
| **Realtime** | Laravel Reverb (WebSocket) |
| **Session** | Database Driver (bắt buộc — xem `docs/auth-architecture.md`) |
| **Payments** | VNPay, VietQR, COD |
| **File Storage** | Local Public Disk (S3-ready nhưng chưa implement) |
| **AI Features** | Tích hợp tạo nội dung Blog tự động |

---

## 2. Kiến trúc tổng thể

Dự án theo mô hình **Monolith + Inertia SPA**, không có REST API thuần. Mọi giao tiếp Client ↔ Server đều đi qua Inertia.js (render Server-Side Component lên Vue).

```
OmniCommerce/
├── app/
│   ├── Http/
│   │   ├── Controllers/
│   │   │   ├── Admin/          ← Toàn bộ nghiệp vụ cho phân hệ Admin
│   │   │   └── Client/         ← Toàn bộ nghiệp vụ cho phân hệ Khách hàng
│   │   └── Middleware/
│   ├── Models/                  ← Eloquent Models (Product, Order, Customer...)
│   ├── Services/                ← Business Logic phức tạp (OrderService, PaymentService)
│   └── Notifications/           ← Hệ thống thông báo
├── database/
│   └── migrations/              ← 60 file migrations
├── resources/
│   └── js/
│       └── Pages/
│           ├── Admin/           ← Vue Pages cho Admin
│           └── Client/          ← Vue Pages cho Khách hàng
├── routes/
│   └── web.php                  ← Tất cả routes
└── docs/                        ← 📖 Tài liệu dự án (bạn đang ở đây)
```

---

## 3. Phân hệ & Phân quyền

### 3.1. Phân hệ Admin (`/dashboard`, Guard: `web`)
Dành cho nhân viên và quản trị viên. Phân quyền chi tiết dùng **Spatie Permission**.

| Role | Quyền |
|---|---|
| `super admin` | Toàn quyền, bao gồm quản lý nhân sự |
| `admin` | Hầu hết các nghiệp vụ |
| `staff` | Các quyền cụ thể được gán thủ công |

### 3.2. Phân hệ Client (`/`, Guard: `customer`)
Dành cho khách hàng cuối (End-user). Model là `Customer` (tách biệt với `User` của Admin).

---

## 4. Bản đồ Tài liệu (Documentation Map)

### 📌 Global Docs (Đọc trước)
| File | Mô tả |
|---|---|
| `docs/INDEX.md` | **File này** — Tổng quan kỹ thuật |
| `docs/auth-architecture.md` | Kiến trúc Session, Vite, CSRF — BẮT BUỘC đọc khi gặp lỗi 419/500 |
| `docs/DATABASE_SCHEMA.md` | Sơ đồ CSDL, Relationships của 25+ bảng |
| `docs/FRONTEND_ARCHITECTURE.md` | Bản đồ cấu trúc Frontend, dữ liệu Inertia & quy chuẩn UI |
| `docs/TECH_DEBT_MASTER.md` | ⚡ Toàn bộ danh sách cần tối ưu & refactor |

### 🔐 Admin Modules (`docs/modules/admin/`)
| File | Module |
|---|---|
| `products.md` | Quản lý Sản phẩm & Biến thể |
| `categories-brands-attributes.md` | Danh mục, Thương hiệu, Thuộc tính |
| `inventory.md` | Quản lý Tồn kho |
| `orders.md` | Đơn hàng & Yêu cầu Hủy |
| `accounting.md` | Kế toán, Báo cáo, Cổng Thanh toán |
| `marketing.md` | Banner, Flash Sale, Voucher |
| `posts.md` | Bài viết / Blog |
| `staff.md` | Nhân sự & Phân quyền |
| `system.md` | Cấu hình Hệ thống, Nhật ký, Thông báo |

### 🛍️ Client Modules (`docs/modules/client/`)
| File | Module |
|---|---|
| `auth.md` | Đăng nhập, Đăng ký, OAuth (Socialite) |
| `products.md` | Trang chủ, Cửa hàng, Chi tiết Sản phẩm |
| `cart.md` | Giỏ hàng & Mã giảm giá |
| `orders.md` | Checkout, Thanh toán (VNPay/VietQR), Lịch sử đơn |
| `news.md` | Trang Tin tức / Blog |
| `contact.md` | Trang Liên hệ |

---

## 5. Quy ước Quan trọng

- **⚠️ SESSION_DRIVER=database** bắt buộc trong `.env`.
- **⚠️ Vite host** phải là `127.0.0.1` (không dùng IPv6).
- **⚠️ Dùng `lockForUpdate()`** cho mọi thao tác thay đổi `stock` và `payment_status`.
- **❌ KHÔNG dùng `redirect()->intended()`** trong Admin Auth — luôn dùng route tĩnh.
- **❌ KHÔNG tin tưởng price từ Frontend** — luôn query lại giá từ `ProductVariant`.
