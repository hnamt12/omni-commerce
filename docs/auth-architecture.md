# Kiến Trúc Xác Thực (Auth Architecture) & Trouble Shooting

Tài liệu này tổng hợp toàn bộ logic và các quy tắc thiết yếu đã được đúc kết trong quá trình xử lý luồng Xác thực (Authentication) phức tạp của OmniCommerce. Các quy tắc này **BẮT BUỘC** phải tuân thủ để đảm bảo tính toàn vẹn và tránh lặp lại các lỗi môi trường nghiêm trọng.

---

## 1. Kiến Trúc Session (Giải quyết lỗi `419 Page Expired`)

Hệ thống sử dụng Database để lưu Session thay vì dùng File. Việc này nhằm ngăn chặn triệt để lỗi phân quyền (Permission/File Lock) thường gặp trên môi trường Windows (chẳng hạn như Laragon).

**Quy tắc Cấu hình:**
- Trong file `.env`, luôn phải cấu hình:
  ```env
  SESSION_DRIVER=database
  ```

**Quy tắc Triển khai (Deployment):**
- Bất kỳ khi nào clone dự án mới để deploy hoặc develop, bắt buộc phải khởi tạo bảng session:
  ```bash
  php artisan session:table
  php artisan migrate
  ```

---

## 2. Kiến Trúc Frontend Vite (Giải quyết lỗi `ERR_BLOCKED_BY_CLIENT`)

Các phần mềm mở rộng như AdBlocker hay Brave Shield thường xuyên chặn các file tĩnh (JS/CSS) nếu Vite chạy trên môi trường IPv6 (`[::1]:5173`). Do đó, chúng ta ép buộc Vite phải chạy qua IPv4.

**Quy tắc Cấu hình Vite (`vite.config.js`):**
- Bắt buộc khai báo host là `127.0.0.1` bên trong block `server`:
  ```javascript
  export default defineConfig({
      server: {
          host: '127.0.0.1',
          port: 5173,
      },
      // ...
  });
  ```

**Quy tắc Cấu hình Axios (`bootstrap.js`):**
- Để gửi kèm cookie xác thực (Session & XSRF-TOKEN) trong các request Inertia/Axios, bắt buộc phải bật `withCredentials` (Nghiêm cấm tắt):
  ```javascript
  window.axios.defaults.withCredentials = true;
  ```

---

## 3. Luồng Điều Hướng (Giải quyết lỗi `500` & `404 Session Intended`)

Hệ thống định tuyến của Laravel đôi khi gặp vòng lặp (loop) khi lưu trữ cache của `intended URL`. Để giải quyết và đảm bảo tính thống nhất, OmniCommerce áp dụng cơ chế chuyển hướng tĩnh.

**Quy tắc Điều hướng Controller:**
- Các Controller xử lý đăng nhập (ví dụ: `Admin/AuthController` hoặc `AuthenticatedSessionController`) dùng `redirect()->route('dashboard')` để điều hướng tĩnh, thay cho hàm `intended()`.
  ```php
  public function login(LoginRequest $request)
  {
      $request->authenticate();
      $request->session()->regenerate();
      
      // Định tuyến ép buộc (Tuyệt đối không dùng intended)
      return redirect()->route('dashboard');
  }
  ```

**Quy tắc Khai báo Route (`routes/web.php`):**
- Route dành cho quản trị (Dashboard) chỉ có **DUY NHẤT** một đường dẫn là `/dashboard`.
- **Nghiêm cấm** việc tự ý tạo các route mồi hoặc prefix như `/admin/dashboard`. Middleware bảo vệ phải được gán trực tiếp tại cấp root của route:
  ```php
  Route::get('/dashboard', [\App\Http\Controllers\DashboardController::class, 'index'])
      ->middleware(['auth:web', 'verified'])
      ->name('dashboard');
  ```

---

## 4. Bộ Lệnh Dọn Dẹp Tiêu Chuẩn

Khi hệ thống gặp sự cố kẹt cache Session, lỗi View/Not Found do đổi Route, hoặc Class Not Found sau khi tạo file mới, **bắt buộc** sử dụng chuỗi lệnh Terminal tiêu chuẩn sau để dọn dẹp và tái tạo lại toàn bộ map hệ thống:

```bash
composer dump-autoload
php artisan optimize:clear
php artisan route:clear
```

*Tài liệu này là một phần của quy chuẩn hệ thống. Cấm tự ý sửa đổi khi không hiểu rõ về vòng đời (Lifecycle) của Laravel.*
