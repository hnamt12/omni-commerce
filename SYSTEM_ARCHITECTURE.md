# SYSTEM ARCHITECTURE & DATA FLOW

Tài liệu này giải thích cấu trúc Database và luồng chạy cốt lõi của OmniCommerce, mục tiêu giúp các developer mới có thể nhanh chóng làm quen và hiểu cách code hoạt động thực tế.

## 1. Kiến trúc E-commerce cốt lõi: Hybrid EAV & JSON
Truyền thống mô hình EAV (Entity-Attribute-Value) cho thuộc tính sản phẩm gồm rất nhiều bảng (product_attributes, values,...), gây ra việc JOIN rất nặng khi truy xuất sản phẩm.
OmniCommerce sử dụng kiến trúc **Hybrid EAV kết hợp JSON gốc của MySQL/PostgreSQL**:
- Thư mục models cốt lõi: `app/Models/Product.php`, `ProductVariant.php`.
- Bảng `products` lưu trữ cốt lõi: category_id, brand_id, name, base_price. Mọi spec dùng để trình bày sản phẩm (Ví dụ: CPU, RAm, Switch...) được lưu trữ ở dạng object JSON vào cột `specifications`. Nó dùng Type Casting của Laravel (`protected function casts(): array`) để chuyển mảng PHP sang chuẩn JSON khi gọi method `$product->specifications`.
- Biến thể sản phẩm (Variants) (bảng `product_variants`): Lưu ID sản phẩm, giá bán của biến thể, tồn kho và một cột JSON `options` dùng để lưu tuỳ chỉnh (Màu sắc, kích cỡ, chất liệu). Bảng `ProductVariant` chính là nguồn tra cứu để giỏ hàng và thanh toán hoạt động, vì khi người dùng mua, họ mua VARIANT thay vì mua chung chung toàn bộ ROOT PRODUCT.

## 2. Multi-Auth và Identity Separation
Tại sao lại tách `users` (Nhân viên nội bộ) và `customers` (Khách lạ mua hàng) thay vì gộp chung và check roles?
- Dữ liệu hoàn toàn khác biệt: `users` cần check quyền hạn RBAC phức tạp bằng package (Spatie Permission), trong khi `customers` lại cần các fields cho việc marketing, tích điểm, liên kết Social Logins, v...v
- `config/auth.php` phân tách config guard rõ ràng: `customer` dùng cho frontend app mua sắm. Khách mua sắm đăng nhập được lưu session tại namespace customer mà không phải lo rủi ro leo quyền nội bộ của nhân viên. Các middleware check rất an toàn.
- Bảng `users` đã được gỡ bỏ phân quyền cứng nhắc, hoàn toàn sử dụng `Spatie Permission` thông qua trait `HasRoles`. `RolePermissionSeeder` đã seed setup base Role: Super Admin, Sales, Accountant.

## 3. Order Engine & Cart Data Flow
### Luồng chạy của Giỏ hàng (Cart)
Khi user mua, data dồn vào bảng `carts`. Bảng này lưu trực tiếp các fields `customer_id`, `product_id` và `variant_id` (nếu mua có options biến thể). Cột đặc biệt `is_checked` cho phép client UI check state các item *thực sự* muốn thanh toán thay cho việc clear toàn bộ Cart mỗi lần huỷ đơn.

### Hệ Thống Order và Lưu Snapshot Giá Bằng JSON
Các Order lưu lại ở 2 bảng `orders` (tổng hợp billing, trạng thái, voucher) và chi tiết ở `order_items`. Đáng chú ý ở kiến trúc này:
- **Snapshot variant_options**: Vì schema và option sản phẩm có thể đổi qua thời gian, khi user đã hoàn tất Order thanh toán thì item đó không được phép phụ thuộc relation sang `product_variants` nữa (nếu bị edit thì history mất tính minh bạch). Để giải quyết: Cột `variant_options` JSON trên `order_items` sẽ "chụp" (Snapshot) mảng options lúc người dùng ấn nút thanh toán. Các cột tên sp, mã SKU, giá (`price`, `total_price`) cũng đều được chụp lưu bằng raw data tương tự.
- **Voucher Validation**: Tác động từ `Voucher` model được map thông qua `voucher_id` nullable ở bảng orders. Do đã tách scope (Order, Shipping) và type (Percent, Fixed).Lưu quá trình validation voucher được áp dụng cho cột `discount_amount` tổng lúc compile order.

## 5. Multi-Auth Frontend Architecture (Inertia.js & Vue 3)
OmniCommerce sử dụng Inertia.js để kết nối Backend Laravel với Frontend Vue 3 mà không cần xây dựng API RESTful phức tạp:
- **Tách biệt Logic Login**: `Admin/AuthController` và `Client/AuthController` xử lý login/logout cho 2 guard riêng biệt (`web` và `customer`).
- **Guard-based Middleware**: 
    - Các route Admin (`/admin/*`) được bảo vệ bởi middleware `auth:web`.
    - Các route Customer được bảo vệ bởi middleware `auth:customer`.
- **Custom Redirect Logic**: 
    - Trong Laravel 11 (`bootstrap/app.php`), logic `redirectGuestsTo` được tùy chỉnh dựa trên tiền tố URL.
    - Nếu request là `/admin/*`, user chưa log in sẽ bị redirect về `admin.login`.
    - Các request khác sẽ bị redirect về `login` (trang đăng nhập của khách hàng).
- **Cấu trúc Pages**: Các file Vue được tổ chức trong `resources/js/Pages/Admin` và `resources/js/Pages/Client`.
- **Shared Middleware**: `HandleInertiaRequests` middleware tự động chia sẻ dữ liệu chung (auth user, flash messages) từ server xuống client Vue components.

## 4. Code Quality & Enterprise Standards
OmniCommerce áp dụng các chuẩn code khắt khe thông qua pipeline CI/CD ở mỗi lần push code (GitHub Actions `.github/workflows/run-tests.yml`):
- **Laravel Pint**: Cấu hình tại `pint.json` với preset chuẩn của team Laravel, đảm bảo format source code đồng nhất.
- **Larastan**: Chạy Static Analysis (PHPStan) cấp độ 5 nằm tại `phpstan.neon`, giúp phát hiện các lỗi type hint, logic flow và missing properties mà không cần chạy code. Góp phần phòng tránh rủi ro runtime crash.
