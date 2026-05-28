# Sản phẩm & Trang chủ (Client - Products & Home)

## 1. Tổng quan
- **Mục đích:** Xử lý hiển thị trang chủ, danh sách sản phẩm (Shop) với các tính năng lọc/sắp xếp nâng cao, và trang chi tiết sản phẩm. Cung cấp API nội bộ cho thanh tìm kiếm và sản phẩm vừa xem.
- **Đối tượng sử dụng:** Tất cả người dùng (Guest & Customer).

## 2. Các file chính liên quan
- **Controllers:** 
  - `app/Http/Controllers/Client/HomeController.php` (Trang chủ, Mega-menu, Gợi ý tìm kiếm, Vừa xem)
  - `app/Http/Controllers/Client/ProductController.php` (Trang Shop, Chi tiết sản phẩm, Tăng lượt xem)
- **Models:** `Product`, `ProductVariant`, `Category`, `Brand`, `Banner`, `FlashSale`
- **Views (Vue/Inertia):** 
  - `resources/js/Pages/Client/Home`
  - `resources/js/Pages/Client/Shop/Index`
  - `resources/js/Pages/Client/Products/Show`

## 3. Luồng hoạt động (Business Logic)

### 3.1. Trang chủ (HomeController)
- **Mega-menu (Category tree):** Lấy danh mục gốc và danh mục con. Map qua từng danh mục để lấy top 3 sản phẩm nổi bật và top 10 thương hiệu.
- **Dữ liệu động:** Tải Banner, FlashSale đang kích hoạt, Sản phẩm mới (10 cái mới nhất), Sản phẩm nổi bật (Trending - 10 cái xem nhiều nhất).
- **Sản phẩm vừa xem (getRecentlyViewed):** Nhận mảng IDs từ LocalStorage ở phía Frontend, query và sắp xếp lại chính xác theo đúng thứ tự mảng IDs truyền vào.
- **Gợi ý tìm kiếm (searchSuggestions):** Dùng cho thanh search bar, tìm theo `name` hoặc `sku` bằng toán tử `LIKE`. Trả về top 5 kết quả gợi ý.

### 3.2. Cửa hàng & Chi tiết (ProductController)
- **Danh sách (index):** 
  - Query sản phẩm kèm biến thể (variants).
  - Áp dụng các bộ lọc mảng: `categories`, `brands`, khoảng giá `min_price`, `max_price`.
  - Sắp xếp (sort): `latest`, `popular`, `price_asc`, `price_desc`.
  - Tải sidebar categories và brands kèm theo biến đếm `withCount('products')`.
- **Chi tiết (show):** 
  - Tìm sản phẩm theo `slug`. Lấy luôn các Review (đánh giá).
  - Thu thập và nhóm các thuộc tính của biến thể (Ví dụ nhóm tất cả Màu sắc thành Đỏ, Xanh) để Inertia dễ render thành các nút chọn (buttons).
  - Hiển thị 4 sản phẩm liên quan cùng danh mục.
- **Tăng lượt xem (incrementViews):** API endpoint nhỏ để trigger đếm view khi khách lướt xem.

## 4. Các điểm cần lưu ý (Tech Debt / Improvements)
- **Truy vấn N+1 ở Mega-menu:** Tại `HomeController@index`, logic lấy danh mục đang dùng `.map()` để lặp qua danh mục gốc và chạy 2 câu lệnh SQL riêng biệt cho mỗi vòng lặp (tìm top products và top brands). Nếu có 10 danh mục, sẽ chạy 20 câu query. Cần sử dụng các quan hệ (Relationships) phức tạp hơn hoặc **Cache** toàn bộ Mega-menu lại bằng Redis (vì menu ít khi thay đổi).
- **Hiệu suất tìm kiếm:** Hàm `searchSuggestions` dùng `LIKE "%keyword%"` trên cả tên và SKU. Khi lượng dữ liệu lớn sẽ dẫn đến Full Table Scan, rất chậm. Nên áp dụng Full-Text Search (MySQL) hoặc dùng Laravel Scout (Algolia/Meilisearch).
- **Lọc khoảng giá:** Tại `ProductController`, việc dùng `whereHas('variants')` để lọc giá có thể gây chậm ở CSDL lớn. Nên có một trường `min_price` cache sẵn ngoài bảng `products` để lọc nhanh hơn.
