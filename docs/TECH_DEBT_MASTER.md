# OmniCommerce — Tech Debt Master Checklist

> **Mục đích:** Đây là bản tổng hợp TẤT CẢ các điểm cần cải tiến từ toàn bộ tài liệu module. Khi Agent được yêu cầu tối ưu, refactor, hoặc fix bug — hãy ĐỌC FILE NÀY TRƯỚC để biết chính xác cần làm gì ở đâu, không cần quét lại code.
>
> 📁 Để biết chi tiết vị trí code, đọc file module tương ứng trong `docs/modules/`.

---

## 🔴 CRITICAL — Lỗ hổng Bảo mật & Tính toàn vẹn Dữ liệu

> Những điểm này có thể gây mất tiền, mất dữ liệu hoặc bị tấn công. Ưu tiên xử lý NGAY.

### [CRITICAL-1] Price Manipulation — POS Admin Orders — 🟩 HOÀN THÀNH
- **File liên quan:** `app/Http/Controllers/Admin/OrderController.php` (hàm `store` POS)
- **Vấn đề:** Tính tổng tiền đơn hàng POS dựa hoàn toàn vào `$item['price']` gửi từ Frontend. Đây là **lỗ hổng IDOR/Price Manipulation nghiêm trọng** — nhân viên có thể can thiệp sửa giá.
- **Giải pháp:** Backend tự query lại `ProductVariant::find($item['variant_id'])->final_price` để tính tiền, không tin giá từ request.
- **Trạng thái:** Đã fix.
- **Tham chiếu:** `docs/modules/admin/orders.md` — Mục 4

### [CRITICAL-2] Tồn kho âm — POS Admin Orders — 🟩 HOÀN THÀNH
- **File liên quan:** `app/Http/Controllers/Admin/OrderController.php` (hàm `store` POS)
- **Vấn đề:** Trừ tồn kho bằng `decrement()` không có `lockForUpdate()`. Nếu 2 nhân viên cùng lên đơn cho 1 sản phẩm còn 1 cái, tồn kho sẽ thành -1.
- **Giải pháp:** Áp dụng `lockForUpdate()`, sort các variant IDs để tránh deadlock, kiểm tra stock trước khi update bằng Eloquent `save()`.
- **Trạng thái:** Đã fix.
- **Tham chiếu:** `docs/modules/admin/orders.md` — Mục 4

### [CRITICAL-3] Bảo mật Payment Config — 🟩 HOÀN THÀNH
- **File liên quan:** `app/Models/PaymentMethod.php`, bảng `payment_methods`
- **Vấn đề:** Cột `config` lưu API keys, Secret keys của VNPay/VietQR dưới dạng plaintext JSON. Nếu DB bị dump, toàn bộ thông tin cổng thanh toán bị lộ.
- **Giải pháp:** Đã thêm `$casts = ['config' => 'encrypted:json']` vào Model để tự động mã hóa/giải mã.
- **Trạng thái:** Đã fix.
- **Tham chiếu:** `docs/modules/admin/accounting.md` — Mục 4

### [CRITICAL-4] XSS — Content Bài viết/Sản phẩm — 🟩 HOÀN THÀNH
- **File liên quan:** `resources/js/Pages/Client/Products/Show.vue` (và các file có `v-html` render content rich-text).
- **Vấn đề:** Content HTML từ Editor được render trực tiếp bằng `v-html`. Nếu không có sanitization, người dùng có thể inject script độc hại.
- **Giải pháp:** Đã thêm DOMPurify để sanitize HTML (`sanitizedDescription`) ở Frontend trước khi render.
- **Trạng thái:** Đã fix (yêu cầu chạy `npm install dompurify` trên môi trường triển khai).
- **Tham chiếu:** `docs/modules/admin/posts.md` — Mục 4

---

## 🟠 HIGH — Hiệu năng & Khả năng Mở rộng

> Những điểm này sẽ gây nghẽn cổ chai khi dữ liệu tăng trưởng.

