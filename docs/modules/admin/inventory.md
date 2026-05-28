# Quản lý Tồn kho & Kho Bãi (Inventory & Warehousing)

## 1. Tổng quan
- **Mục đích:** Theo dõi, thống kê và cập nhật (nhập/xuất/kiểm kê) số lượng hàng tồn kho cho các biến thể sản phẩm. Theo dõi tồn kho chi tiết theo lô nhập (lot number), hạn sử dụng (expiry date) từ các nhà cung cấp, và tự động hóa quy trình in phiếu lấy hàng (Picking Slip) cũng như cảnh báo hết hàng.
- **Đối tượng sử dụng:** Quản trị viên (Admin), Nhân viên thủ kho, Nhân viên kế toán kho.

---

## 2. Các file chính liên quan
- **Controllers:**
  - `app/Http/Controllers/Admin/InventoryController.php` (Quản lý tồn kho)
  - `app/Http/Controllers/Admin/SupplierController.php` (CRUD Nhà cung cấp)
  - `app/Http/Controllers/Admin/OrderController.php` (Xử lý in Picking Slip)
  - `app/Http/Controllers/Admin/SettingController.php` (Quản lý ngưỡng báo kho)
- **Models:**
  - `Product`, `ProductVariant`, `InventoryHistory`
  - `Supplier` [NEW] (Thông tin nhà cung cấp)
  - `ProductLot` [NEW] (Tồn kho thực tế theo lô hàng/hạn sử dụng)
- **Views (Vue/Inertia):**
  - `resources/js/Pages/Admin/Inventory` (Edit, Index)
  - `resources/js/Pages/Admin/Suppliers` (Quản lý NCC)
  - `resources/views/admin/orders/picking_slip.blade.php` (Mẫu in phiếu xuất kho nội bộ)

---

## 3. Luồng hoạt động & Logic Nghiệp vụ (Business Logic)

### 3.1. Quản lý Nhà Cung Cấp (Suppliers)
- Cho phép quản lý danh mục đối tác cung ứng hàng hóa thông qua mã nhà cung cấp (`code`, ví dụ: `NCC-1234`), thông tin liên hệ (điện thoại, email, địa chỉ), và trạng thái hoạt động.
- Liên kết chặt chẽ với dữ liệu lô hàng nhập khẩu để truy xuất nguồn gốc hàng hóa.

### 3.2. Quản lý Lô Hàng & Hạn Sử Dụng (Product Lots & Expiry Tracking)
- **Cấu trúc dữ liệu theo Lô:** Mỗi biến thể sản phẩm có thể được nhập về theo nhiều đợt khác nhau, lưu giữ trong bảng `product_lots` gồm thông tin: số lô (`lot_number`), nhà cung cấp (`supplier_id`), hạn sử dụng (`expiry_date`), số lượng hiện tại (`quantity`), và số lượng nhập ban đầu (`initial_quantity`).
- **Tích hợp giao diện:** Khi vào màn hình "Kiểm kho & Nhập hàng", người dùng có thể mở rộng khay chi tiết của từng SKU để đối soát danh sách tất cả các lô hàng đang lưu kho kèm theo trạng thái hạn sử dụng (hệ thống sẽ hiển thị cảnh báo đỏ nếu lô hàng đã hết hạn).

### 3.3. Logic Trừ Kho FIFO (First In First Out)
- **Đồng bộ hóa Tự động qua Observer:** Để đảm bảo tính chính xác và loại bỏ Tech Debt, logic trừ kho theo thứ tự thời gian (lô cũ nhất được xuất trước) được cài đặt trực tiếp trong sự kiện `updating` của Model `ProductVariant`.
- **Hoạt động:** Bất cứ khi nào số lượng tồn kho tổng thể của một biến thể bị giảm xuống (dù là do khách mua hàng trực tuyến, đơn POS, hay điều chỉnh giảm thủ công), hệ thống sẽ tự động quét qua các lô hàng (`product_lots`) có `quantity > 0` xếp theo ID tăng dần, thực hiện trừ dần số lượng tồn cho tới khi khấu trừ đủ số lượng hàng đã bán.

### 3.4. Nhập Hàng Theo Lô mới (Inventory Imports)
- Khi thực hiện thay đổi số lượng kho dạng `add` (+ Nhập thêm hàng), hệ thống sẽ hiển thị bổ sung các input cấu hình lô hàng (Nhà cung cấp, Số lô, Hạn sử dụng).
- Một bản ghi `product_lots` mới sẽ được khởi tạo trong Transaction kèm theo lịch sử biến động chi tiết (`InventoryHistory`) lưu vết đầy đủ nguồn gốc nhập.

### 3.5. Phiếu Lấy Hàng (Picking Slip - Phiếu Xuất Kho Nội Bộ)
- **Mục đích:** Khi đơn hàng chuyển sang trạng thái "Đang chuẩn bị hàng", thủ kho có nhiệm vụ soạn đồ. Hệ thống hỗ trợ in phiếu lấy hàng chuyên dụng tại màn hình chi tiết đơn hàng thông qua route `/admin/orders/{id}/picking-slip` (Quyền: `print_picking_slip`).
- **Thiết kế:** Giao diện tối ưu hóa cho in ấn vật lý (CSS `@media print`), cấu trúc dạng bảng checklist bao gồm các trường: Ô tích xác nhận lấy, Mã SKU (font monospace nổi bật), Tên sản phẩm & phân loại chi tiết, Badge số lượng cần lấy khổ to rõ ràng, và các ô ký nhận bàn giao nội bộ.

### 3.6. Cảnh báo tồn kho tự động (Low Stock Alerts)
- **Ngưỡng cấu hình:** Người dùng có thể tùy biến ngưỡng báo động tồn kho tối thiểu thông qua `Cấu hình Cảnh báo Tồn kho` (trường `min_stock_threshold` lưu trong bảng `settings`).
- **Kích hoạt:** Eloquent observer trên `ProductVariant` sẽ kiểm tra trong sự kiện `updated`. Nếu số lượng tồn kho của SKU rớt xuống dưới ngưỡng cấu hình, hệ thống lập tức tự động dispatch `SystemAlertNotification` (Database Notification) gửi tới toàn bộ quản trị viên và thủ kho có quyền xem kho để nhanh chóng lên kế hoạch nhập hàng.

### 3.7. Xuất file kiểm kho (Export)
- Cho phép xuất toàn bộ số lượng & giá trị vốn tồn kho của các sản phẩm đang bán ra file CSV định dạng UTF-8 kèm chuỗi BOM để Excel trên Windows đọc không lỗi font tiếng Việt.

---

## 4. Phân Quyền Kho Bãi Mới
Hệ thống sử dụng các quyền Spatie chi tiết sau để bảo vệ nghiệp vụ:
- `view_inventory`: Quyền xem danh mục tồn kho và tra cứu SKU.
- `update_stock`: Quyền thay đổi số lượng hàng (Nhập/Xuất/Kiểm kê).
- `export_inventory`: Quyền xuất Excel/CSV báo cáo tồn kho.
- `print_picking_slip`: Quyền in phiếu xuất kho nội bộ soạn hàng.
- `manage_suppliers`: Quyền CRUD thông tin nhà cung cấp hàng hóa.
