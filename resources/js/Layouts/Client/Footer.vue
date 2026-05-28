<script setup>
// Footer placeholder – expand with links in a future phase
</script>

<template>
    <footer class="bg-gray-900 text-gray-300 mt-12">
        <div class="max-w-7xl mx-auto px-4 py-10 grid grid-cols-1 md:grid-cols-4 gap-8">
            <!-- Brand -->
            <div>
                <div class="text-2xl font-black tracking-tighter mb-3">
                    <span class="text-indigo-400">Omni</span><span class="text-white">Commerce</span>
                </div>
                <p class="text-sm text-gray-400 leading-relaxed">
                    Nền tảng mua sắm trực tuyến hàng đầu. Hàng chính hãng 100%, giao nhanh 2H, đổi trả 30 ngày.
                </p>
                <div class="flex gap-3 mt-4">
                    <a href="#" class="w-8 h-8 rounded-full bg-gray-700 flex items-center justify-center hover:bg-indigo-600 transition">
                        <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 24 24"><path fill-rule="evenodd" d="M22 12c0-5.523-4.477-10-10-10S2 6.477 2 12c0 4.991 3.657 9.128 8.438 9.878v-6.987h-2.54V12h2.54V9.797c0-2.506 1.492-3.89 3.777-3.89 1.094 0 2.238.195 2.238.195v2.46h-1.26c-1.243 0-1.63.771-1.63 1.562V12h2.773l-.443 2.89h-2.33v6.988C18.343 21.128 22 16.991 22 12z" clip-rule="evenodd" /></svg>
                    </a>
                    <a href="#" class="w-8 h-8 rounded-full bg-gray-700 flex items-center justify-center hover:bg-red-600 transition">
                        <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 24 24"><path d="M23.498 6.186a3.016 3.016 0 00-2.122-2.136C19.505 3.545 12 3.545 12 3.545s-7.505 0-9.377.505A3.017 3.017 0 00.502 6.186C0 8.07 0 12 0 12s0 3.93.502 5.814a3.016 3.016 0 002.122 2.136c1.871.505 9.376.505 9.376.505s7.505 0 9.377-.505a3.015 3.015 0 002.122-2.136C24 15.93 24 12 24 12s0-3.93-.502-5.814zM9.545 15.568V8.432L15.818 12l-6.273 3.568z"/></svg>
                    </a>
                </div>
            </div>

            <!-- Navigation -->
            <div>
                <h4 class="font-bold text-white mb-3 text-sm uppercase tracking-wider">Chính sách</h4>
                <ul class="space-y-2 text-sm">
                    <li><a href="#" class="hover:text-white transition">Chính sách đổi trả</a></li>
                    <li><a href="#" class="hover:text-white transition">Chính sách bảo hành</a></li>
                    <li><a href="#" class="hover:text-white transition">Chính sách bảo mật</a></li>
                    <li><a href="#" class="hover:text-white transition">Điều khoản sử dụng</a></li>
                </ul>
            </div>

            <div>
                <h4 class="font-bold text-white mb-3 text-sm uppercase tracking-wider">Hỗ trợ</h4>
                <ul class="space-y-2 text-sm">
                    <li><a href="#" class="hover:text-white transition">Trung tâm hỗ trợ</a></li>
                    <li><a href="#" class="hover:text-white transition">Tra cứu đơn hàng</a></li>
                    <li><a href="#" class="hover:text-white transition">Câu hỏi thường gặp</a></li>
                    <li><a href="#" class="hover:text-white transition">Liên hệ: 1800-xxxx</a></li>
                </ul>
            </div>

            <div>
                <h4 class="font-bold text-white mb-3 text-sm uppercase tracking-wider">Tải ứng dụng</h4>
                <p class="text-sm text-gray-400 mb-3">Nhận thông báo đơn hàng real-time và ưu đãi độc quyền.</p>
                <div class="space-y-2">
                    <a href="#" class="flex items-center gap-2 px-3 py-2 bg-gray-700 rounded-lg hover:bg-gray-600 transition text-sm"><span>📱</span> App Store</a>
                    <a href="#" class="flex items-center gap-2 px-3 py-2 bg-gray-700 rounded-lg hover:bg-gray-600 transition text-sm"><span>🤖</span> Google Play</a>
                </div>
            </div>
        </div>
        <div class="border-t border-gray-800 py-4">
            <p class="text-center text-xs text-gray-500">© {{ new Date().getFullYear() }} OmniCommerce. All rights reserved.</p>
        </div>
    </footer>
</template>
