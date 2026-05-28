# Tin tức & Blog (Client - News)

## 1. Tổng quan
- **Mục đích:** Hiển thị trang danh sách bài viết (Tin tức, Blog) và nội dung chi tiết. Hỗ trợ lọc bài viết phổ biến, bài nổi bật, bài liên quan.
- **Đối tượng sử dụng:** Tất cả người dùng.

## 2. Các file chính liên quan
- **Controllers:** `app/Http/Controllers/Client/NewsController.php`
- **Models:** `Post`
- **Views (Vue/Inertia):** 
  - `resources/js/Pages/Client/News/Index`
  - `resources/js/Pages/Client/News/Show`

## 3. Luồng hoạt động (Business Logic)

### 3.1. Danh sách Tin tức (index)
- **Lấy bài viết nổi bật (Featured):** Là 1 bài viết đã xuất bản (published) có nhiều lượt xem (`views`) nhất.
- **Danh sách (Latest/Popular):**
  - Tải danh sách bài viết đã xuất bản, hỗ trợ phân trang (9 bài / trang).
  - **Đặc biệt:** Truy vấn danh sách sẽ loại trừ (exclude) bài viết nổi bật (Featured) ở trên để tránh bị trùng lặp trên giao diện.
  - Sắp xếp theo `published_at` (mới nhất) hoặc `views` (phổ biến nhất) dựa trên tham số query `sort`.
- **Thanh bên (Trending Sidebar):** Lấy top 5 bài viết có lượt xem cao nhất (cũng loại trừ bài Featured).
- **Thời gian đọc (reading_time):** Gắn thuộc tính accessor `reading_time` vào collection để hiển thị (ví dụ: "3 phút đọc").

### 3.2. Chi tiết Tin tức (show)
- **Nội dung:** Tìm bài viết theo `slug` với điều kiện `published()`.
- **Tăng lượt xem:** Gọi `increment('views')` mỗi khi load trang chi tiết.
- **Bài liên quan:** Tìm top 4 bài viết có nhiều lượt xem nhất (trừ bài đang xem) để gợi ý. Gắn kèm thuộc tính `reading_time`.

## 4. Các điểm cần lưu ý (Tech Debt / Improvements)
- **Tăng lượt xem trực tiếp vào DB:** Việc gọi `increment('views')` ngay lúc tải trang chi tiết sẽ khóa (Lock) row trên CSDL, gây nghẽn cổ chai nếu có quá nhiều người truy cập cùng 1 bài viết một lúc. 
  - *Giải pháp:* Nên lưu số lượt xem vào Cache/Redis, sau đó dùng Schedule Job để đồng bộ xuống Database định kỳ (vd: mỗi 15 phút), hoặc đẩy vào Queue để xử lý.
- **Khối lượng Truy vấn Trending:** Query lấy trending sidebar và bài liên quan hiện tại query và sort trực tiếp trên toàn bảng `Post`. Ở hệ thống lớn, nên Cache danh sách trending lại mỗi vài giờ để tối ưu tốc độ.
