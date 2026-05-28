# Quản lý Danh mục, Thương hiệu & Thuộc tính (Catalog)

## 1. Tổng quan
- **Mục đích:** Quản lý cấu trúc dữ liệu nền tảng cho Sản phẩm (Category, Brand) và hệ thống thuộc tính động (Attributes như Màu sắc, Kích thước) dùng cho biến thể sản phẩm.
- **Đối tượng sử dụng:** Quản trị viên (Admin).

## 2. Các file chính liên quan
- **Controllers:** 
  - `app/Http/Controllers/Admin/CategoryController.php`
  - `app/Http/Controllers/Admin/BrandController.php`
  - `app/Http/Controllers/Admin/AttributeController.php`
- **Models:** `Category`, `Brand`, `Attribute`, `AttributeValue`.
- **Views (Vue/Inertia):** Các thư mục `resources/js/Pages/Admin/Categories`, `Brands`, `Attributes` (bao gồm `Index`, `Form`, `Show`, `Trashed`).

## 3. Luồng hoạt động (Business Logic)

### 3.1. Quản lý Danh mục (Categories)
- Hỗ trợ danh mục đa cấp (chứa `parent_id`).
- Lọc theo `search`, sắp xếp (sort), phân trang mặc định 15 item/trang.
- **Xóa & Cảnh báo:** Hỗ trợ tính năng Xóa mềm (Soft Delete) và Thùng rác (Trashed). Đáng chú ý, khi Admin thực hiện xóa (Soft Delete) một danh mục, hệ thống sẽ trigger **gửi Notification cảnh báo** (`SystemAlertNotification`) tới toàn bộ các user có role là `admin` hoặc `super admin` (xuyên Guard) để theo dõi hành động.
- Trong thùng rác, có thể Khôi phục (Restore) hoặc Xóa vĩnh viễn (Force Delete).

### 3.2. Quản lý Thương hiệu (Brands)
- Tương tự Categories về CRUD và thùng rác, có hỗ trợ upload ảnh logo (`logo_url`).
- Khi Xóa mềm, file ảnh logo vẫn được giữ lại. Khi **Xóa vĩnh viễn (Force Delete)**, file vật lý sẽ bị xóa khỏi disk.
- Cũng có cơ chế gửi Notification cho admin khi xóa mềm.

### 3.3. Quản lý Thuộc tính (Attributes & AttributeValues)
- Thuộc tính có các type: `text`, `select`, `color`. 
- **Tạo/Cập nhật:** Khi gửi danh sách giá trị (ví dụ: ["Đỏ", "Xanh"]), hệ thống sử dụng thuật toán đồng bộ (`array_diff` giữa mảng cũ và mảng mới) để thêm các giá trị mới và xóa các giá trị không còn nằm trong payload. Mã `code` của value tự động sinh bằng `Str::slug()`.
- **Xóa:** Hỗ trợ xóa mềm (chỉ ẩn attribute) và xóa vĩnh viễn (sẽ đính kèm lệnh xóa luôn các record thuộc bảng `AttributeValue` con).

## 4. Các điểm cần lưu ý (Tech Debt / Improvements)
- **Notification Traversal:** Việc lấy danh sách người nhận thông báo đang gọi trực tiếp `User::whereHas('roles', ...)->orWhere('id', 1)->get()` bên trong Controller (tại hàm `destroy` của Category và Brand). Nên chuyển logic này sang các **Observer (CategoryObserver, BrandObserver)** hoặc Event/Listener để code sạch hơn và tuân thủ SRP (Single Responsibility Principle).
- **Hardcode Role Name:** Role name `['admin', 'super admin', 'Super Admin']` đang hardcode trong controller, có thể rủi ro nếu database thay đổi tên role. Nên định nghĩa Const/Enum.
- **Xóa ảnh logo Brand:** Đang dùng `str_replace('/storage/', '', ...)` giống hệt bên Product. Sẽ lỗi nếu lưu cloud S3.
- **Sync Attributes:** Logic so sánh thêm xóa `array_diff` bên AttributeController khá phức tạp, có thể gói gọn vào một hàm Service hoặc Repository chung.
