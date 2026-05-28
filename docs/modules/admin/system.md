# Hệ thống Cấu hình & Nhật ký Hoạt động (System Settings & Audit Trail)

## 1. Tổng quan
- **Mục đích:** Quản lý các cấu hình toàn cục của hệ thống (Settings), theo dõi lịch sử thao tác của các quản trị viên & khách hàng (Audit Trail - Action Logs) và quản lý thông báo (Notifications).
- **Đối tượng sử dụng:** Quản trị viên cấp cao (Super Admin) và Kiểm toán viên hệ thống.

## 2. Các file chính liên quan
- **Controllers:** 
  - `app/Http/Controllers/Admin/SettingController.php` (Quản lý cấu hình chung và Tùy chọn cửa hàng)
  - `app/Http/Controllers/Admin/ProfileController.php` [NEW] (Quản lý hồ sơ cá nhân và mật khẩu Admin/Staff)
  - `app/Http/Controllers/Admin/ActionLogController.php` (Đã tối ưu hóa bộ lọc nâng cao và xuất báo cáo CSV)
  - `app/Http/Controllers/Admin/NotificationController.php`
  - `app/Http/Controllers/Admin/AuthController.php` (Tích hợp ghi log Đăng nhập/Đăng xuất của Quản trị viên)
  - `app/Http/Controllers/Admin/StaffController.php` (Tích hợp ghi log thay đổi Quyền hạn chi tiết của nhân viên)
- **Models:** `Setting`, `ActionLog`, `User`, `Customer`, `Voucher`, `PaymentMethod`, `ProductVariant` (Các model đều được giám sát tự động qua trait `Auditable`).
- **Commands & Scheduler:**
  - `app/Console/Commands/ClearOldActionLogs.php` (Artisan Command dọn dẹp log > 90 ngày)
  - `routes/console.php` (Cấu hình Cron Job chạy định kỳ hàng ngày)
- **Views (Vue/Inertia):** 
  - `Admin/Settings` (Quản lý tùy chọn cửa hàng, cấu hình công ty, hóa đơn serial)
  - `Admin/Profile` [NEW] (Quản lý hồ sơ cá nhân admin, tải lên avatar và thay đổi mật khẩu bảo mật)
  - `Admin/ActionLogs` (Nâng cấp giao diện lọc nâng cao & Xuất Excel/CSV kiểm toán)
  - `Admin/Notifications`

---

## 3. Luồng hoạt động & Tính năng nâng cấp (Business Logic)

### 3.1. Cấu hình Hệ thống (Settings)
- Lưu trữ dưới dạng Key-Value (vd: `contact_phone`, `contact_email`, `map_embed_code`).
- Cung cấp "Safe Fallback" (Khởi tạo giá trị mặc định trống) ngay tại màn hình `index` bằng `firstOrCreate` để chắc chắn View Vue không bị lỗi `undefined`.
- Cập nhật thông qua `updateOrCreate` cho từng dòng cấu hình.

### 3.2. Giám sát Thay đổi Dữ liệu tự động (Auditable Trait)
- Tự động hook vào các Eloquent events: `created`, `updated`, `deleted` của các Model chính:
  - `ProductVariant` (Ghi lại mọi thay đổi giá bán, số lượng tồn kho)
  - `Customer` (Ghi lại thay đổi thông tin khách hàng, số điện thoại)
  - `Voucher` (Ghi lại mọi điều chỉnh tỷ lệ % giảm giá, hạn mức sử dụng)
  - `PaymentMethod` (Ghi lại việc bật/tắt hoặc sửa cấu hình các cổng thanh toán)
- **Bảo mật dữ liệu nhạy cảm:** Tự động loại bỏ các trường mật khẩu (`password`), mã thông báo (`remember_token`, `api_token`) trước khi lưu vào JSON.
- **Ghi nhận IP & User Agent:** Mọi thao tác đều được đính kèm địa chỉ IP và thông tin trình duyệt thiết bị.

