<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use Spatie\Permission\Models\Permission;
use Spatie\Permission\Models\Role;
use Spatie\Permission\PermissionRegistrar;

/**
 * RolesAndPermissionsSeeder
 *
 * Seed đầy đủ roles + permissions cho hệ thống OmniCommerce.
 * Chạy: php artisan db:seed --class=RolesAndPermissionsSeeder
 *
 * Cấu trúc phân quyền:
 *   superadmin → Bypass toàn bộ (wildcard)
 *   admin      → Toàn quyền (tất cả permissions)
 *   staff      → Quyền cụ thể được assign tay
 */
class RolesAndPermissionsSeeder extends Seeder
{
    private const GUARD = 'web';

    /**
     * Danh sách đầy đủ các permissions theo nhóm nghiệp vụ.
     * Mỗi cặp ['name', 'description'] để dễ document.
     */
    private function getPermissions(): array
    {
        return [
            // ── Nhóm: Sale & CSKH ────────────────────────────────────
            'view_orders' => 'Xem danh sách và chi tiết đơn hàng',
            'update_orders' => 'Cập nhật trạng thái, chỉnh sửa đơn hàng',
            'create_orders' => 'Tạo đơn hàng thủ công (POS)',
            'delete_orders' => 'Xóa đơn hàng đã hủy',
            'manage_cancel_requests' => 'Xử lý yêu cầu hủy đơn từ khách hàng',

            // ── Nhóm: Marketing & Content ─────────────────────────────
            'manage_banners' => 'Quản lý Banner quảng cáo',
            'manage_vouchers' => 'Quản lý Mã giảm giá (Voucher)',
            'manage_flash_sales' => 'Quản lý Flash Sale',
            'manage_posts' => 'Quản lý Bài viết / Blog',

            // ── Nhóm: Kho Hàng ────────────────────────────────────────
            'view_inventory' => 'Xem tồn kho và báo cáo kho',
            'update_stock' => 'Cập nhật số lượng tồn kho (nhập/xuất/điều chỉnh)',
            'export_inventory' => 'Xuất báo cáo tồn kho ra Excel/CSV',
            'print_picking_slip' => 'In phiếu lấy hàng (Picking Slip) khi xử lý đơn',
            'manage_suppliers' => 'Quản lý nhà cung cấp',

            // ── Nhóm: Kế Toán ─────────────────────────────────────────
            'view_analytics' => 'Xem Bảng điều khiển và báo cáo doanh thu',
            'export_reports' => 'Xuất báo cáo Excel/CSV (đơn hàng, kho)',
            'view_transactions' => 'Xem lịch sử giao dịch thanh toán',
            'export_invoices' => 'In và xuất hóa đơn bán hàng',
            'view_voucher_usage' => 'Xem lịch sử sử dụng Voucher',
            'view_debt_report' => 'Xem báo cáo công nợ & sao kê thanh toán',
            'view_inventory_valuation' => 'Xem đối soát tồn kho theo giá trị',

            // ── Nhóm: Quản lý Danh mục & Sản phẩm ────────────────────
            'manage_products' => 'Thêm/Sửa/Xóa Sản phẩm',
            'manage_categories' => 'Quản lý Danh mục, Thương hiệu và Thuộc tính',

            // ── Nhóm: Hệ Thống — Quản trị viên ───────────────────────
            'manage_users' => 'Quản lý Tài khoản nhân sự (tạo/sửa/xóa staff)',
            'manage_settings' => 'Cấu hình hệ thống và Phương thức thanh toán',

            // ── Nhóm: Audit & Compliance ──────────────────────────────
            'manage_action_logs' => 'Xem và quản lý Nhật ký hoạt động hệ thống (Audit Trail)',
        ];
    }

    public function run(): void
    {
        // Xóa cache permission Spatie để tránh stale data
        app()[PermissionRegistrar::class]->forgetCachedPermissions();

        // ─── 1. Tạo tất cả permissions ────────────────────────────────
        $this->command->info('📋 Tạo permissions...');
        foreach ($this->getPermissions() as $name => $description) {
            Permission::firstOrCreate(
                ['name' => $name, 'guard_name' => self::GUARD]
            );
        }

        // ─── 2. Tạo Roles ─────────────────────────────────────────────
        $this->command->info('👥 Tạo roles...');

        // Superadmin: Không cần permissions — bypass qua gate trực tiếp
        $superadmin = Role::firstOrCreate(['name' => 'superadmin', 'guard_name' => self::GUARD]);

        // Admin: Có toàn bộ permissions
        $admin = Role::firstOrCreate(['name' => 'admin', 'guard_name' => self::GUARD]);
        $admin->syncPermissions(array_keys($this->getPermissions()));

        // Staff: Không có permissions mặc định — phải assign tay
        $staff = Role::firstOrCreate(['name' => 'staff', 'guard_name' => self::GUARD]);

        // ─── 3. Cấu hình Gate: superadmin bypass mọi authorization ───
        // Đây là pattern chuẩn Spatie — thêm vào AuthServiceProvider hoặc AppServiceProvider
        // Đã được xử lý trong AdminPermission middleware thay vì Gate::before
        // để tránh ảnh hưởng tới các gate khác của hệ thống

        // ─── 4. Tạo tài khoản Superadmin mặc định nếu chưa có ────────
        $this->command->info('👤 Kiểm tra tài khoản superadmin...');

        $superadminEmail = env('SUPERADMIN_EMAIL', 'superadmin@omnicommerce.vn');
        $superadminUser = User::firstOrCreate(
            ['email' => $superadminEmail],
            [
                'name' => 'Super Admin',
                'password' => Hash::make(env('SUPERADMIN_PASSWORD', 'SuperAdmin@2026!')),
                'is_active' => 1,
            ]
        );

        // Gán role superadmin (có thể gán thêm admin để có permissions trực tiếp)
        $superadminUser->syncRoles(['superadmin', 'admin']);

        $this->command->info("✅ Superadmin: {$superadminEmail}");
        $this->command->info('✅ Seeder hoàn tất! Tổng: '.count($this->getPermissions()).' permissions, 3 roles.');

        // In bảng tóm tắt
        $this->command->table(
            ['Permission', 'Mô tả'],
            collect($this->getPermissions())->map(fn ($desc, $name) => [$name, $desc])->values()->toArray()
        );
    }
}
