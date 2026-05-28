# Nội dung & Bài viết (Blog & Posts)

## 1. Tổng quan
- **Mục đích:** Quản lý hệ thống Blog, tin tức, bài viết chuẩn SEO của cửa hàng. Có tích hợp trạng thái bài viết do AI tạo tự động.
- **Đối tượng sử dụng:** Nhân viên Content, Marketing, Quản trị viên.

## 2. Các file chính liên quan
- **Controllers:** `app/Http/Controllers/Admin/PostController.php`
- **Models:** `Post`
- **Views (Vue/Inertia):** Thư mục `resources/js/Pages/Admin/Posts`.

## 3. Luồng hoạt động (Business Logic)

- **Danh sách bài viết:** Hỗ trợ tính năng Search cơ bản theo `title`. Sắp xếp bài mới nhất lên đầu (`created_at desc`) và phân trang 10 bài.
- **Trạng thái bài viết:** Có 3 trạng thái:
  - `draft`: Bản nháp.
  - `published`: Đã xuất bản.
  - `ai_generated`: Được tạo bởi AI (tính năng hỗ trợ Content tự động).
- **Tạo & Cập nhật bài viết:**
  - Tự động sinh `slug` từ `title` bằng `Str::slug($request->title) . '-' . time()` để tránh trùng lặp tuyệt đối. Khi cập nhật bài, nếu title thay đổi thì tự động gen lại slug mới.
  - Lưu ảnh Thumbnail vào thư mục `storage/posts/thumbnails`. Xóa tự động ảnh cũ khi cập nhật hoặc khi xóa bài viết.
  - Quản lý các thẻ SEO Meta: `meta_title`, `meta_description`.
  - Quản lý lịch đăng: Nếu trường `published_at` không được truyền vào, hệ thống tự động gán bằng `now()`.

## 4. Các điểm cần lưu ý (Tech Debt / Improvements)
- **Bảo mật Thumbnail (Xóa ảnh rác):** Giống như Banner, việc xóa file bằng cách xử lý chuỗi cứng `/storage/` sẽ không hoạt động nếu config filesystem đổi sang S3. Ngoài ra, việc dùng `Storage::url()` ở hàm `store` nhưng lại `Storage::disk('public')->delete()` ở hàm `destroy` đang bị mâu thuẫn phụ thuộc (URL vs Disk path).
- **Quản lý Slug chưa thân thiện SEO:** Việc gắn thêm `-` và `time()` (VD: `bai-viet-hay-16781293.html`) vào cuối slug mọi lúc giúp tránh trùng lặp rất tốt, nhưng lại làm URL dài và xấu đi về mặt SEO. Nên dùng hàm kiểm tra trùng lặp trong DB (VD: `where('slug', $slug)->exists()`), nếu trùng mới thêm hậu tố dạng `-1`, `-2`.
- **Tích hợp trình soạn thảo (Rich Text):** Content hiện tại đang lưu chuỗi String/HTML thuần. Cần đảm bảo rằng Frontend render HTML này an toàn (chống XSS) và không giới hạn độ dài kiểu dữ liệu trong CSDL (`LONGTEXT` thay vì `TEXT`).
