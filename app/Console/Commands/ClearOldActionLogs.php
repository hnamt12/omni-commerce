<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\ActionLog;

class ClearOldActionLogs extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'action-logs:clear';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Dọn dẹp nhật ký hoạt động hệ thống (Action logs) cũ hơn 90 ngày';

    /**
     * Execute the console command.
     */
    public function handle()
    {
        $this->info('Bắt đầu dọn dẹp action logs...');

        $cutoffDate = now()->subDays(90);
        $deletedCount = ActionLog::where('created_at', '<', $cutoffDate)->delete();

        $this->info("Đã xóa thành công {$deletedCount} bản ghi logs cũ hơn 90 ngày.");

        return Command::SUCCESS;
    }
}
