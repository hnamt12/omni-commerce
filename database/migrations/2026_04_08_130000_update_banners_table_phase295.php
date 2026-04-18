<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('banners', function (Blueprint $table) {
            // Rename link_url -> link (if link_url exists, link doesn't)
            if (Schema::hasColumn('banners', 'link_url') && !Schema::hasColumn('banners', 'link')) {
                $table->renameColumn('link_url', 'link');
            }
            // Drop layout_type if it exists
            if (Schema::hasColumn('banners', 'layout_type')) {
                $table->dropColumn('layout_type');
            }
        });

        // Update default position values to match new naming convention
        DB::statement("UPDATE banners SET position = 'main_slider' WHERE position IN ('home_hero')");
        DB::statement("UPDATE banners SET position = 'middle_banner' WHERE position IN ('home_mid', 'footer')");
    }

    public function down(): void
    {
        Schema::table('banners', function (Blueprint $table) {
            if (Schema::hasColumn('banners', 'link') && !Schema::hasColumn('banners', 'link_url')) {
                $table->renameColumn('link', 'link_url');
            }
            if (!Schema::hasColumn('banners', 'layout_type')) {
                $table->string('layout_type')->default('col-span-12')->after('position');
            }
        });
    }
};
