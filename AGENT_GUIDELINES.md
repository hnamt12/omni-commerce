# QUY TẮC THỰC THI CODE CHO AI AGENT (STRICT MODE)

Bất cứ khi nào Agent thực hiện viết code cho Controllers hoặc Vue Components, BẮT BUỘC tuân thủ các quy tắc sau:

1. **KHÔNG GIẤU LỖI VÀO LOG:** Mọi khối `try...catch` trong Controller BẮT BUỘC phải return lỗi về giao diện Frontend. 
   - Cú pháp chuẩn: `return back()->withErrors(['error' => 'Chi tiết lỗi: ' . $e->getMessage()]);`
2. **HIỂN THỊ LỖI RÕ RÀNG TRÊN UI:** Tất cả các Form Vue (`.vue`) BẮT BUỘC phải có khối "Global Error Banner" (Radar báo lỗi) màu đỏ ở ngay đầu Form để hiển thị cả lỗi Validation (`form.errors`) VÀ lỗi hệ thống (`$page.props.errors.error`).
3. **LOGOUT BẰNG POST:** Mọi nút/link Đăng xuất phải sử dụng thẻ `<Link>` của Inertia với thuộc tính `method="post" as="button"` để tránh lỗi 419 CSRF Token.
4. **CLEAN CODE:** Sử dụng `use` ở đầu file PHP, tuyệt đối không dùng đường dẫn class tuyệt đối (FQCN) trong thân hàm.
5. **TỐI ƯU HÓA TOKEN (SIÊU QUAN TRỌNG):** 
   - Tuyệt đối **KHÔNG quét toàn bộ dự án** hoặc đọc tràn lan codebase khi được giao nhiệm vụ cải tiến, refactor hoặc tìm hiểu DB.
   - BẮT BUỘC đọc và tuân thủ [TECH_DEBT_MASTER.md](file:///c:/laragon/www/OmniCommerce/docs/TECH_DEBT_MASTER.md) để biết danh sách các file cần sửa.
   - BẮT BUỘC đọc và tuân thủ [DATABASE_SCHEMA.md](file:///c:/laragon/www/OmniCommerce/docs/DATABASE_SCHEMA.md) khi cần viết query/migration để tra cứu tên cột và bảng nhanh nhất.
   - Chỉ mở những file được liệt kê rõ ràng bằng cách chỉ định cụ thể phạm vi dòng (line range).
