# Quản lý Sản phẩm Admin (Admin Products)

## 1. Tổng quan
- **Mục đích:** Cung cấp giao diện và logic xử lý để Admin quản trị danh mục hàng hóa, bao gồm thông tin cơ bản của sản phẩm, hình ảnh (thumbnail & gallery), và quản lý các biến thể (variants) kèm theo thuộc tính tương ứng (màu sắc, kích cỡ...).
- **Đối tượng sử dụng:** Quản trị viên (Admin).

## 2. Các file chính liên quan
- **Controller:** `app/Http/Controllers/Admin/ProductController.php`
- **Models:** 
  - `app/Models/Product.php`
  - `app/Models/ProductVariant.php`
  - `app/Models/ProductImage.php`
  - Các model bổ trợ: `Category`, `Brand`, `Attribute`, `AttributeValue`
- **Views (Vue/Inertia):** 
  - `resources/js/Pages/Admin/Products/Index.vue` (Danh sách)
  - `resources/js/Pages/Admin/Products/Form.vue` (Tạo mới & Cập nhật)
  - `resources/js/Pages/Admin/Products/Show.vue` (Xem chi tiết)
- **API/Routes:** Các route nằm trong `routes/web.php` (group admin, route resource `products`).

## 3. Luồng hoạt động (Business Logic)

**3.1. Danh sách Sản phẩm (Index)**
- Chấp nhận các bộ lọc: `search` (tìm theo `name`, `sku`), `category_id`, `brand_id`, `is_active`.
- Cho phép sắp xếp (`sort`, `direction`) và phân trang mặc định 15 item/trang.
- Dữ liệu trả về qua Inertia kèm danh sách Category và Brand để render bộ lọc.

**3.2. Tạo mới Sản phẩm (Store)**
- **Validate:** Tên, category, variant dạng chuỗi JSON, thumbnail.
- **Transaction (DB):** Toàn bộ tiến trình nằm trong 1 Database Transaction để đảm bảo tính toàn vẹn.
  1. Upload ảnh `thumbnail`.
  2. Tạo mới `Product` base.
  3. Lặp chuỗi JSON `variants` -> Tạo các record `ProductVariant` -> Gọi hàm `syncVariantAttributes` để đồng bộ giá trị thuộc tính. Nếu giá trị thuộc tính chưa có (chuỗi string truyền lên), tự động `firstOrCreate` thuộc tính đó.
  4. Lặp file `gallery` -> Upload ảnh -> Lưu vào `ProductImage`.

**3.3. Cập nhật Sản phẩm (Update)**
- **Transaction (DB):**
  1. Cập nhật thông tin `Product` base.
  2. Upload và ghi đè url `thumbnail` nếu có ảnh mới.
  3. Xoá các ảnh gallery có ID nằm trong mảng `deleted_images` (xoá file vật lý rồi xoá record DB). Upload thêm ảnh `gallery` mới nếu có.
  4. **Upsert Variants:** Lặp chuỗi JSON `variants`.
     - Nếu variant có `id`: Tiến hành update record hiện tại.
     - Nếu variant không có `id`: Tạo variant mới.
     - Đồng bộ lại attributes.
     - Lưu lại các ID variant hợp lệ.
  5. **Dọn rác:** Xóa toàn bộ các variants của product này mà KHÔNG NẰM TRONG danh sách ID hợp lệ (xóa mồ côi).

**3.4. Xoá Sản phẩm (Destroy)**
- Gọi hàm `$product->delete()`. Xóa cứng hoặc xóa mềm tùy cấu hình Model.

## 4. Các điểm cần lưu ý (Tech Debt / Improvements)

- **Vi phạm rule "Thin Controller" & "Service Pattern":** Controller `ProductController` hiện tại quá bự (hơn 300 dòng), chứa quá nhiều logic upload ảnh, xử lý mảng variants, xoá file vật lý. Nên tách logic lưu trữ này ra một service class (ví dụ: `App\Services\ProductService`). Điều này cũng giúp tuân thủ chính xác rule kiến trúc được ghi ở `AGENT_ENTRYPOINT.md`.
- **Hiệu năng (N+1 Query) lúc Sync Attributes:** Hàm `syncVariantAttributes` thực hiện query `delete()` và query `firstOrCreate` bên trong vòng lặp for của từng variant. Nếu lưu 1 sản phẩm có 50 biến thể, số lượng câu query tới DB sẽ rất lớn. Có thể tối ưu lại bằng cách load sẵn các attribute values vào bộ nhớ và insert bulk.
- **Vấn đề xoá file ảnh:** Khi cập nhật xoá ảnh từ gallery (`deleted_images`), đường dẫn được cắt chuỗi bằng `str_replace('/storage/', '', $img->image_url)`. Việc này tiềm ẩn lỗi nếu ảnh được lưu qua CDN hoặc dịch vụ bên ngoài (S3, R2) sau này.
- **Bảo mật:** Hiện `variants` và `specifications` truyền lên dưới dạng chuỗi JSON và được `json_decode()` mà không có validation cấu trúc sâu bên trong, dễ sinh bug nếu font-end gửi sai định dạng (vd. thiếu key `sku` hay `price`). Cần cân nhắc viết Custom Rule Validation cho mảng variants này.
