# Kế toán & Báo cáo (Accounting & Payment Methods)

## 1. Tổng quan
- **Mục đích:** Cung cấp hệ thống báo cáo tài chính, quản lý giao dịch thanh toán, báo cáo công nợ (COD) và đối soát giá trị tồn kho. Đồng thời quản lý các cổng thanh toán.
- **Đối tượng sử dụng:** Kế toán viên, Quản trị viên (Admin).

## 2. Các file chính liên quan
- **Controllers:** 
  - `app/Http/Controllers/Admin/AccountingController.php`
  - `app/Http/Controllers/Admin/PaymentMethodController.php`
- **Models:** `Transaction`, `VoucherUsage`, `Order`, `PaymentMethod`, `InventoryHistory`
- **Views (Vue/Inertia):** Thư mục `resources/js/Pages/Admin/Accounting` và `PaymentMethod`.

## 3. Luồng hoạt động (Business Logic)

### 3.1. Kế toán & Báo cáo (AccountingController)
Controller này chủ yếu chứa các phương thức Read-Only (thống kê & báo cáo) dựa trên khoảng thời gian (`start_date`, `end_date`), mặc định là 30 ngày qua.
- **Giao dịch (Transactions):** Liệt kê các lần thanh toán online, tính tổng số tiền giao dịch thành công/thất bại/đang xử lý.
- **Sử dụng Voucher (Voucher Usage):** Thống kê số lượt sử dụng voucher và tổng số tiền đã giảm giá (discount) cho khách hàng trong kỳ.
- **Báo cáo Công nợ (Debt Report):** Liệt kê các đơn hàng giao bằng COD nhưng trạng thái thanh toán là `unpaid` (Chưa thu tiền). Thống kê rủi ro như "Đơn đã giao nhưng chưa thu tiền".
- **Đối soát thanh toán (Payment Reconciliation):** Group doanh thu theo `payment_method` (Momo, VNPay, COD). Sử dụng query `SUM(CASE WHEN ...)` để gom dữ liệu cực kỳ nhanh chóng.
- **Định giá tồn kho (Inventory Valuation):** Một logic khá phức tạp để đối soát số lượng và giá trị (nhập, xuất, điều chỉnh). Nó `JOIN` bảng `inventory_histories` với `product_variants`, tính tổng số tiền thay đổi trong kỳ dựa trên giá của variant, sau đó tính toán trong PHP (Collection) thay vì DB và thủ công phân trang bằng `LengthAwarePaginator`.

### 3.2. Cấu hình Thanh toán (PaymentMethodController)
- Quản lý CRUD các cổng thanh toán.
- **Đặc biệt:** Ở hàm `index`, có cơ chế "Safe fallback" dùng `firstOrCreate` để luôn đảm bảo có phương thức `cod` (Thanh toán khi nhận hàng) tồn tại trong Database, tránh lỗi hệ thống khi chưa seed data.
- Lưu cấu hình cổng (API keys, Secret) dưới dạng JSON trong trường `config`.

## 4. Các điểm cần lưu ý (Tech Debt / Improvements)
- **Hiệu năng Inventory Valuation:** Việc tính toán `InventoryValuation` phải lấy toàn bộ record trong kỳ (`get()`), sau đó dùng foreach trên server PHP để group theo SKU, tính toán giá trị, rồi mới tạo Paginator thủ công. Nếu trong 30 ngày có hàng triệu thay đổi tồn kho, ứng dụng sẽ bị Out of Memory (OOM) hoặc Crash máy chủ. Cần chuyển logic Group By và SUM này 100% xuống tầng SQL hoặc Elasticsearch / Clickhouse.
- **Bảo mật Payment Config:** Cột `config` của `PaymentMethod` chứa khóa bảo mật (API keys, Secret keys). Nếu chỉ lưu plaintext dạng JSON vào DB, nó tiềm ẩn rủi ro nếu DB bị dump. Cần áp dụng mã hóa (Encryption) như trường `$casts = ['config' => 'encrypted:json']` của Laravel cho column này.
- **Tính toàn vẹn Kế toán:** Các số liệu `stats` được tính bằng cách gọi lặp lại các câu lệnh count/sum độc lập (vd: đếm pending_count riêng, sum total_amount riêng). Điều này tạo ra nhiều queries giống hệt nhau về điều kiện `where`. Nên gộp lại thành 1 query `selectRaw` để lấy tất cả stats trong 1 lần kết nối DB.
