<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up() {
        Schema::table('vouchers', function (Blueprint $table) {
            if (!Schema::hasColumn('vouchers', 'limit_per_user')) {
                $table->integer('limit_per_user')->default(1)->after('usage_limit');
            }
            if (!Schema::hasColumn('vouchers', 'image')) {
                $table->string('image')->nullable()->after('limit_per_user');
            }
        });
    }
    public function down() { }
};
