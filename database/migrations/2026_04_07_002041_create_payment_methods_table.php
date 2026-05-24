<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('payment_methods', function (Blueprint $table) {
            $table->id();
            $table->string('name');                  // VD: Cổng VNPay, Chuyển khoản VietQR
            $table->string('code')->unique();         // VD: vnpay, vietqr, cod
            $table->text('description')->nullable();   // Mô tả phương thức
            $table->string('type');                   // gateway | manual | cod
            $table->string('logo_url')->nullable();   // Link ảnh logo
            $table->json('config')->nullable();        // API keys, bank info (JSON)
            $table->boolean('is_active')->default(true);
            $table->integer('sort_order')->default(0);
            $table->timestamps();
        });
    }

    public function down(): void
    {
        // STRICTLY DISABLED TO PROTECT PRODUCTION DATA
    }
};
