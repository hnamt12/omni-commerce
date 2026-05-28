<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Log;
use Illuminate\Validation\Rule;
use Inertia\Inertia;
use Inertia\Response as InertiaResponse;
use App\Http\Requests\Admin\StoreStaffRequest;
use App\Http\Requests\Admin\UpdateStaffRequest;
use Spatie\Permission\Models\Permission;
use Spatie\Permission\Models\Role;
use Throwable;

class StaffController extends Controller
{
    private const GUARD_NAME = 'web';
    private const ROLE_STAFF = 'staff';

    public function index(): InertiaResponse
    {
        Role::firstOrCreate(['name' => self::ROLE_STAFF, 'guard_name' => self::GUARD_NAME]);
        
        $staff = User::role(self::ROLE_STAFF)
            ->with(['permissions', 'roles'])
            ->latest()
            ->paginate(10);

        return Inertia::render('Admin/Staff/Index', ['staff' => $staff]);
    }

    /**
     * Tối ưu hóa: Sử dụng Bulk Insert thay vì chạy foreach từng bản ghi
     */
    private function ensurePermissionsExist(array $permissions): void
    {
        if (empty($permissions)) {
            return;
        }

        // Lấy ra các quyền đã tồn tại trong DB để đối chiếu
        $existingPermissions = Permission::whereIn('name', $permissions)
            ->where('guard_name', self::GUARD_NAME)
            ->pluck('name')
            ->toArray();

        // Lọc ra các quyền chưa có để insert một lần duy nhất (Bulk Insert)
        $newPermissions = array_diff($permissions, $existingPermissions);

        if (!empty($newPermissions)) {
            $insertData = array_map(function ($name) {
                return [
                    'name' => $name,
                    'guard_name' => self::GUARD_NAME,
                    'created_at' => now(),
                    'updated_at' => now(),
                ];
            }, $newPermissions);

            Permission::insert($insertData);
        }
    }
    /**
     * Hiển thị trang tạo mới nhân sự
     */
    public function create(): InertiaResponse
    {
        $this->ensurePermissionsExist([
            'view_orders', 'update_orders', 'manage_cancel_requests',
            'manage_banners', 'manage_vouchers', 'manage_flash_sales', 'manage_posts',
            'view_inventory', 'update_stock',
            'view_analytics', 'export_reports',
            'manage_products', 'manage_categories', 'manage_users', 'manage_settings'
        ]);

        return Inertia::render('Admin/Staff/Form', [
            'staff' => null
        ]);
    }

    public function store(StoreStaffRequest $request): RedirectResponse
    {
        $validated = $request->validated();

        try {
            DB::beginTransaction();

            $user = User::create([
                'name' => $validated['name'],
                'email' => $validated['email'],
                'password' => Hash::make($validated['password']),
            ]);

            $staffRole = Role::firstOrCreate(['name' => self::ROLE_STAFF, 'guard_name' => self::GUARD_NAME]);
            $user->assignRole($staffRole);
            
            // Xử lý mảng an toàn với fallback array
            $permissions = $validated['permissions'] ?? [];
            
            if (!empty($permissions)) {
                // Gọi hàm Bulk Insert tối ưu hiệu suất
                $this->ensurePermissionsExist($permissions);
            }
            
            $user->syncPermissions($permissions);

            // Log staff creation with permissions explicitly
            \App\Models\ActionLog::create([
                'user_id'      => auth()->id(),
                'action'       => 'created',
                'loggable_type' => get_class($user),
                'loggable_id'  => $user->id,
                'old_values'   => null,
                'new_values'   => [
                    'name' => $user->name,
                    'email' => $user->email,
                    'permissions' => $permissions
                ],
                'ip_address'   => request()->ip(),
                'user_agent'   => request()->userAgent(),
            ]);

            DB::commit();
            return redirect()->route('admin.staff.index')->with('success', 'Thêm nhân sự thành công');
            
        } catch (Throwable $e) { 
            // KHÔNG BAO GIỜ BỊ LEAK TRANSACTION VÌ ĐÃ BẮT THROWABLE
            DB::rollBack();
            
            Log::error("STAFF CREATE ERROR: " . $e->getMessage(), [
                'trace' => $e->getTraceAsString(),
                'payload' => $request->except(['password'])
            ]);
            
            return back()->withErrors(['error' => 'Lỗi hệ thống: ' . $e->getMessage()]);
        }
    }
    /**
     * Hiển thị trang chỉnh sửa nhân sự
     */
    public function edit(User $staff): InertiaResponse
    {
        $this->ensurePermissionsExist(
            ['view_orders', 'update_orders', 'manage_cancel_requests', 'manage_banners', 'manage_vouchers', 'manage_flash_sales', 'manage_posts', 'view_inventory', 'update_stock', 'view_analytics', 'export_reports', 'manage_products', 'manage_categories', 'manage_users', 'manage_settings']
        );
        $staffData = $staff->toArray();
        $staffData['permissions'] = $staff->getAllPermissions()->pluck('name');
        return Inertia::render('Admin/Staff/Form', ['staff' => $staffData]);
    }

    public function update(UpdateStaffRequest $request, User $staff): RedirectResponse
    {
        $validated = $request->validated();

        try {
            DB::beginTransaction();

            $data = ['name' => $validated['name'], 'email' => $validated['email']];
            if (!empty($validated['password'])) {
                $data['password'] = Hash::make($validated['password']);
            }
            $oldPermissions = $staff->getAllPermissions()->pluck('name')->toArray();

            $staff->update($data);

            $staffRole = Role::firstOrCreate(['name' => self::ROLE_STAFF, 'guard_name' => self::GUARD_NAME]);
            $staff->assignRole($staffRole);
            
            $permissions = $validated['permissions'] ?? [];
            if (!empty($permissions)) {
                // Tối ưu hiệu suất DB tại đây
                $this->ensurePermissionsExist($permissions);
            }
            
            $staff->syncPermissions($permissions);

            // Log permission changes explicitly
            $newPermissions = $permissions;
            sort($oldPermissions);
            sort($newPermissions);

            if ($oldPermissions !== $newPermissions) {
                \App\Models\ActionLog::create([
                    'user_id'      => auth()->id(),
                    'action'       => 'updated_permissions',
                    'loggable_type' => get_class($staff),
                    'loggable_id'  => $staff->id,
                    'old_values'   => ['permissions' => $oldPermissions],
                    'new_values'   => ['permissions' => $newPermissions],
                    'ip_address'   => request()->ip(),
                    'user_agent'   => request()->userAgent(),
                ]);
            }

            DB::commit();
            return redirect()->route('admin.staff.index')->with('success', 'Cập nhật nhân sự thành công');
            
        } catch (Throwable $e) {
            DB::rollBack();
            Log::error("STAFF UPDATE ERROR: " . $e->getMessage(), ['trace' => $e->getTraceAsString()]);
            return back()->withErrors(['error' => 'Lỗi hệ thống: ' . $e->getMessage()]);
        }
    }
}