### 3.3. Nhật ký hoạt động nâng cao (Audit Trail)
- **Phân quyền chặt chẽ:** Chỉ Admin/Superadmin hoặc nhân viên có quyền `manage_action_logs` mới được truy cập `/admin/action-logs`. Quyền này được bảo vệ bởi middleware `admin.permission:manage_action_logs`.
- **Bộ lọc đa năng:**
  - Lọc theo **Khoảng ngày** (`date_from` / `date_to`) để khoanh vùng thời điểm xảy ra sự cố.
  - Lọc theo **Nhân viên thực hiện** (`user_id`).
  - Lọc theo **Khách hàng liên quan** (`customer_id`) - tự động liên kết khi khách hàng tự thay đổi thông tin hoặc admin chỉnh sửa dữ liệu của khách hàng.
  - Lọc theo **Hành động** (Thêm mới, Cập nhật, Xóa, Đăng nhập, Đăng xuất, Thay đổi quyền).
- **Xuất báo cáo Kiểm toán (Excel/CSV Export):**
  - Hỗ trợ xuất toàn bộ danh sách log đã lọc ra file CSV/Excel phục vụ mục đích kiểm toán.
  - **Stream Response:** Dùng phương pháp stream kết hợp chunk database (mỗi đợt 500 dòng) giúp hệ thống không bao giờ bị tràn bộ nhớ (Memory Limit) ngay cả khi có hàng triệu bản ghi.
  - **UTF-8 BOM:** File xuất ra chứa định dạng BOM giúp Microsoft Excel mở file tiếng Việt chuẩn không bị lỗi font chữ.

### 3.4. Theo dõi Đăng nhập & Đăng xuất (Login/Logout Auditing)
- Tích hợp hook trực tiếp vào `AuthController` để ghi lại thời gian, địa chỉ IP và User Agent mỗi khi có quản trị viên Đăng nhập thành công hoặc Đăng xuất khỏi hệ thống.

### 3.5. Giám sát Thay đổi Quyền hạn (Permission Auditing)
- Khi Quản trị viên thay đổi nhóm quyền của một Nhân viên (`Staff`), hệ thống sẽ tính toán sự chênh lệch (diff) giữa các quyền cũ và quyền mới, sau đó lưu vết rõ ràng dạng:
  - `old_values`: `{"permissions": ["view_orders", "view_inventory"]}`
  - `new_values`: `{"permissions": ["view_orders", "view_inventory", "manage_products"]}`

### 3.6. Dọn dẹp logs tự động (Automated Log Retention)
- Artisan Command `action-logs:clear` thực hiện truy vấn tối ưu xóa toàn bộ nhật ký hệ thống cũ hơn **90 ngày**.
- Được cấu hình định kỳ chạy mỗi ngày qua Cron Scheduler ở `routes/console.php`:
  ```php
  Schedule::command('action-logs:clear')->daily();
  ```

### 3.7. Quản lý Hồ sơ cá nhân Quản trị (Admin Profile) [NEW]
- **Tích hợp liên kết Dropdown Header:** Menu cá nhân ở Header góc phải trong trang Admin (`Layouts/Admin/Header.vue`) hiện tại đã liên kết chính xác bằng Inertia `<Link>`:
  - "Hồ sơ cá nhân" → Route `admin.profile.index`
  - "Tùy chọn cửa hàng" → Route `admin.settings.index`
- **Cập nhật thông tin tài khoản:** Cho phép thay đổi `name`, `email` trực tiếp (bảo vệ ràng buộc `unique` email của chính user đó qua khóa ngoại loại trừ).
- **Tải lên Avatar (Ảnh đại diện):** Cho phép tải lên ảnh mới, hệ thống tự động kiểm tra định dạng hình ảnh và giới hạn `max:2048` (2MB). Khi tải ảnh mới lên thành công, ảnh đại diện cũ trong ổ đĩa Storage (Disk `public`) sẽ được tự động xóa bỏ để tối ưu dung lượng hệ thống.
  - Xác thực mật khẩu cũ bằng rule `current_password:web` để đảm bảo an toàn tuyệt đối.
  * Kiểm tra khớp mật khẩu mới (`confirmed`) và độ dài ký tự an toàn (`min:6`).

