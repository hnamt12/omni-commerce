# Quản lý Nhân sự & Phân quyền (Auth, Staff & Permissions)

## 1. Tổng quan
- **Mục đích:** Xử lý xác thực đăng nhập vào hệ thống Admin, quản lý danh sách nhân sự (Staff), và phân quyền chi tiết cho từng tài khoản.
- **Đối tượng sử dụng:** Quản trị viên cấp cao (Super Admin).

## 2. Các file chính liên quan
- **Controllers:** 
  - `app/Http/Controllers/Admin/AuthController.php`
  - `app/Http/Controllers/Admin/StaffController.php`
  - `app/Http/Controllers/Admin/PayrollController.php` (Bộ tính lương & hoa hồng)
- **Models:** `User`, `PayrollRecord`, `Role`, `Permission` (Sử dụng package Spatie Laravel Permission).
- **Views (Vue/Inertia):** 
  - xác thực: `Admin/Login`
  - nhân sự: `Admin/Staff/Index`, `Admin/Staff/Form`
  - tính lương: `Admin/Payroll/Index`, `Admin/Payroll/Create`, `Admin/Payroll/Show`
- **Views (Blade Printable):** `admin.payroll.payslip` (Phiếu lương in ấn)

## 3. Luồng hoạt động (Business Logic)

### 3.1. Xác thực (AuthController)
- Sử dụng Guard mặc định là `web`.
- Khi Đăng nhập thành công, hệ thống **tái tạo Session (Regenerate)** để chống tấn công Fixation Session.
- Khi Đăng xuất, vô hiệu hóa Session (`invalidate`) và tạo lại Token CSRF mới (`regenerateToken`).

### 3.2. Quản lý Nhân sự & Quyền (StaffController)
- **Hiển thị (Index):** Tải danh sách các User có role là `staff` (hardcode guard là `web`). Eager load `permissions` và `roles`.
- **Tạo/Sửa (Store/Update):** 
  - Đảm bảo tất cả các quyền (Permissions) đều đã tồn tại trong DB trước khi gán cho User.
  - Áp dụng **Database Transaction**, nếu lỗi thì rollback và bắt lỗi `Throwable` để chắc chắn không bị rò rỉ Transaction (Transaction leak).
  - Sử dụng `syncPermissions()` của Spatie để xóa quyền cũ và cập nhật các quyền mới được chọn trên giao diện.
- **Tối ưu hóa Bulk Insert:** Hàm `ensurePermissionsExist` thay vì dùng vòng lặp và `firstOrCreate` gây ra N query, đã được viết lại thành thuật toán lấy `array_diff` và `Permission::insert()` chỉ tạo ra đúng 2 query (1 select, 1 insert hàng loạt).

### 3.3. Phân hệ Tính Lương & Hoa Hồng (PayrollController)
- **Tính toán tự động:** 
  - Lấy lương cứng (`base_salary`) của nhân viên.
  - Cộng dồn doanh số đơn hàng hoàn thành (`status = completed`) do nhân sự đó chốt (`orders.staff_id`) trong tháng chọn, nhân với `% commission_rate` để tính `commission_amount`.
  - Tự động cộng thưởng hiệu suất KPI (Bonus 2.000.000đ khi doanh thu đơn hàng đạt từ 50.000.000đ trở lên).
- **Duyệt & Chi trả:**
  - Hỗ trợ màn hình preview bảng tính lương nháp hàng loạt, quản lý có thể bổ sung số tiền `deductions` (khấu trừ phạt/bảo hiểm) và ghi chú động cho từng nhân viên trước khi bấm lưu bảng lương chính thức.
  - Đánh dấu trạng thái thanh toán bằng trường `paid_at`.
- **In phiếu lương:** Hỗ trợ render ra phiếu lương điện tử (`admin.payroll.payslip`) định dạng tối ưu chuẩn in ấn để quản lý in hoặc xuất file PDF gửi cho nhân sự đối soát.

## 4. Các điểm cần lưu ý (Tech Debt / Improvements)
- **Role Validation:** Khi tạo User, luôn gán cứng Role `staff`. Điều này làm mất đi tính linh hoạt nếu tương lai hệ thống muốn có các Role cấp độ khác nhau như `Manager`, `Editor`, `Accountant` thay vì gắn chi tiết từng Permission.
- **Bảo mật Passwords:** Hàm `update` chỉ băm mật khẩu khi có nhập vào, điều này tốt. Tuy nhiên, khi một tài khoản Admin bị đổi quyền quan trọng hoặc đổi mật khẩu, hệ thống nên có thêm tính năng bắt buộc đăng xuất khỏi các phiên thiết bị hiện tại (`Auth::logoutOtherDevices()`).
- **Hardcode Permissions:** Danh sách các quyền `['view_orders', 'update_orders', ...]` đang được viết cứng thành mảng ở hàm `create()` và `edit()`. Nếu sau này có module mới, developer sẽ rất dễ quên thêm vào danh sách này. Nên cấu hình chúng trong 1 file config hoặc Enum trung tâm.
