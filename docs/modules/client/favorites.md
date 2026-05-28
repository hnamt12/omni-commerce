# Sản phẩm yêu thích (Client - Product Favorites / Wishlist)

## 1. Tổng quan
- **Mục đích:** Hỗ trợ khách hàng lưu trữ sản phẩm yêu thích (Wishlist). Khi hover vào các thẻ sản phẩm ở bất kỳ trang nào (Trang chủ, Cửa hàng, Sản phẩm liên quan), người dùng có thể nhấp chọn biểu tượng Trái tim để thêm/bớt khỏi danh sách. Tính năng tương tự được hiển thị nổi bật trên trang chi tiết sản phẩm.
- **Đối tượng sử dụng:** Chỉ dành cho Khách hàng đã đăng nhập (`auth:customer`). Nếu chưa đăng nhập, hệ thống sẽ cảnh báo qua Toast yêu cầu đăng nhập.

## 2. Các file chính liên quan
- **Controllers:**
  - `app/Http/Controllers/Client/FavoriteController.php` (Định nghĩa logic thêm/bớt yêu thích qua phương thức `toggle`)
  - `app/Http/Controllers/Client/ProfileController.php` (Nạp danh sách sản phẩm yêu thích kèm biến thể & thương hiệu để truyền vào trang cá nhân)
- **Models:**
  - `App\Models\Favorite` (Model đại diện liên kết Customer và Product)
  - `App\Models\Customer` (Thiết lập các quan hệ `favorites()` và `favoriteProducts()`)
  - `App\Models\Product` (Thiết lập quan hệ `favoritedBy()`)
- **Middleware:** `app/Http/Middleware/HandleInertiaRequests.php` (Chia sẻ mảng ID sản phẩm đã yêu thích toàn cục `favoriteProductIds`)
- **Views (Vue/Inertia):**
  - `resources/js/Components/Client/ProductCard.vue` (Nút trái tim tuyệt đẹp tuyệt đối góc trái, tự động hiển thị khi hover trên desktop hoặc hiển thị trực tiếp trên mobile)
  - `resources/js/Pages/Client/Products/Show.vue` (Nút trái tim lớn sang trọng cạnh các nút thêm giỏ hàng / mua ngay)
  - `resources/js/Pages/Client/Profile/Index.vue` (Tab "Sản phẩm yêu thích" riêng biệt trong trang cá nhân giúp xem nhanh toàn bộ sản phẩm đã thích)
  - `resources/js/Layouts/Client/Header.vue` (Biểu tượng Trái tim yêu thích kèm badge số lượng nhấp nháy động ngay trên Topbar và liên kết nhanh trong menu Dropdown tài khoản)

## 3. Luồng hoạt động (Business Logic)

### 3.1. Phía CSDL & Quan hệ Model
- Bảng `favorites` hoạt động như một bảng trung gian liên kết `customer_id` và `product_id`.
- Model `Customer` định nghĩa `favorites()` qua quan hệ `hasMany(Favorite::class)` và `favoriteProducts()` qua quan hệ `belongsToMany(Product::class, 'favorites')`.
- Model `Product` định nghĩa `favoritedBy()` qua quan hệ `belongsToMany(Customer::class, 'favorites')`.

### 3.2. Quản lý trạng thái thông qua Inertia Shared State
- Để tránh việc cập nhật giao diện bị lệch pha hoặc giật lag khi người dùng click yêu thích ở một trang rồi chuyển sang trang khác, danh sách sản phẩm yêu thích của khách hàng hiện tại được chia sẻ toàn cục ở `HandleInertiaRequests.php` dưới khóa `favoriteProductIds`.
- Mảng này chỉ chứa danh sách các `product_id` nguyên bản, giúp việc kiểm tra `@includes` ở Frontend đạt hiệu năng cực cao.
- Khi người dùng nhấp yêu thích, một yêu cầu POST được gửi tới `/favorites/toggle/{productId}`. Phía Controller sẽ thực hiện logic toggle:
  - Nếu đã tồn tại dòng liên kết -> Xóa.
  - Nếu chưa tồn tại -> Tạo mới.
  - Trả về `back()` kèm thông báo Toast. Inertia sẽ tự động cập nhật lại `favoriteProductIds` trong Shared State, làm kích hoạt cập nhật giao diện của tất cả các nút trái tim trên màn hình một cách đồng bộ tức thì.

### 3.3. Tích hợp Dark/Light Mode & Giao diện Micro-animations
- Cả `ProductCard.vue` and `Show.vue` đều tích hợp hoàn chỉnh hệ màu Light/Dark cao cấp:
  - Chế độ Sáng: Nút có viền xám nhạt, nền trắng đục mờ/thủy tinh, khi được yêu thích sẽ chuyển sang nền hồng nhạt, viền hồng và trái tim đỏ rực.
  - Chế độ Tối: Nút có nền `slate-900/80` (hoặc `slate-950`), viền `slate-800`, khi được yêu thích sẽ chuyển sang nền đỏ mờ `red-950/30` và viền đỏ `red-900/50`.
- Hiệu ứng chuyển động (Micro-animations):
  - Biểu tượng trái tim tự động tăng kích thước (`scale-110` / `scale-105`) và đổi màu fill nhẹ nhàng qua transitions `duration-300` khi click hoặc hover.
  - Nút trái tim ở thẻ sản phẩm (`ProductCard.vue`) được ẩn thông minh ở màn hình lớn (`opacity-0 md:opacity-0 group-hover:opacity-100`) để tránh rối mắt, nhưng vẫn xuất hiện ngay lập tức trên các thiết bị di động có màn hình cảm ứng để giữ nguyên tính tương tác tốt nhất.

## 4. Các điểm cần lưu ý (Tech Debt / Improvements)
- **Tải trước danh sách yêu thích:** Hiện tại, `HandleInertiaRequests` query cơ sở dữ liệu ở mọi request để lấy danh sách yêu thích. Đây là truy vấn có index đơn giản nên tốc độ rất nhanh. Tuy nhiên, nếu số lượng người dùng đồng thời cực kỳ lớn, có thể lưu trữ mảng này vào Redis Cache có vòng đời ngắn cho đến khi có sự thay đổi (Add/Remove) để giảm tải cho CSDL MySQL.
