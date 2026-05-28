# Project Rules — Vue 3 + Inertia + Laravel

## ⚡ Token Optimization (CRITICAL)
- NEVER scan or read: node_modules/, vendor/, .git/, storage/framework/, bootstrap/cache/
- NEVER read full file if only needing a function — ask for line range first
- NEVER load more than 5 files per task unless explicitly requested
- Before reading any file, state WHY you need it
- **BẮT BUỘC ĐỌC `docs/TECH_DEBT_MASTER.md` ĐẦU TIÊN** khi có yêu cầu tối ưu hóa, cải tiến, hoặc refactor hệ thống. Tuyệt đối không quét toàn bộ dự án để tránh làm cháy token của khách hàng. Agent chỉ được phép đọc những file cụ thể được chỉ định trong file TECH_DEBT_MASTER.md.

## 📁 Project Structure — Only These Matter
- Frontend: resources/js/ (Pages/, Components/, Composables/, Stores/)
- Backend: app/Http/Controllers/, app/Models/, routes/web.php, routes/api.php
- Config: config/ (chỉ khi liên quan task)
- Migrations: database/migrations/ (chỉ khi task liên quan DB)
- Entry: vite.config.js, composer.json (chỉ khi cần)

## 🎯 Tech Stack
- Vue 3 Composition API + <script setup>
- Inertia.js (usePage, useForm, router)
- Laravel 11 + Eloquent ORM
- Tailwind CSS (không dùng custom CSS trừ khi cần)

## 🔒 Behavior Rules
- Đọc file theo yêu cầu, KHÔNG đọc trước để "hiểu context"
- Khi fix bug: chỉ đọc file liên quan trực tiếp
- Khi tạo feature mới: hỏi tôi file nào cần tham khảo
- Luôn dùng targeted read (line range) thay vì đọc cả file