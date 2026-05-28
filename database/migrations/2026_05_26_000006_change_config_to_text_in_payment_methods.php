<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Crypt;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        // 1. Thay đổi cột thành TEXT (hoặc LONGTEXT) thay vì JSON
        // MySQL không cho phép lưu chuỗi mã hóa (base64) vào cột JSON vì nó không đúng định dạng JSON
        Schema::table('payment_methods', function (Blueprint $table) {
            $table->text('config')->nullable()->change();
        });

        // MySQL 8.0+ keeps the JSON check constraint even after changing column type to TEXT. We must drop it.
        try {
            DB::statement('ALTER TABLE payment_methods DROP CHECK payment_methods_chk_1');
        } catch (\Exception $e) {
            // ignore if it doesn't exist or is already dropped
        }

        // 2. Chạy kịch bản mã hóa dữ liệu cũ
        $methods = DB::table('payment_methods')->get();
        foreach($methods as $method) {
            $configStr = trim($method->config);
            
            // Nếu dữ liệu cũ đang ở dạng JSON thô
            if ($configStr && (str_starts_with($configStr, '{') || str_starts_with($configStr, '['))) {
                // Mã hóa và lưu lại (bây giờ cột đã là TEXT nên sẽ không bị lỗi constraint)
                DB::table('payment_methods')->where('id', $method->id)->update([
                    'config' => Crypt::encryptString($configStr)
                ]);
            }
        }
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        // 1. Giải mã trước khi quay về JSON
        $methods = DB::table('payment_methods')->get();
        foreach($methods as $method) {
            $configStr = trim($method->config);
            
            // Nếu là chuỗi đã mã hóa
            if ($configStr && !str_starts_with($configStr, '{') && !str_starts_with($configStr, '[')) {
                try {
                    $decrypted = Crypt::decryptString($configStr);
                    DB::table('payment_methods')->where('id', $method->id)->update([
                        'config' => $decrypted
                    ]);
                } catch (\Exception $e) {
                    // ignore
                }
            }
        }

        Schema::table('payment_methods', function (Blueprint $table) {
            $table->json('config')->nullable()->change();
        });
    }
};
