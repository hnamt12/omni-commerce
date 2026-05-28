# Quản lý Đơn hàng & Thanh toán (Client - Orders, Checkout & Payments)

## 1. Tổng quan
- **Mục đích:** Quá trình khách hàng duyệt giỏ hàng, tiến hành thanh toán, xem lịch sử đơn hàng, hủy đơn, mua lại và xử lý tích hợp các cổng thanh toán (VNPay, VietQR, COD).
- **Đối tượng sử dụng:** Khách hàng (Customer) đã đăng nhập.

## 2. Các file chính liên quan
- **Controllers:** 
  - `app/Http/Controllers/Client/CheckoutController.php` (Quá trình thanh toán)
  - `app/Http/Controllers/Client/OrderController.php` (Lịch sử, chi tiết, hủy, mua lại)
  - `app/Http/Controllers/Client/PaymentController.php` (Callback VNPay, xác nhận VietQR, thử lại thanh toán)
- **Models:** `Order`, `OrderItem`, `OrderStatusHistory`, `Cart`, `Address`, `PaymentMethod`, `ProductVariant`
- **Services:** `App\Services\PaymentService` (Tạo URL VNPay, xử lý giao dịch).
- **Views (Vue/Inertia):** 
  - Các file giao diện trong `resources/js/Pages/Client/Checkout/` (Index, Success, PaymentQr)
  - Các file giao diện trong `resources/js/Pages/Client/Order/` (Index, Show)

## 3. Luồng hoạt động (Business Logic)

### 3.1. Quá trình Thanh toán (CheckoutController)
- **Hiển thị trang Thanh toán (checkout):** Hỗ trợ 2 chế độ (`mode = cart` hoặc `mode = buy_now`). Tải danh sách sản phẩm, tính toán tổng tiền, hiển thị địa chỉ mặc định, danh sách voucher khả dụng và các phương thức thanh toán đang hoạt động.
- **Xử lý Đặt hàng (store):**
  - **Địa chỉ:** Khách có thể chọn địa chỉ cũ hoặc tạo mới. Nếu tạo mới và chưa có địa chỉ nào, sẽ tự động gán làm mặc định.
  - **Tạo đơn:** Tạo bản ghi `Order` với trạng thái `Chờ xác nhận` và thanh toán `unpaid`.
  - **Trừ tồn kho:** Dùng `lockForUpdate()` trên `ProductVariant` để tránh race condition khi nhiều người cùng mua. Sau đó gọi `decrement('stock')`.
  - **Dọn dẹp:** Xóa giỏ hàng hoặc session `buy_now_item`.
  - **Thông báo:** Gửi `NewOrderNotification` cho Admin.
  - **Chuyển hướng:** Tùy vào phương thức (VNPay -> redirect URL, VietQR -> trang mã QR, COD -> trang thành công). Quá trình này được bao bọc an toàn trong Transaction.

### 3.2. Quản lý Đơn hàng (OrderController)
- **Danh sách & Chi tiết:** Lấy danh sách đơn hàng của user đang đăng nhập, hiển thị chi tiết kèm theo lịch sử thay đổi trạng thái (`statusHistories`).
- **Hủy đơn (cancel):** 
  - Chỉ cho phép hủy khi trạng thái là `Chờ xác nhận`.
  - Thực hiện hoàn lại số lượng tồn kho (`increment`) cho `ProductVariant`.
  - Ghi log vào `OrderStatusHistory`. Tất cả chạy trong Transaction.
- **Mua lại (rebuy):** Kiểm tra tồn kho và trạng thái kích hoạt của sản phẩm trước. Nếu hợp lệ, đưa tất cả sản phẩm của đơn hàng cũ vào giỏ hàng (`Cart`).

### 3.3. Xử lý Thanh toán (PaymentController)
- **VNPay Callback (vnpayReturn):** Xác thực chữ ký (`hash_hmac`), cập nhật `payment_status` thành `paid` nếu giao dịch thành công. Ghi log lịch sử. Tránh cập nhật sai nếu giao dịch thất bại hoặc sai chữ ký.
- **VietQR (paymentQr & confirmPaid):** Hiển thị mã QR dựa trên thông tin cấu hình ngân hàng. Cho phép khách hàng nhấn xác nhận đã chuyển tiền (ghi chú lịch sử cho Admin).
- **Thanh toán lại (retryPayment):** Cho phép khách hàng thanh toán lại các đơn hàng đang `unpaid`.

## 4. Các điểm cần lưu ý (Tech Debt / Improvements)
- **Hardcode trạng thái và phương thức thanh toán:** Các trạng thái như `Chờ xác nhận`, `Đã hủy` và phương thức như `VNPay`, `VietQR`, `COD` đang bị hardcode trực tiếp dưới dạng chuỗi trong logic code. Cần chuyển sang dạng Enum để dễ quản lý, tránh lỗi type-o và hỗ trợ đa ngôn ngữ.
- **Phí vận chuyển Hardcode:** Phí ship (`shippingFee`) đang bị hardcode cố định là `35_000` trong `CheckoutController`. Nên lấy từ database hoặc tính toán theo API vận chuyển thực tế.
- **Deadlock trong Transaction trừ tồn kho:** Quá trình lặp qua từng `ProductVariant` để `lockForUpdate()` có thể gây deadlock nếu hai đơn hàng mua cùng các sản phẩm nhưng theo thứ tự khác nhau. Nên sắp xếp (sort) ID của variant trước khi lock.
- **Log Debug trong Controller:** Trong hàm `store` của `CheckoutController` đang tồn tại đoạn block log debug (vd: `--- BẮT ĐẦU TEST THÔNG BÁO ĐƠN HÀNG ---`). Cần dọn dẹp các dòng log này trước khi đưa lên môi trường Production.
