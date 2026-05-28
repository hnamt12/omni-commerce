/**
 * permissionGroups.js
 *
 * Nguồn dữ liệu duy nhất (Single Source of Truth) cho UI phân quyền Staff.
 * Phản ánh chính xác các permissions định nghĩa trong RolesAndPermissionsSeeder.php.
 *
 * Mỗi group chứa: name, icon (SVG path), color, bg, border, permissions[]
 * Mỗi permission: { id, label, description? }
 */
export const permissionGroups = [
    // ── Nhóm 1: Sale & CSKH ─────────────────────────────────────────────
    {
        name: 'Sale & CSKH',
        icon: 'M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z',
        color: 'text-emerald-600 dark:text-emerald-400',
        bg: 'bg-emerald-50 dark:bg-emerald-900/20',
        border: 'border-emerald-100 dark:border-emerald-800',
        permissions: [
            { id: 'view_orders',            label: 'Xem Đơn hàng',                description: 'Xem danh sách và chi tiết đơn hàng' },
            { id: 'update_orders',          label: 'Cập nhật trạng thái đơn',    description: 'Thay đổi trạng thái, chỉnh sửa thông tin đơn' },
            { id: 'create_orders',          label: 'Tạo đơn thủ công (POS)',     description: 'Tạo đơn hàng tại quầy cho khách' },
            { id: 'delete_orders',          label: 'Xóa đơn hàng đã hủy',       description: 'Xóa vĩnh viễn đơn có trạng thái Đã hủy' },
            { id: 'manage_cancel_requests', label: 'Xử lý yêu cầu hủy đơn',     description: 'Chấp nhận / Từ chối yêu cầu hủy từ khách' },
            { id: 'export_invoices',        label: 'In & Xuất hóa đơn',          description: 'In hóa đơn bán hàng và phiếu giao hàng' },
        ]
    },

    // ── Nhóm 2: Marketing & Content ─────────────────────────────────────
    {
        name: 'Marketing & Content',
        icon: 'M11 5.882V19.24a1.76 1.76 0 01-3.417.592l-2.147-6.15M18 13a3 3 0 100-6M5.436 13.683A4.001 4.001 0 017 6h1.832c4.1 0 7.625-1.234 9.168-3v14c-1.543-1.766-5.067-3-9.168-3H7a3.988 3.988 0 01-1.564-.317z',
        color: 'text-pink-600 dark:text-pink-400',
        bg: 'bg-pink-50 dark:bg-pink-900/20',
        border: 'border-pink-100 dark:border-pink-800',
        permissions: [
            { id: 'manage_banners',     label: 'Quản lý Banners',              description: 'Thêm/Sửa/Xóa banner quảng cáo' },
            { id: 'manage_vouchers',    label: 'Quản lý Mã giảm giá',          description: 'Tạo, chỉnh sửa, kích hoạt Voucher' },
            { id: 'manage_flash_sales', label: 'Quản lý Flash Sale',            description: 'Tạo và quản lý chương trình flash sale' },
            { id: 'manage_posts',       label: 'Quản lý Bài viết (Blog)',       description: 'Viết, biên tập và xuất bản bài viết' },
        ]
    },

    // ── Nhóm 3: Kho Hàng ────────────────────────────────────────────────
    {
        name: 'Kho Hàng',
        icon: 'M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4',
        color: 'text-amber-600 dark:text-amber-400',
        bg: 'bg-amber-50 dark:bg-amber-900/20',
        border: 'border-amber-100 dark:border-amber-800',
        permissions: [
            { id: 'view_inventory',     label: 'Xem Tồn kho',                  description: 'Tra cứu số lượng tồn kho theo SKU' },
            { id: 'update_stock',       label: 'Cập nhật tồn kho',             description: 'Nhập/Xuất/Điều chỉnh số lượng tồn' },
            { id: 'export_inventory',   label: 'Xuất báo cáo kho',             description: 'Export Excel/CSV báo cáo tồn kho' },
            { id: 'print_picking_slip', label: 'In phiếu lấy hàng (Picking)',  description: 'In danh sách SKU cần lấy cho đơn hàng' },
            { id: 'manage_suppliers',    label: 'Quản lý nhà cung cấp',         description: 'Thêm/Sửa/Xóa và xem danh sách NCC' },
        ]
    },

    // ── Nhóm 4: Kế Toán ──────────────────────────────────────────────────
    {
        name: 'Kế Toán',
        icon: 'M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z',
        color: 'text-blue-600 dark:text-blue-400',
        bg: 'bg-blue-50 dark:bg-blue-900/20',
        border: 'border-blue-100 dark:border-blue-800',
        permissions: [
            { id: 'view_analytics',     label: 'Xem Báo cáo Doanh thu',        description: 'Truy cập Dashboard & thống kê tài chính' },
            { id: 'export_reports',     label: 'Xuất Excel/CSV Báo cáo',       description: 'Xuất dữ liệu đơn hàng, doanh thu ra file' },
            { id: 'view_orders',        label: 'Xem Chi tiết Đơn hàng',        description: 'Đối chiếu từng đơn hàng (đọc, không sửa)' },
            { id: 'view_transactions',  label: 'Xem Giao dịch Thanh toán',     description: 'Tra cứu lịch sử thanh toán và công nợ' },
            { id: 'export_invoices',    label: 'In & Xuất Hóa đơn',            description: 'In hóa đơn bán hàng, xuất PDF' },
            { id: 'view_voucher_usage', label: 'Xem Voucher đã sử dụng',       description: 'Tra cứu Voucher nào đã dùng, khách hàng nào dùng' },
            { id: 'view_debt_report',   label: 'Báo cáo Công nợ & Sao kê',     description: 'COD chưa thu, phân tách doanh thu theo PT thanh toán' },
            { id: 'view_inventory_valuation', label: 'Đối soát Tồn kho theo Giá trị', description: 'So sánh giá trị nhập kho vs xuất kho trong kỳ' },
        ]
    },

    // ── Nhóm 5: Quản lý Danh mục ─────────────────────────────────────────
    {
        name: 'Quản lý Danh mục & SP',
        icon: 'M4 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2V6zM14 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2V6zM4 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2v-2zM14 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2v-2z',
        color: 'text-fuchsia-600 dark:text-fuchsia-400',
        bg: 'bg-fuchsia-50 dark:bg-fuchsia-900/20',
        border: 'border-fuchsia-100 dark:border-fuchsia-800',
        permissions: [
            { id: 'manage_products',    label: 'Quản lý Sản phẩm',             description: 'Thêm/Sửa/Xóa sản phẩm và biến thể' },
            { id: 'manage_categories',  label: 'Quản lý Danh mục & Thuộc tính', description: 'Danh mục, thương hiệu, thuộc tính sản phẩm' },
        ]
    },

    // ── Nhóm 6: Hệ thống — Quản trị viên ─────────────────────────────────
    {
        name: 'Hệ Thống (Quản Trị Viên)',
        icon: 'M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.066 2.573c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.573 1.066c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.066-2.573c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z',
        color: 'text-indigo-600 dark:text-indigo-400',
        bg: 'bg-indigo-50 dark:bg-indigo-900/20',
        border: 'border-indigo-100 dark:border-indigo-800',
        permissions: [
            { id: 'manage_users',       label: 'Quản lý Nhân sự (Staff)',       description: 'Tạo, sửa, phân quyền tài khoản nhân viên' },
            { id: 'manage_settings',    label: 'Cấu hình & Thanh toán',         description: 'Cài đặt hệ thống, phương thức thanh toán' },
            { id: 'manage_action_logs', label: 'Xem Nhật ký hoạt động',         description: 'Audit trail — theo dõi mọi thay đổi hệ thống' },
        ]
    },
];

/**
 * Helper: lấy flat array toàn bộ permission IDs
 * Dùng khi cần seed hoặc validate
 */
export const allPermissionIds = permissionGroups.flatMap(g => g.permissions.map(p => p.id));

/**
 * Helper: kiểm tra nhanh user có permission cụ thể không
 * @param {string[]} userPermissions - Mảng permission của user từ auth.user.permissions
 * @param {string} permission - Permission cần kiểm tra
 * @param {string[]} [userRoles] - Roles của user (superadmin/admin bypass)
 */
export function hasPermission(userPermissions = [], permission = '', userRoles = []) {
    // Superadmin & admin bypass tất cả
    if (userRoles.some(r => ['superadmin', 'admin'].includes(r))) return true;
    return userPermissions.includes(permission);
}

/**
 * Helper: kiểm tra user có ÍT NHẤT 1 trong danh sách permissions không
 */
export function hasAnyPermission(userPermissions = [], permissions = [], userRoles = []) {
    if (userRoles.some(r => ['superadmin', 'admin'].includes(r))) return true;
    return permissions.some(p => userPermissions.includes(p));
}
