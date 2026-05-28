# 1. AGENT BEHAVIOR RULES (BẮT BUỘC TUÂN THỦ)
- AUTO-EXECUTION: Mọi yêu cầu viết code BẮT BUỘC phải dùng công cụ tạo/ghi file để áp dụng trực tiếp. KHÔNG in code ra màn hình chat bắt user tự copy.
- COMMAND LINE: Khi tạo Migration/Model Laravel, BẮT BUỘC dùng Terminal chạy lệnh `php artisan make:model TênModel -m` trước, sau đó mới ghi nội dung.
- NO LAZINESS: Viết code hoàn chỉnh, không cắt xén, không để lại comment kiểu "thêm code của bạn ở đây".

# 2. TECH STACK & CODING STANDARDS
- Backend: PHP 8.2+, Laravel 11. Bắt buộc dùng Type Hinting (vd: `: array`, `: BelongsTo`).
- Security: Mọi Model BẮT BUỘC khai báo `$fillable` chống Mass Assignment. Migration BẮT BUỘC dùng `cascadeOnDelete()` cho khóa ngoại.

# 3. SYSTEM ARCHITECTURE (HYBRID EAV + JSON)
- Categories: Adjacency List (`id`, `parent_id`, `name`, `slug`).
- Products: Cột cốt lõi + cột `specifications` kiểu `json` (nullable) để lưu thuộc tính động. Model phải có `$casts` ép kiểu `specifications` thành `array`.
- Product_Variants: Cột cốt lõi + cột `options` kiểu `json` (lưu màu, size...). Model phải có `$casts` ép kiểu `options` thành `array`.

# 4. TASK COMPLETION & TRACKING (CHANGELOG)
- Sau khi hoàn thành BẤT KỲ task nào, Agent BẮT BUỘC tự động mở file `CHANGELOG.md` (chưa có thì tự tạo) ở thư mục gốc và ghi lại theo format:
  - **[YYYY-MM-DD HH:mm] - Task Name**:
    - **Files Changed**: [Danh sách file]
    - **Logic Summary**: [Tóm tắt kỹ thuật]

# 5. KNOWLEDGE BASE & DOCUMENTATION
- Mỗi khi hoàn thành một cụm tính năng lớn, Agent BẮT BUỘC tự động mở/tạo file `SYSTEM_ARCHITECTURE.md` ở thư mục gốc.
- Trong file này, Agent phải giải thích bằng tiếng Việt: Luồng dữ liệu chạy thế nào? Các file cốt lõi nằm ở đâu? Tại sao lại code như vậy? (Mục đích để developer con người đọc và học hỏi).

# 6. CODING STANDARDS (PHP 8.2+)
- MỌI Model: BẮT BUỘC phải khai báo đầy đủ `$fillable` và `$casts` (dùng `->casts([...])` hoặc method `casts()` trả về array).KHÔNG để trống hoặc comment.
- MỌI Model quan hệ: Khi định nghĩa relationship (hasMany, belongsTo), BẮT BUỘC dùng Type Hinting cho tham số của method (VD: `function orders(): HasMany` thay vì `function orders()`).
- Model quan hệ: Khi định nghĩa relationship (hasMany, belongsTo), BẮT BUỘC dùng Type Hinting cho tham số của method (VD: `function orders(): HasMany` thay vì `function orders()`).