### [HIGH-1] N+1 Query — Mega Menu Trang chủ
- **File liên quan:** `app/Http/Controllers/Client/HomeController.php` (hàm `index`)
- **Vấn đề:** Vòng lặp `map()` qua danh mục gốc chạy 2 câu SQL riêng biệt cho mỗi danh mục. 10 danh mục = 20 queries thừa.
- **Giải pháp:** Cache toàn bộ kết quả Mega Menu bằng Redis (TTL ~60 phút). Invalidate khi Admin thay đổi Category/Brand/Product.
- **Tham chiếu:** `docs/modules/client/products.md` — Mục 4

### [HIGH-2] Out of Memory — Inventory Valuation
- **File liên quan:** `app/Http/Controllers/Admin/AccountingController.php` (hàm `inventoryValuation`)
- **Vấn đề:** Lấy toàn bộ `inventory_histories` trong kỳ vào PHP memory, group/sum bằng Collection. Hàng triệu bản ghi → OOM crash.
- **Giải pháp:** Chuyển hoàn toàn logic `GROUP BY` và `SUM(quantity * price)` xuống tầng SQL.
- **Tham chiếu:** `docs/modules/admin/accounting.md` — Mục 4

### [HIGH-3] Full Table Scan — Tìm kiếm Sản phẩm
- **File liên quan:** `app/Http/Controllers/Client/HomeController.php` (hàm `searchSuggestions`)
- **Vấn đề:** Query `LIKE "%keyword%"` không dùng được Index → Full Table Scan khi sản phẩm nhiều.
- **Giải pháp:** Implement Laravel Scout với Meilisearch hoặc Algolia. Trước mắt thêm FULLTEXT Index trên MySQL.
- **Tham chiếu:** `docs/modules/client/products.md` — Mục 4

### [HIGH-4] Tăng lượt xem Lock DB — Bài viết & Sản phẩm
- **File liên quan:** `app/Http/Controllers/Client/NewsController.php`, `ProductController.php`
- **Vấn đề:** Gọi `increment('views')` trực tiếp vào DB mỗi khi tải trang. Traffic cao → row lock contention.
- **Giải pháp:** Dùng Redis counter, định kỳ đồng bộ về DB qua Queue/Schedule.
- **Tham chiếu:** `docs/modules/client/news.md` — Mục 4

### [HIGH-5] Settings không có Cache
- **File liên quan:** `app/Http/Controllers/Admin/SettingController.php`, `Client/ContactController.php`
- **Vấn đề:** Bảng `settings` bị query mỗi lần tải trang dù dữ liệu gần như tĩnh.
- **Giải pháp:** Cache bằng Redis. Clear cache trong `SettingController@update`.
- **Tham chiếu:** `docs/modules/admin/system.md` — Mục 4

### [HIGH-6] Deadlock — Inventory Bulk Update
- **File liên quan:** `app/Http/Controllers/Admin/InventoryController.php` (hàm `updateBulk`)
- **Vấn đề:** Vòng lặp `foreach` giữ `lockForUpdate` trên nhiều rows. Nếu 2 requests lock cùng rows theo thứ tự ngược → deadlock.
- **Giải pháp:** Sort danh sách variant IDs trước khi lock. Đặt giới hạn số items tối đa mỗi request.
- **Tham chiếu:** `docs/modules/admin/inventory.md` — Mục 4

---

## 🟡 MEDIUM — Kiến trúc & Code Quality

### [MED-1] Fat Controller — ProductController
- **File:** `app/Http/Controllers/Admin/ProductController.php` (300+ dòng)
- **Giải pháp:** Tách ra `app/Services/ProductService.php`.
- **Tham chiếu:** `docs/modules/admin/products.md` — Mục 4

### [MED-2] Hardcode Trạng thái Đơn hàng (Tiếng Việt)
- **File:** `Admin/OrderController.php`, `Client/OrderController.php`
- **Giải pháp:** Tạo `app/Enums/OrderStatus.php`.
- **Tham chiếu:** `docs/modules/admin/orders.md` — Mục 4

### [MED-3] Hardcode Role Names ở nhiều nơi
- **File:** `CategoryController.php`, `BrandController.php`, `CheckoutController.php`
- **Giải pháp:** Tạo `app/Enums/RoleName.php` hoặc `config/roles.php`.
- **Tham chiếu:** `docs/modules/admin/categories-brands-attributes.md` — Mục 4

