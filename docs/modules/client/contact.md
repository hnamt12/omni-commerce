# Liên hệ (Client - Contact)

## 1. Tổng quan
- **Mục đích:** Hiển thị trang liên hệ chứa các thông tin liên lạc của hệ thống (Điện thoại, Email, Địa chỉ, Bản đồ Google Maps).
- **Đối tượng sử dụng:** Tất cả người dùng.

## 2. Các file chính liên quan
- **Controllers:** `app/Http/Controllers/Client/ContactController.php`
- **Models:** `Setting`
- **Views (Vue/Inertia):** 
  - `resources/js/Pages/Client/Contact/Index`

## 3. Luồng hoạt động (Business Logic)
- **Lấy thông tin cài đặt:** Tại hàm `index()`, hệ thống truy vấn vào bảng `Setting` với mảng các `key` được định nghĩa sẵn (`contact_phone`, `contact_email`, `contact_address`, `google_maps_iframe`).
- **Chuyển đổi:** Sử dụng hàm `pluck('value', 'key')` để biến kết quả query thành một key-value array gọn gàng gửi cho Inertia JS render ra giao diện.

## 4. Các điểm cần lưu ý (Tech Debt / Improvements)
- **Cache dữ liệu Settings:** Bảng `Setting` chứa dữ liệu gần như tĩnh (ít thay đổi). Truy vấn vào Database mỗi lần khách hàng vào trang Liên hệ là một sự lãng phí tài nguyên.
  - *Giải pháp:* Nên Cache lại toàn bộ bảng Setting bằng Redis/File và chỉ xóa Cache khi Admin cập nhật cấu hình ở Backend (trong `SettingController`). 
- **Thiếu form liên hệ (Contact Form):** Hiện tại trang chỉ có tính năng hiển thị thông tin, chưa có form để khách hàng có thể điền gửi tin nhắn (Email/Feedback) trực tiếp về hệ thống. Nếu có, cần bổ sung logic Validate và Gửi Mail ở Controller này.
