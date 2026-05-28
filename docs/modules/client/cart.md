# Giỏ hàng & Mã giảm giá (Client - Cart & Voucher)

## 1. Tổng quan
- **Mục đích:** Xử lý giỏ hàng của người dùng (thêm, sửa, xóa sản phẩm) và áp dụng mã giảm giá (voucher) vào phiên mua hàng (session). Hỗ trợ mua ngay (Buy Now).
- **Đối tượng sử dụng:** Khách hàng (Customer) đã đăng nhập.

## 2. Các file chính liên quan
- **Controllers:** 
  - `app/Http/Controllers/Client/CartController.php` (Quản lý giỏ hàng database & session buy_now)
  - `app/Http/Controllers/Client/VoucherController.php` (Áp dụng/gỡ mã giảm giá)
- **Models:** `Cart`, `ProductVariant`, `Voucher`
- **Views (Vue/Inertia):** 
  - `resources/js/Pages/Client/Cart/Index`

## 3. Luồng hoạt động (Business Logic)

### 3.1. Quản lý Giỏ hàng (CartController)
- **Danh sách (index):** Lấy giỏ hàng của user từ DB (`Cart::where('customer_id', ...)`). Kèm theo thông tin Variant, Attribute để hiển thị.
- **Thêm sản phẩm (add):**
  - Kiểm tra số lượng tồn kho (tổng số lượng trong giỏ hiện tại + số lượng muốn thêm).
  - Hỗ trợ flag `buy_now`: Nếu có, bypass việc lưu vào Database và lưu thông tin item vào `session('buy_now_item')`, sau đó redirect thẳng đến trang Checkout với tham số `mode=buy_now`.
  - Nếu là giỏ hàng bình thường: Update `quantity` nếu đã có sẵn trong giỏ, hoặc tạo record mới (Upsert logic).
- **Cập nhật & Xóa (update, remove):** 
  - Thay đổi số lượng, kiểm tra lại tồn kho `variant->stock` để đảm bảo khách không thêm lố số lượng cho phép. 
  - Các hàm trả về JSON nếu là Ajax request, giúp Inertia cập nhật mượt mà.

### 3.2. Quản lý Mã giảm giá (VoucherController)
- **Áp dụng (applyVoucher):**
  - Kiểm tra tính hợp lệ (`is_active`, thời gian `start_date`, `end_date`).
  - Phân loại giảm theo phần trăm (`percent`) hoặc số tiền cố định (`fixed`).
  - Lưu vào session: `session(['applied_vouchers' => $applied])` theo `scope` (phạm vi giảm giá) để dùng bên trang Checkout.
- **Gỡ mã (removeVoucher):** Xóa session `applied_vouchers` theo `scope` tương ứng.

## 4. Các điểm cần lưu ý (Tech Debt / Improvements)
- **Giỏ hàng Guest (Người dùng chưa đăng nhập):** Hiện tại Controller chặn chức năng thêm giỏ hàng nếu chưa đăng nhập (bắt buộc redirect về `client.login`). Việc không cho khách chưa đăng nhập dùng giỏ hàng sẽ làm giảm tỉ lệ chuyển đổi (Conversion Rate). Cần nâng cấp để sử dụng Session Cart cho Guest, và "Merge Cart" khi họ đăng nhập.
- **Voucher không kiểm tra điều kiện min_order:** Hàm `applyVoucher` chưa kiểm tra các điều kiện phức tạp của voucher như: Giá trị đơn tối thiểu (`min_order_value`), Số lượng sử dụng tối đa của user... Điều này nên được kiểm tra kĩ hơn khi checkout, tuy nhiên sẽ tốt hơn nếu chặn ngay từ lúc Add.
- **Bảo mật giá Cart:** Giỏ hàng đang lưu trường `price` trực tiếp trong Database `Cart`. Nếu giá sản phẩm thay đổi sau khi khách cho vào giỏ, giỏ hàng sẽ giữ giá cũ. Backend nên tự query lại giá từ `ProductVariant` ở thời điểm lấy giỏ hàng ra thanh toán.
