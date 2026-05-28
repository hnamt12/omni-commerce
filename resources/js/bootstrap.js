import axios from 'axios';
window.axios = axios;
window.axios.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest';
// Cấu hình bắt buộc để Axios tự gửi Cookie
window.axios.defaults.withCredentials = true;

// Tự động reload trang nếu Session hết hạn (Lỗi 419)
window.axios.interceptors.response.use(response => response, error => {
    if (error.response && error.response.status === 419) {
        window.location.reload();
    }
    return Promise.reject(error);
});

import Echo from 'laravel-echo';
import Pusher from 'pusher-js';
window.Pusher = Pusher;

// Đợi Inertia nạp trang xong thì lấy key từ shared props của Backend truyền qua
document.addEventListener('inertia:start', (event) => {
    const sharedProps = window.Laravel?.initialPage?.props; // Hoặc tùy cấu trúc Page của bạn
    
    if (sharedProps?.pusher?.app_key && !window.Echo) {
        window.Echo = new Echo({
            broadcaster: 'pusher',
            key: sharedProps.pusher.app_key,
            cluster: sharedProps.pusher.cluster,
            forceTLS: true
        });
    }
});