### [MED-4] N+1 Query — Sync Attributes Variant
- **File:** `app/Http/Controllers/Admin/ProductController.php` (hàm `syncVariantAttributes`)
- **Giải pháp:** Load attribute values vào memory, dùng bulk insert.
- **Tham chiếu:** `docs/modules/admin/products.md` — Mục 4

### [MED-5] Notification Logic trong Controller
- **File:** `Admin/CategoryController.php`, `Admin/BrandController.php`
- **Giải pháp:** Chuyển sang Observer hoặc Event/Listener.
- **Tham chiếu:** `docs/modules/admin/categories-brands-attributes.md` — Mục 4

### [MED-6] Giỏ hàng Guest (chưa có)
- **File:** `app/Http/Controllers/Client/CartController.php`
- **Giải pháp:** Implement Session Cart cho Guest, merge khi đăng nhập.
- **Tham chiếu:** `docs/modules/client/cart.md` — Mục 4

### [MED-7] Tồn kho ảo Flash Sale
- **File:** `app/Http/Controllers/Admin/FlashSaleController.php`
- **Giải pháp:** Thêm cơ chế "Reserved Stock" khi tạo Flash Sale Item.
- **Tham chiếu:** `docs/modules/admin/marketing.md` — Mục 4

### [MED-8] Debug Log còn trong Production Code
- **File:** `app/Http/Controllers/Client/CheckoutController.php` (hàm `store`)
- **Giải pháp:** Xóa toàn bộ block `--- BẮT ĐẦU TEST THÔNG BÁO ĐƠN HÀNG ---`.
- **Tham chiếu:** `docs/modules/client/orders.md` — Mục 4

### [MED-9] Phí vận chuyển Hardcode
- **File:** `app/Http/Controllers/Client/CheckoutController.php` (`$shippingFee = 35_000`)
- **Giải pháp:** Chuyển vào bảng `settings`.
- **Tham chiếu:** `docs/modules/client/orders.md` — Mục 4

### [MED-10] Bảo mật Kế toán — Multiple Separate Queries
- **File:** `app/Http/Controllers/Admin/AccountingController.php`
- **Giải pháp:** Gộp các count/sum thành 1 query `selectRaw` duy nhất.
- **Tham chiếu:** `docs/modules/admin/accounting.md` — Mục 4

---

## 🟢 LOW — Cải tiến UX & Tiện ích

### [LOW-1] Slug Bài viết kém SEO
- **File:** `app/Http/Controllers/Admin/PostController.php`
- **Giải pháp:** Chỉ thêm hậu tố khi slug trùng, dùng `-1`, `-2` thay vì `-{timestamp}`.
- **Tham chiếu:** `docs/modules/admin/posts.md`

### [LOW-2] Xóa ảnh không tương thích Cloud Storage
- **File:** `ProductController.php`, `BannerController.php`, `PostController.php`, `BrandController.php`
- **Giải pháp:** Lưu relative path vào DB, dùng `Storage::disk()->delete($path)` nhất quán.
- **Tham chiếu:** `docs/modules/admin/products.md`, `marketing.md`, `posts.md`

### [LOW-3] Thiếu Quên mật khẩu & Đặt mật khẩu OAuth
- **File:** `app/Http/Controllers/Client/AuthController.php`
- **Giải pháp:** Implement Password Reset flow. Thêm "Đặt mật khẩu" trong Profile.
- **Tham chiếu:** `docs/modules/client/auth.md`

### [LOW-4] Thiếu updateAddress & deleteAddress
- **File:** `app/Http/Controllers/Client/ProfileController.php`
- **Giải pháp:** Thêm 2 method còn thiếu.
- **Tham chiếu:** `docs/modules/client/auth.md`

### [LOW-5] Voucher không check min_order khi Apply
- **File:** `app/Http/Controllers/Client/VoucherController.php`
- **Giải pháp:** Truyền `subtotal` và kiểm tra `min_order_value` khi apply voucher.
- **Tham chiếu:** `docs/modules/client/cart.md`

