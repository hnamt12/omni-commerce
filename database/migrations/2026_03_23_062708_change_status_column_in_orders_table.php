<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::table('orders', function (Blueprint $table) {
            // Đổi từ Enum tiếng Anh sang String để thoải mái lưu Tiếng Việt
            $table->string('status', 100)->default('Chờ xác nhận')->change();
        });
    }

    public function down()
    {
        // Không cần thiết rollback phần này
    }
};
