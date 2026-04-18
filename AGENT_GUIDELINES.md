# QUY TẮC THỰC THI CODE CHO AI AGENT (STRICT MODE)

Bất cứ khi nào Agent thực hiện viết code cho Controllers hoặc Vue Components, BẮT BUỘC tuân thủ các quy tắc sau:

1. **KHÔNG GIẤU LỖI VÀO LOG:** Mọi khối `try...catch` trong Controller BẮT BUỘC phải return lỗi về giao diện Frontend. 
   - Cú pháp chuẩn: `return back()->withErrors(['error' => 'Chi tiết lỗi: ' . $e->getMessage()]);`
2. **HIỂN THỊ LỖI RÕ RÀNG TRÊN UI:** Tất cả các Form Vue (`.vue`) BẮT BUỘC phải có khối "Global Error Banner" (Radar báo lỗi) màu đỏ ở ngay đầu Form để hiển thị cả lỗi Validation (`form.errors`) VÀ lỗi hệ thống (`$page.props.errors.error`).
3. **LOGOUT BẰNG POST:** Mọi nút/link Đăng xuất phải sử dụng thẻ `<Link>` của Inertia với thuộc tính `method="post" as="button"` để tránh lỗi 419 CSRF Token.
4. **CLEAN CODE:** Sử dụng `use` ở đầu file PHP, tuyệt đối không dùng đường dẫn class tuyệt đối (FQCN) trong thân hàm.
