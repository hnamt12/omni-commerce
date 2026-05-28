# Module Documentation

Thư mục này chứa tài liệu chi tiết về luồng hoạt động và thiết kế kỹ thuật của từng module chức năng trong dự án OmniCommerce.

> **👉 Điểm vào đúng:** Bắt đầu từ [`docs/INDEX.md`](../INDEX.md) để có cái nhìn tổng quan về toàn bộ dự án trước khi đọc tài liệu chi tiết ở đây.

---

## Cấu trúc thư mục

```
docs/
├── INDEX.md                ← 🗺️ Entry-point: Tech stack, kiến trúc, bản đồ docs
├── DATABASE_SCHEMA.md      ← 🗄️ Toàn bộ CSDL: bảng, cột, quan hệ
├── TECH_DEBT_MASTER.md     ← ⚡ Checklist 30 điểm cần tối ưu (đọc khi refactor)
├── auth-architecture.md    ← 🔐 Quy tắc Session, Vite, CSRF (đọc khi gặp lỗi 419)
└── modules/
    ├── admin/              ← Nghiệp vụ phân hệ Admin
    └── client/             ← Nghiệp vụ phân hệ Khách hàng
```

---

## Cách dùng đúng (Hướng dẫn cho AI Agent)

### Khi được yêu cầu REFACTOR hoặc TỐI ƯU:
1. Đọc `docs/TECH_DEBT_MASTER.md` → biết ngay 30 điểm cần xử lý
2. Đọc file module tương ứng trong `docs/modules/` để biết chi tiết vị trí code

### Khi được yêu cầu FIX BUG một module cụ thể:
1. Đọc `docs/INDEX.md` → tìm link đến file module đúng
2. Đọc file module đó → hiểu luồng hoạt động và các điểm đã biết cần lưu ý

### Khi gặp lỗi 419/500/Session:
1. Đọc `docs/auth-architecture.md` → làm theo đúng quy tắc đã ghi

---

## Admin Modules (`docs/modules/admin/`)

| File | Nội dung |
|---|---|
| `products.md` | Quản lý Sản phẩm & Biến thể (CRUD, Upload ảnh, Sync attributes) |
| `categories-brands-attributes.md` | Danh mục đa cấp, Thương hiệu, Thuộc tính động |
| `inventory.md` | Tồn kho: Nhập/xuất/kiểm kê, lockForUpdate pattern |
| `orders.md` | Đơn hàng: Vòng đời, POS, Yêu cầu hủy |
| `accounting.md` | Kế toán, Báo cáo tài chính, Cấu hình cổng thanh toán |
| `marketing.md` | Banner, Flash Sale (logic chống trùng lịch), Voucher |
| `posts.md` | Bài viết/Blog (có tích hợp AI tạo nội dung) |
| `staff.md` | Nhân sự & Phân quyền (Spatie Permission) |
| `system.md` | Cài đặt hệ thống, Nhật ký hành động, Thông báo |

## Client Modules (`docs/modules/client/`)

| File | Nội dung |
|---|---|
| `auth.md` | Đăng nhập/Đăng ký/OAuth (Google, Facebook) |
| `products.md` | Trang chủ, Cửa hàng, Chi tiết Sản phẩm |
| `cart.md` | Giỏ hàng (cả buy_now mode) & Voucher |
| `orders.md` | Checkout, VNPay/VietQR/COD, Lịch sử đơn, Mua lại |
| `news.md` | Trang Tin tức/Blog |
| `contact.md` | Trang Liên hệ |

---

## Template tạo file Module mới

```markdown
# Tên Module

## 1. Tổng quan
- Mục đích:
- Đối tượng sử dụng:

## 2. Các file chính liên quan
- Controllers:
- Models:
- Views (Vue/Inertia):

## 3. Luồng hoạt động (Business Logic)
- ...

## 4. Các điểm cần lưu ý (Tech Debt / Improvements)
- ...
```
