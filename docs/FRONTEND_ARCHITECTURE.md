# OmniCommerce — Frontend & UI Architecture Map

> **Mục đích:** Tài liệu này bản đồ hóa toàn bộ kiến trúc Frontend (Vue 3 + Inertia.js + TailwindCSS), cách luân chuyển dữ liệu giữa Server ↔ Client, các Layout chính và quy chuẩn xây dựng UI.
> Bất kỳ AI Agent hoặc Developer nào làm việc ở tầng Frontend đều **BẮT BUỘC** phải đọc hiểu tài liệu này để viết code đồng bộ, tránh phá vỡ giao diện hoặc logic chia sẻ trạng thái.

---

## 🎨 1. Tech Stack & Library Standards

| Công nghệ | Phiên bản | Cách sử dụng trong dự án |
|---|---|---|
| **Core Framework** | Vue 3 | Bắt buộc sử dụng `<script setup>` và Composition API. |
| **Routing & SPA Glue** | Inertia.js Vue3 | Dùng thay cho Vue Router. Mọi tương tác chuyển trang sử dụng `<Link>` và `router`. |
| **State Management** | Pinia / Inertia Shared Props | Hạn chế dùng Pinia cho dữ liệu tĩnh, ưu tiên sử dụng `usePage().props` để nhận dữ liệu đồng bộ từ Laravel. |
| **Styling** | TailwindCSS v3 | Hạn chế tối đa viết CSS thuần. Sử dụng class tiện ích của Tailwind. |
| **Form Handling** | Inertia `useForm` | Bắt buộc sử dụng `useForm` từ `@inertiajs/vue3` để quản lý trạng thái submit, errors, và processing. |

---

## 🔄 2. Luồng Dữ liệu (Data Flow) & Inertia Shared Props

OmniCommerce không sử dụng API Token hay JWT, mọi giao tiếp Frontend ↔ Backend đều thông qua giao thức **Inertia.js**.

### 2.1. Nhận dữ liệu từ Backend (Inertia Share)
Tại file `app/Http/Middleware/HandleInertiaRequests.php`, hệ thống định nghĩa các dữ liệu dùng chung (Shared Props) gửi xuống mọi màn hình Vue:

```javascript
import { usePage } from '@inertiajs/vue3';

const page = usePage();

// 1. Lấy thông tin đăng nhập của Admin (Guard: web)
const adminUser = page.props.auth.user;

// 2. Lấy thông tin đăng nhập của Khách hàng (Guard: customer)
const customerUser = page.props.auth.customer;

// 3. Lấy thông tin thông báo nhanh (Flash Messages)
const flashSuccess = page.props.flash.success;
const flashError = page.props.flash.error;

// 4. Lấy lỗi Validation hoặc Hệ thống
const validationErrors = page.props.errors;
```

---

## 🏢 3. Cấu trúc Giao diện & Layouts

Thư mục: `resources/js/`

```
resources/js/
├── Layouts/
│   ├── Admin/
│   │   ├── AdminLayout.vue    ← Layout chung của Admin (gồm Sidebar + Header + Toast)
│   │   └── Sidebar.vue        ← Menu điều hướng phân quyền Spatie
│   └── Client/
│       └── ClientLayout.vue   ← Layout chung Khách hàng (gồm Header + Footer + Cart Drawer)
├── Pages/
│   ├── Admin/                 ← Các màn hình nghiệp vụ Admin
│   │   ├── Dashboard/
│   │   ├── Accounting/
│   │   └── Settings/
│   └── Client/                ← Các màn hình Khách hàng
│       ├── Home.vue
│       ├── Cart/
│       └── Orders/
└── Composables/               ← Các hàm tiện ích dùng chung
```

---

## 🔒 4. Quy chuẩn Giao diện & Trải nghiệm Người dùng (Strict UI Rules)

### 4.1. Quy chuẩn Quản lý Form & Báo lỗi (Validation Radar)
Theo quy định nghiêm ngặt tại `AGENT_GUIDELINES.md`, mọi biểu mẫu (Form) nhập liệu ở Frontend phải tuân thủ cấu trúc sau:

1. **Bắt buộc dùng `useForm`**:
   ```javascript
   import { useForm } from '@inertiajs/vue3';

   const form = useForm({
       name: '',
       price: 0,
   });

   const submit = () => {
       form.post(route('admin.products.store'), {
           onSuccess: () => form.reset(),
       });
   };
   ```
2. **Khối Báo lỗi Toàn cục (Global Error Banner)**: Bắt buộc đặt ở trên cùng của mọi form để phòng trường hợp lỗi hệ thống 500 hoặc validation bị bỏ sót:
   ```html
   <div v-if="$page.props.errors.error || Object.keys(form.errors).length > 0" class="p-4 mb-4 bg-red-50 border-l-4 border-red-500 text-red-700">
       <p class="font-bold">Đã xảy ra lỗi:</p>
       <ul class="list-disc pl-5 text-sm">
           <li v-if="$page.props.errors.error">{{ $page.props.errors.error }}</li>
           <li v-for="(error, key) in form.errors" :key="key">{{ error }}</li>
       </ul>
   </div>
   ```

### 4.2. Trạng thái Loading / Processing
Mọi nút submit phải hiển thị trạng thái vô hiệu hóa (disabled) khi đang gửi request để tránh submit trùng:
```html
<button type="submit" :disabled="form.processing" class="btn btn-primary">
    <span v-if="form.processing">Đang xử lý...</span>
    <span v-else>Lưu thông tin</span>
</button>
```

### 4.3. Đăng xuất an toàn (Safe Logout)
Mọi nút/liên kết Đăng xuất tuyệt đối không dùng thẻ `<a>` thông thường (tránh lỗi 419 GET method). Bắt buộc dùng:
```html
import { Link } from '@inertiajs/vue3';

<Link href="/logout" method="post" as="button" class="btn-logout">
    Đăng xuất
</Link>
```

---

## 🛠️ 5. Các hàm bổ trợ (Composables / Helper) có sẵn

Để tránh viết lại logic định dạng dữ liệu, hãy ưu tiên sử dụng các hàm đã được khai báo hoặc tạo mới trong thư mục `resources/js/Composables/`:

*   **Định dạng tiền tệ VND:**
    ```javascript
    export const formatPrice = (value) => {
        return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(value);
    };
    ```
*   **Badges Trạng thái Đơn hàng (Order Status Badges):**
    Áp dụng class Tailwind tương ứng với trạng thái để giao diện đồng bộ:
    - `pending`: Màu vàng (`bg-yellow-100 text-yellow-800`)
    - `processing`: Màu xanh dương (`bg-blue-100 text-blue-800`)
    - `shipping`: Màu tím (`bg-purple-100 text-purple-800`)
    - `completed`: Màu xanh lá (`bg-green-100 text-green-800`)
    - `cancelled`: Màu đỏ (`bg-red-100 text-red-800`)
