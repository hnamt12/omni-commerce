<?php
namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rule;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Spatie\Permission\Models\Role;
use Spatie\Permission\Models\Permission;

class StaffController extends Controller
{
    public function index()
    {
        // Self-healing: Ensure 'staff' role exists
        Role::firstOrCreate(['name' => 'staff', 'guard_name' => 'web']);
        
        $staff = User::role('staff')->with(['permissions', 'roles'])->latest()->paginate(10);
        return Inertia::render('Admin/Staff/Index', ['staff' => $staff]);
    }

    private function ensurePermissionsExist()
    {
        $permissions = [
            'view_orders', 'update_orders', 'manage_cancel_requests',
            'manage_banners', 'manage_vouchers', 'manage_flash_sales', 'manage_posts',
            'view_inventory', 'update_stock',
            'view_analytics', 'export_reports',
            'manage_products', 'manage_categories',
            'manage_users', 'manage_settings'
        ];

        foreach ($permissions as $perm) {
            Permission::firstOrCreate(['name' => $perm, 'guard_name' => 'web']);
        }
    }

    public function create()
    {
        $this->ensurePermissionsExist();
        return Inertia::render('Admin/Staff/Form');
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:8',
            'permissions' => 'nullable|array',
        ]);

        try {
            DB::beginTransaction();
            $user = User::create([
                'name' => $validated['name'],
                'email' => $validated['email'],
                'password' => Hash::make($validated['password']),
            ]);
            
            $role = Role::firstOrCreate(['name' => 'staff', 'guard_name' => 'web']);
            $user->assignRole($role);
            
            if (!empty($validated['permissions'])) {
                foreach ($validated['permissions'] as $perm) {
                    Permission::firstOrCreate(['name' => $perm, 'guard_name' => 'web']);
                }
                $user->syncPermissions($validated['permissions']);
            }
            DB::commit();
            return redirect()->route('admin.staff.index')->with('success', 'Thêm nhân sự thành công');
        } catch (\Exception $e) {
            DB::rollBack();
            Log::error("STAFF CREATE ERROR: " . $e->getMessage());
            return back()->withErrors(['error' => 'Lỗi hệ thống: ' . $e->getMessage()]);
        }
    }

    public function edit(User $staff)
    {
        $this->ensurePermissionsExist();
        $staffData = $staff->toArray();
        $staffData['permissions'] = $staff->getAllPermissions()->pluck('name');
        return Inertia::render('Admin/Staff/Form', ['staff' => $staffData]);
    }

    public function update(Request $request, User $staff)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'email' => ['required', 'string', 'email', 'max:255', Rule::unique('users')->ignore($staff->id)],
            'password' => 'nullable|string|min:8',
            'permissions' => 'nullable|array',
        ]);

        try {
            DB::beginTransaction();
            $data = ['name' => $validated['name'], 'email' => $validated['email']];
            if (!empty($validated['password'])) {
                $data['password'] = Hash::make($validated['password']);
            }
            $staff->update($data);
            
            if (!empty($validated['permissions'])) {
                foreach ($validated['permissions'] as $perm) {
                    Permission::firstOrCreate(['name' => $perm, 'guard_name' => 'web']);
                }
            }
            $staff->syncPermissions($validated['permissions'] ?? []);

            DB::commit();
            return redirect()->route('admin.staff.index')->with('success', 'Cập nhật nhân sự thành công');
        } catch (\Exception $e) {
            DB::rollBack();
            Log::error("STAFF UPDATE ERROR: " . $e->getMessage());
            return back()->withErrors(['error' => 'Lỗi hệ thống: ' . $e->getMessage()]);
        }
    }

    public function destroy(User $staff)
    {
        $staff->delete();
        return redirect()->route('admin.staff.index')->with('success', 'Xóa nhân sự thành công');
    }
}
