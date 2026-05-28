# Tiếp thị & Khuyến mãi (Marketing: Banners, Flash Sales, Vouchers)

## 1. Tổng quan
- **Mục đích:** Quản lý các chiến dịch Marketing, bao gồm giao diện người dùng (Banners), kích cầu mua sắm (Flash Sale) và mã giảm giá (Vouchers).
- **Đối tượng sử dụng:** Nhân viên Marketing, Quản trị viên.

## 2. Các file chính liên quan
- **Controllers:** 
  - `app/Http/Controllers/Admin/BannerController.php`
  - `app/Http/Controllers/Admin/BannerLocationController.php`
  - `app/Http/Controllers/Admin/FlashSaleController.php`
  - `app/Http/Controllers/Admin/VoucherController.php`
- **Models:** `Banner`, `BannerLocation`, `FlashSale`, `FlashSaleItem`, `Voucher`
- **Views (Vue/Inertia):** Các thư mục `Admin/Banners`, `Admin/BannerLocations`, `Admin/FlashSales`, `Admin/Vouchers`.

## 3. Luồng hoạt động (Business Logic)

### 3.1. Quản lý Banner & Vị trí (Banners & Locations)
- **BannerLocations:** Định nghĩa các vị trí xuất hiện của Banner (Ví dụ: `home_slider`, `category_sidebar`). Hỗ trợ cấu hình `is_active` để bật/tắt toàn bộ vị trí.
- **Banners:** 
  - Quản lý hình ảnh (`images`), liên kết (`link_url`). 
  - Cho phép sắp xếp thứ tự (Reorder) bằng cách kéo thả, cập nhật hàng loạt qua AJAX `items.*.sort_order`.
  - Phân loại (Group) dựa trên `BannerLocation` code để hiển thị dễ nhìn.
  - Hình ảnh lưu tại thư mục `storage/banners` và tự động xóa vật lý khi banner bị xóa hoặc cập nhật ảnh mới.

### 3.2. Quản lý Flash Sale
Đây là một module rất phức tạp về mặt logic xung đột thời gian và tồn kho.
- **Tạo chiến dịch:** Quản lý thời gian `start_time`, `end_time` và trạng thái kích hoạt.
- **Thêm sản phẩm hàng loạt (addMultipleProducts):**
  - Chạy trong **Database Transaction** và sử dụng **Khóa dòng (`lockForUpdate`)** lên `ProductVariant`.
  - **Kiểm tra tính hợp lệ:** Bắt buộc `discount_price` (Giá sale) phải **nhỏ hơn** giá bán hiện tại của sản phẩm (price). Nếu `discount_price >= price` thì chặn lại.
  - Kiểm tra tồn kho: `quantity` đưa vào sale không được lớn hơn tổng `stock` hiện có.
  - **Kiểm tra trùng lịch (Overlapping):** Quét toàn bộ hệ thống để đảm bảo Variant này không nằm trong bất kỳ Flash Sale nào khác đang `is_active` mà thời gian hoạt động giao thoa (chồng chéo) với chiến dịch hiện tại. Bằng cách so sánh `start_time < current.end_time` và `end_time > current.start_time`.
- **Hỗ trợ tìm kiếm API:** Cung cấp API `searchProducts` và `getProductVariants` trả về JSON để Modal Frontend dễ dàng tìm kiếm sản phẩm.

### 3.3. Mã giảm giá (Vouchers)
- Quản lý mã ưu đãi. Áp dụng toàn cục hoặc cho phí vận chuyển (`scope: order|shipping`).
- Các loại giảm: Theo % (`percent`) hoặc số tiền cố định (`fixed`). 
- Có khả năng cấu hình giới hạn số tiền giảm tối đa (`max_discount_amount`), giá trị đơn tối thiểu (`min_order_value`), số lượt dùng tối đa (`usage_limit`), và số lần một user được dùng (`limit_per_user`).
- Quy định thời gian áp dụng `start_date` đến `end_date`. Mã code được ép `strtoupper` tự động.

## 4. Các điểm cần lưu ý (Tech Debt / Improvements)
- **Tồn kho ảo của Flash Sale:** Logic FlashSale check `quantity <= variant->stock` là đúng, nhưng nó chưa trích xuất số lượng tồn kho này sang một kho đệm (reserved stock). Điều này có nghĩa là khi FlashSale chưa diễn ra, khách mua bình thường có thể mua hết sạch hàng, khiến khi FlashSale diễn ra thì số lượng cam kết sale sẽ bị "thủng". Nên tạo cơ chế khóa tồn kho cho FlashSale.
- **Tối ưu xóa ảnh Banner:** Việc xóa ảnh dùng `str_replace('/storage/', '', ...)` phụ thuộc cứng vào Local Disk (public). Nếu tương lai chuyển qua Amazon S3 hoặc Cloudflare R2, hàm này sẽ lỗi và tạo rác trên cloud. Nên dùng hàm parse URL lấy basename.
- **Cập nhật hình ảnh hàng loạt của Banner:** Ở hàm `store`, cho phép upload nhiều file `request->file('images')`, nhưng ở `update` lại mặc định lấy file đầu tiên `$request->file('images')[0]`. Điều này dẫn tới sự không nhất quán trong UX, nên chỉnh lại Form để upload 1 file cho 1 banner ở cả 2 nơi.