### [LOW-6] Action Logs tăng trưởng vô hạn — 🟩 HOÀN THÀNH
- **File:** `app/Http/Controllers/Admin/ActionLogController.php`
- **Giải pháp:** Schedule Artisan Command tự xóa log > 6 tháng.
- **Trạng thái:** Đã tạo Command `action-logs:clear` (90 ngày) và cấu hình schedule chạy daily.
- **Tham chiếu:** `docs/modules/admin/system.md`

### [LOW-7] Role cứng nhắc khi tạo Staff
- **File:** `app/Http/Controllers/Admin/StaffController.php`
- **Giải pháp:** Cho phép Admin chọn role khi tạo tài khoản.
- **Tham chiếu:** `docs/modules/admin/staff.md`

### [LOW-8] Giá trong Cart không đồng bộ khi giá thay đổi
- **File:** Bảng `carts`, `app/Http/Controllers/Client/CartController.php`
- **Giải pháp:** Query lại `ProductVariant->price` khi load Cart ra Checkout.
- **Tham chiếu:** `docs/modules/client/cart.md`

### [LOW-9] Thiếu Contact Form
- **File:** `app/Http/Controllers/Client/ContactController.php`
- **Giải pháp:** Thêm form liên hệ với validation và gửi email.
- **Tham chiếu:** `docs/modules/client/contact.md`

### [LOW-10] Hardcode Permissions List trong StaffController
- **File:** `app/Http/Controllers/Admin/StaffController.php`
- **Giải pháp:** Định nghĩa trong `config/permissions.php` hoặc Enum trung tâm.
- **Tham chiếu:** `docs/modules/admin/staff.md`

---

## 💎 BACKLOG — Phân hệ & Tính năng lớn đã phát triển

### [BACKLOG-1] Phân hệ Nhân Sự & Tính Lương (Payroll & HR) — 🟩 HOÀN THÀNH
- **Files/Bảng liên quan:** 
  - Cột mới đã thêm vào `users`: `department`, `position`, `hire_date`, `base_salary`, `commission_rate`.
  - Bảng mới đã tạo: `payroll_records`.
  - Controllers đã tạo: `app/Http/Controllers/Admin/PayrollController.php`.
  - Giao diện Vue 3 đã xây dựng: `Admin/Payroll/Index`, `Admin/Payroll/Create`, `Admin/Payroll/Show`.
  - Template in ấn: `admin.payroll.payslip` (Blade).
- **Trạng thái:** Đã lập trình, triển khai hoàn chỉnh toàn bộ logic backend tính hoa hồng tự động theo doanh số đơn hàng chốt, thưởng KPI, preview tính lương nháp hàng loạt, chi trả lương, xuất phiếu lương in ấn và tích hợp Sidebar điều hướng.

### [BACKLOG-2] Vận Hành, Kho Bãi & Kế Toán — 🟩 HOÀN THÀNH
- **Tính năng nổi bật:**
  - In ấn hóa đơn & QR Code: Hỗ trợ hóa đơn VAT, phiếu lấy hàng (Picking Slip), in nhiệt POS khổ K80, tích hợp thông tin công ty từ Settings.
  - Quản trị Kho chuyên sâu: Module Nhà cung cấp (Suppliers), theo dõi lô hàng (FIFO), tự động gửi thông báo khi tồn kho thấp.
  - Bảo mật & Tracking: Bảo vệ routes bằng middleware permissions, log lại đăng nhập/đăng xuất admin, filter/export Action Logs bằng StreamedResponse, Command tự động dọn rác logs (90 ngày).
- **Trạng thái:** Đã được triển khai hoàn chỉnh và nghiệm thu 100%.

---

## 📊 Tổng kết

| Độ ưu tiên / Phân loại | Số lượng | Hành động |
|---|---|---|
| 🔴 CRITICAL | 4 | Xử lý ngay trong sprint hiện tại (4 đã xong) |
| 🟠 HIGH | 6 | Lên kế hoạch trong 1-2 sprint tới |
| 🟡 MEDIUM | 10 | Backlog có kế hoạch |
| 🟢 LOW | 10 | Nice-to-have / Tech debt dài hạn |
| 💎 BACKLOG (Tính năng lớn) | 2 | **🟩 Đã hoàn thành 100% (Phân hệ Nhân Sự & Kế toán Vận hành)** |
| **Tổng** | **31** | |
