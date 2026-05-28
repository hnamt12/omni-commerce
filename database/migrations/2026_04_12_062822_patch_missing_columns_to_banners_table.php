<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::table('banners', function (Blueprint $table) {
            // Xử lý cột link_url
            if (! Schema::hasColumn('banners', 'link_url')) {
                if (Schema::hasColumn('banners', 'link')) {
                    $table->renameColumn('link', 'link_url');
                } else {
                    $table->string('link_url')->nullable()->after('image_url');
                }
            }

            // Xử lý cột layout_type
            if (! Schema::hasColumn('banners', 'layout_type')) {
                $table->string('layout_type')->default('full')->after('position');
            }
        });
    }

    public function down()
    {
        // Không cần thiết rollback trong trường hợp vá lỗi này
    }
};
