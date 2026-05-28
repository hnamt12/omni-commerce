import './bootstrap';

import { createApp, h } from 'vue';
import { createInertiaApp, router } from '@inertiajs/vue3';
import { resolvePageComponent } from 'laravel-vite-plugin/inertia-helpers';
import { ZiggyVue } from '../../vendor/tightenco/ziggy';

const appName = window.document.getElementsByTagName('title')[0]?.innerText || 'Laravel';

router.on('exception', (event) => {
    event.preventDefault(); // Ngăn Inertia hiện modal mặc định
    console.error('🔥 [Inertia Exception]:', event.detail.error);
    alert('Hệ thống gặp lỗi nghiêm trọng! Vui lòng mở F12 -> Console để xem chi tiết.');
});

import AdminLayout from './Layouts/Admin/AdminLayout.vue';

createInertiaApp({
    title: (title) => `${title} - ${appName}`,
    resolve: (name) => {
        const pagePromise = resolvePageComponent(`./Pages/${name}.vue`, import.meta.glob('./Pages/**/*.vue'));
        return pagePromise.then((page) => {
            if (name.startsWith('Admin/') && name !== 'Admin/Login') {
                page.default.layout = page.default.layout || AdminLayout;
            }
            return page;
        });
    },
    setup({ el, App, props, plugin }) {
        return createApp({ render: () => h(App, props) })
            .use(plugin)
            .use(ZiggyVue)
            .mount(el);
    },
    progress: {
        color: '#4B5563',
    },
});
