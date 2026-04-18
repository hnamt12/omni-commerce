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