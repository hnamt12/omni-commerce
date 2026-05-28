<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Spatie\Permission\Models\Role;

class RolePermissionSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // 1. Tạo 3 Roles
        $superAdminRole = Role::create(['name' => 'Super Admin']);
        $accountantRole = Role::create(['name' => 'Accountant']);
        $salesRole = Role::create(['name' => 'Sales']);

        // 2. Tạo 1 User mặc định làm Super Admin
        $adminUser = User::firstOrCreate(
            ['email' => 'admin@omnCommerce.com'],
            [
                'name' => 'Super Admin',
                'password' => bcrypt('password'),
                'is_active' => true,
            ]
        );

        // Gán Role Super Admin cho User này
        $adminUser->assignRole($superAdminRole);
    }
}