### 3.8. Cơ chế Giao diện Sáng/Tối (Dark Mode) [NEW]
- **Kiến trúc Tailwind CSS v4:** Dự án sử dụng Tailwind CSS v4. Để cho phép chuyển đổi giao diện dựa trên lớp `.dark` thay vì phụ thuộc hoàn toàn vào cài đặt của hệ điều hành, cấu hình đã được thêm trực tiếp vào [app.css](file:///c:/laragon/www/OmniCommerce/resources/css/app.css):
  ```css
  @variant dark (&:where(.dark, .dark *));
  ```
- **Ngăn chặn nhấp nháy giao diện (Flicker Prevention):** Một thẻ `<script>` inline đã được thêm vào đầu `<head>` của [app.blade.php](file:///c:/laragon/www/OmniCommerce/resources/views/app.blade.php) để tự động đọc cài đặt theme từ `localStorage` hoặc cấu hình hệ thống và gắn lớp `.dark` ngay lập tức trước khi giao diện Vue được tải, loại bỏ hoàn toàn hiện tượng nhấp nháy sáng/tối khi tải trang.
- **Trạng thái đồng bộ (useDarkMode Composable):** Composable `useDarkMode.js` tự động lưu vết lựa chọn của người dùng vào `localStorage.theme` (`dark` / `light`) và đồng bộ thời gian thực trạng thái `.dark` trên toàn trang.
- **Phát triển toàn diện Client & Admin:** Tính năng sáng/tối hiện đã được đồng bộ hóa và phát triển đầy đủ ở cả giao diện Quản trị (`Admin`) và giao diện Khách hàng (`Client`):
  - **Admin Header:** Nút chuyển đổi với micro-animations đặt tại vị trí trung tâm thanh điều hướng bên phải.
  - **Client Header & Layout:** Tích hợp nút chuyển đổi giao diện sáng/tối premium bên cạnh biểu tượng Giỏ hàng. Toàn bộ Layout (`ClientLayout.vue`), thanh tìm kiếm (`SmartSearch.vue`), và thanh Menu điều hướng của Client đều được thiết kế thích ứng hoàn hảo.
- **Danh sách trang Client đã hỗ trợ Dark Mode đầy đủ:**
  | Trang / Component | File | Ghi chú |
  |---|---|---|
  | Trang chủ (Home) | `Pages/Client/Home.vue` | Nền, skeleton, section headings |
  | Cửa hàng (Shop) | `Pages/Client/Shop/Index.vue` | Sidebar filters, pagination, empty state |
  | Thẻ sản phẩm | `Components/Client/ProductCard.vue` | Card, specs, prices, hover states |
  | Chi tiết sản phẩm | `Pages/Client/Products/Show.vue` | Gallery, info panel, variants, promo box, reviews, specs |
  | Giỏ hàng | `Pages/Client/Cart/Index.vue` | Item cards, summary, CTAs |
  | Thanh toán | `Pages/Client/Checkout/Index.vue` | Steps, forms, address modal, payment methods |
  | Thanh toán QR | `Pages/Client/Checkout/PaymentQr.vue` | Bank info, QR container, action buttons |
  | Đặt hàng thành công | `Pages/Client/Checkout/Success.vue` | Confirmation card, order summary |
  | Danh sách đơn hàng | `Pages/Client/Order/Index.vue` | Nav tabs, order cards, pagination |
  | Chi tiết đơn hàng | `Pages/Client/Order/Show.vue` | Timeline, delivery/payment cards, product list |
  | Hồ sơ cá nhân | `Pages/Client/Profile/Index.vue` | Profile form, address management |
  | Đăng nhập | `Pages/Client/Auth/Login.vue` | Form container, inputs |
  | Đăng ký | `Pages/Client/Auth/Register.vue` | Form container, inputs |
  | Quên mật khẩu | `Pages/Client/Auth/ForgotPassword.vue` | Form container |
  | Đặt lại mật khẩu | `Pages/Client/Auth/ResetPassword.vue` | Form container |
  | Tin tức | `Pages/Client/News/Index.vue` | Header, tab switcher |
  | Tin tức - Bài mới | `News/Partials/LatestPostsList.vue` | Post cards, skeleton, pagination |
  | Tin tức - Sidebar | `News/Partials/SidebarWidgets.vue` | Trending widget, categories, newsletter |
  | Liên hệ | `Pages/Client/Contact/Index.vue` | Contact form, info cards |
  | Home - Hero | `Components/Client/Home/HeroSection.vue` | Slider, mega-menu |
  | Home - Flash Sale | `Components/Client/Home/FlashSale.vue` | Sale banner, countdown |
  | Home - Recently Viewed | `Components/Client/Home/RecentlyViewed.vue` | Section wrapper |
  | Home - Featured Brands | `Components/Client/Home/FeaturedBrands.vue` | Brand grid |
  | Footer | `Layouts/Client/Footer.vue` | Sử dụng `bg-gray-900` nên tương thích tự nhiên |

- **Danh sách trang Admin đã hỗ trợ Dark Mode đầy đủ:**
  | Mô-đun / Module | File | Ghi chú |
  |---|---|---|
  | Khuyến mãi (Vouchers) | `Pages/Admin/Vouchers/Index.vue`, `Form.vue` | Danh sách vouchers, bộ lọc tìm kiếm, phân trang và biểu mẫu thêm/sửa |
  | Nhà cung cấp (Suppliers) | `Pages/Admin/Suppliers/Index.vue` | Quản lý nhà cung cấp, Modal thêm/sửa, trạng thái hoạt động |
  | Kho hàng (Inventory) | `Pages/Admin/Inventory/Index.vue`, `Edit.vue` | Danh sách tồn kho, bộ lọc SKU, biểu mẫu điều chỉnh số lượng tồn kho |
  | Flash Sales | `Pages/Admin/FlashSales/Index.vue`, `Form.vue`, `Show.vue` | Chiến dịch Flash Sale, cấu hình thời gian và điều chỉnh giá chi tiết từng variant |
  | Hỗ trợ trực tuyến (Chat) | `Pages/Admin/Chat/Index.vue`, `ConversationList.vue`, `ChatWindow.vue` | Giao diện nhắn tin real-time, danh sách khách hàng và khung chat bong bóng |
  | Yêu cầu hủy đơn (CancelRequests) | `Pages/Admin/CancelRequests/Index.vue` | Danh sách chờ xử lý, tabs trạng thái và thao tác duyệt/từ chối hủy đơn |
  | Cấu hình Banner | `Pages/Admin/BannerLocations/Index.vue`, `Banners/Index.vue`, `Banners/Form.vue` | Quản lý vị trí banner, kéo thả sắp xếp sort order banner, biểu mẫu đính kèm hình ảnh |

- **Quy ước Dark Mode:** Sử dụng hệ thống Tailwind `dark:` variant với các background chính: `dark:bg-slate-950` (page), `dark:bg-slate-900` (cards), `dark:bg-slate-800` (inputs/panels), text: `dark:text-gray-100/200/300/400`, border: `dark:border-slate-700/800`.

---

## 4. Hướng dẫn Triển khai & Kiểm thử (Verification & Deployment)

1. **Chạy Migration bổ sung cột:**
   Chạy lệnh dưới đây để thêm cột `customer_id` làm khóa ngoại liên kết nhật ký với khách hàng:
   ```bash
   php artisan migrate
   ```

2. **Chạy thử Command dọn dẹp Log cũ:**
   ```bash
   php artisan action-logs:clear
   ```

3. **Cấu hình Cron Job trên Server Production:**
   Đảm bảo Cron job của máy chủ chạy lệnh Scheduler của Laravel mỗi phút:
   ```bash
   * * * * * cd /path-to-your-project && php artisan schedule:run >> /dev/null 2>&1
   ```
