# Quản lý Đơn hàng & Hóa đơn (Orders, Cancel Requests & VAT Billing)

## 1. Tổng quan
- **Mục đích:** Xử lý toàn bộ vòng đời của đơn hàng từ lúc tiếp nhận (từ POS bán lẻ hoặc mua sắm trực tuyến) đến khi giao thành công, bị hủy hoặc trả hàng hoàn tiền. Quản lý yêu cầu hủy đơn, in ấn hóa đơn giá trị gia tăng (VAT) chuẩn điện tử, in phiếu xuất kho nội bộ (Picking Slip) và cấu hình thông tin doanh nghiệp xuất hóa đơn.
- **Đối tượng sử dụng:** Quản trị viên (Admin), Nhân viên Bán hàng (Sale), Nhân viên Kế toán, Thủ kho.

---

## 2. Các file chính liên quan
- **Controllers:** 
  - `app/Http/Controllers/Admin/OrderController.php` (Xử lý đơn hàng, Picking Slip & Hóa đơn)
  - `app/Http/Controllers/Admin/CancelRequestController.php` (Duyệt/Từ chối yêu cầu hủy)
  - `app/Http/Controllers/Client/CheckoutController.php` (Tạo đơn hàng online)
- **Models:** `Order`, `OrderItem`, `OrderStatusHistory`, `OrderCancelRequest`, `Setting`
- **Services:** `App\Services\OrderService` (Hủy đơn, hoàn tiền, hoàn kho).
- **Views (Vue/Inertia):**
  - `resources/js/Pages/Admin/Orders` (Show, Index, Create)
  - `resources/views/admin/orders/print.blade.php` (Mẫu hóa đơn điện tử / K80 POS)
  - `resources/views/admin/orders/picking_slip.blade.php` (Mẫu phiếu lấy hàng kho)

---

## 3. Luồng hoạt động & Logic Nghiệp vụ (Business Logic)

### 3.1. Tạo Đơn hàng & Tính Thuế VAT (Inclusive Tax calculation)
- **Tự động tính thuế VAT 10%:** Khi đơn hàng được khởi tạo từ POS (`OrderController@store`) hoặc trực tuyến (`CheckoutController@store`), hệ thống sẽ tự động tính toán số tiền thuế giá trị gia tăng đã bao gồm trong giá trị đơn hàng (Inclusive VAT 10%) theo công thức:
  $$\text{Tax Amount} = \frac{\text{Subtotal} - \text{Discount Amount}}{110} \times 10$$
  Giá trị này được lưu trực tiếp vào cột `tax_amount` trong bảng `orders` phục vụ việc in ấn báo cáo tài chính pháp lý.
- **Mã Hóa Đơn VAT Sequential:** Khi đơn hàng lưu thành công vào Database, hệ thống sẽ gán mã số hóa đơn điện tử tăng dần bằng cách pad 7 chữ số dựa theo khóa chính đơn hàng (Ví dụ: Đơn ID 125 -> Số hóa đơn `0000125`). Đồng thời lưu giữ Ký hiệu mẫu (`vat_invoice_template`) và Ký hiệu serial (`vat_invoice_serial`) cấu hình động từ hệ thống.

### 3.2. Quản lý Đơn hàng & Cập nhật Trạng thái
- **Danh sách (Index):** Lọc theo `search`, trạng thái. Số lượng đơn hàng theo từng trạng thái được đếm tối ưu qua `GROUP BY` để làm tabs. Có 9 trạng thái chuẩn hóa.
- **Cập nhật trạng thái (updateStatus):** Sử dụng `lockForUpdate` ngăn race condition. Khi chuyển sang "Đã hoàn thành", nếu đơn hàng "unpaid" sẽ tự động chuyển sang "paid" và lưu thời gian thu tiền.

### 3.3. In ấn Đa Dạng Khổ Giấy (Print Formatting & Templates)
Hệ thống cung cấp 3 nút bấm phân loại in ấn trực tiếp tại màn hình chi tiết đơn hàng:
- **🖨️ HĐ A4 (Khổ lớn - Hóa đơn VAT chuẩn điện tử):**
  - Đọc thông tin công ty bán hàng trực tiếp từ bảng `settings` (Tên công ty, MST, Địa chỉ, Hotline, Email) thay vì viết cứng.
  - Hiển thị đầy đủ thông tin VAT (Thuế suất 10%, tiền thuế cụ thể, giá trị hàng chưa thuế).
  - Tích hợp bộ **chuyển số tiền sang chữ tiếng Việt** (Number-to-words) hiển thị tại dòng "Số tiền viết bằng chữ".
  - Hiển thị khối **Chữ ký điện tử** (Digitally Signed) hợp lệ theo Nghị định 123/2020 của doanh nghiệp.
- **🧾 HĐ K80 (Khổ nhỏ - Hóa đơn bán lẻ POS):**
  - Thích hợp cho các máy in nhiệt bán lẻ 80mm tại quầy.
  - Định dạng font chữ siêu condensed, lược bỏ các viền khung cồng kềnh, chuyển các cột thành hàng dọc, tối ưu hóa độ cao cuộn giấy in nhiệt.
- **Live QR code tra cứu:**
  - Cả hai khổ giấy A4 và K80 đều tự động tạo ảnh mã QR code liên kết trực tiếp tới trang tra cứu đơn hàng trực tuyến của khách hàng (sử dụng API QR Server bảo mật).
- **📦 Phiếu Soạn Hàng (Picking Slip):**
  - Phiếu xuất kho nội bộ dành riêng cho thủ kho soạn hàng với mã SKU hiển thị to, phân loại chi tiết sản phẩm, số lượng cần lấy trực quan và các ô checkbox để nhân viên kiểm đếm.

---

## 4. Các điểm cần lưu ý (Tech Debt / Improvements)
- **Cổng kết nối Tổng cục Thuế:** Hiện tại số hóa đơn VAT và serial chỉ đang được lưu vết, ký điện tử giả lập và hiển thị offline trên PDF/Bản in. Để thực sự phát hành hóa đơn điện tử có mã của Cơ quan Thuế, cần tích hợp thêm API bên thứ ba (như VNPT-Invoice, Viettel SInvoice, hoặc MISA MeInvoice) thông qua một Queue Job để gửi dữ liệu hóa đơn lên Tổng cục Thuế ngay khi đơn hàng chuyển sang trạng thái "Đã hoàn thành".
- **Hardcode trạng thái:** Mảng `STATUSES` vẫn đang là Tiếng Việt trong Controller. Nên chuyển sang định dạng Enum để chuẩn hóa quốc tế hóa (i18n).
