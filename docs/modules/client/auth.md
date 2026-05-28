# Xác thực & Hồ sơ (Client - Auth & Profile)

## 1. Tổng quan
- **Mục đích:** Xử lý các nghiệp vụ đăng nhập, đăng ký, đăng xuất, xác thực qua mạng xã hội (OAuth) và quản lý hồ sơ người dùng, bao gồm thông tin cá nhân và sổ địa chỉ.
- **Đối tượng sử dụng:** Khách hàng (Customer).

## 2. Các file chính liên quan
- **Controllers:** 
  - `app/Http/Controllers/Client/AuthController.php` (Đăng nhập, đăng ký, Socialite)
  - `app/Http/Controllers/Client/ProfileController.php` (Thông tin cá nhân, sổ địa chỉ)
- **Models:** `Customer`, `Address`, `Setting`
- **Views (Vue/Inertia):** 
  - `resources/js/Pages/Client/Auth/Login`
  - `resources/js/Pages/Client/Auth/Register`
  - `resources/js/Pages/Client/Auth/ForgotPassword` [NEW]
  - `resources/js/Pages/Client/Auth/ResetPassword` [NEW]
  - `resources/js/Pages/Client/Profile/Index`

## 3. Luồng hoạt động (Business Logic)

### 3.1. Xác thực (AuthController)
- **Đăng nhập (login):** Sử dụng guard `customer` (`Auth::guard('customer')->attempt()`). Hỗ trợ remember me. Redirect về URL dự định (intended) hoặc trang chủ sau khi thành công. Validation đầu vào chi tiết bằng tiếng Việt.
- **Đăng ký (register):** Xác thực email unique, mật khẩu tối thiểu 6 ký tự. Sau khi tạo `Customer`, hệ thống sẽ tự động đăng nhập người dùng (Auto-login). Hỗ trợ nút Đăng ký hoàn chỉnh bằng route `client.register.submit`.
- **Đăng nhập Mạng xã hội (Socialite):**
  - Hỗ trợ OAuth thông qua `Laravel Socialite` (Google, Facebook...).
  - Hàm `handleProviderCallback` gọi `stateless()` để tránh lỗi session với Inertia.
  - Logic tự động đăng ký: Nếu email đã tồn tại, sẽ liên kết ID mạng xã hội vào tài khoản cũ. Nếu chưa có, tự tạo một tài khoản mới với mật khẩu ngẫu nhiên.
- **Quên mật khẩu (Forgot/Reset Password):**
  - Hỗ trợ gửi link khôi phục qua email khách hàng (`client.password.email`).
  - Giao diện đặt lại mật khẩu trực quan, bảo mật đa lớp thông qua token của `password_reset_tokens`.

### 3.2. Quản lý Hồ sơ (ProfileController)
- **Xem hồ sơ (index):** Lấy thông tin customer hiện tại và danh sách địa chỉ (sắp xếp địa chỉ mặc định lên đầu).
- **Cập nhật (updateInfo):** Cho phép sửa `name`, `phone`, `gender` và tải lên `avatar` mới (lưu trữ vật lý qua Storage disk `public/avatars`, tự động dọn dẹp avatar cũ).
- **Đổi mật khẩu (updatePassword):** Khách hàng có thể đổi mật khẩu trực tiếp qua modal Bảo mật tài khoản trong trang cá nhân, xác thực thông qua mật khẩu hiện tại (`current_password:customer`).
- **Sổ địa chỉ (storeAddress):** Thêm mới địa chỉ giao hàng. Tự động đánh dấu `is_default = 1` nếu đây là địa chỉ đầu tiên của khách hàng.

## 4. Các điểm cần lưu ý (Tech Debt / Improvements)
- **Cấu hình Mail:** Để gửi liên kết Đặt lại mật khẩu (Forgot Password), dự án cần được cấu hình chính xác tài khoản SMTP (`MAIL_MAILER`, `MAIL_HOST`, `MAIL_PORT`...) trong file `.env`. Trong môi trường cục bộ (Dev), đường dẫn khôi phục sẽ tự động được ghi nhận tại file log của Laravel.
- **Xóa / Cập nhật địa chỉ:** Trong `ProfileController` chỉ mới có `storeAddress`, cần bổ sung thêm logic `updateAddress` và `deleteAddress` trong tương lai để tối ưu trải nghiệm người dùng.
