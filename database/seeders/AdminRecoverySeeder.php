<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use Spatie\Permission\Models\Role;

class AdminRecoverySeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $admin = User::firstOrCreate([
            'email' => 'admin@gmail.com',
        ], [
            'name' => 'Super Admin',
            'password' => Hash::make('123456'),
            'is_active' => true,
        ]);

        // Assure role 'admin' exists and assign it
        $role = Role::firstOrCreate(['name' => 'admin', 'guard_name' => 'web']);
        $admin->assignRole($role);
    }
}
