import Swal from 'sweetalert2';

export const vnSlugify = (str) => {
    if (!str) return '';
    str = String(str).replace(/^\s+|\s+$/g, '').toLowerCase();
    const from = "áàảãạăắằẳẵặâấầẩẫậđéèẻẽẹêếềểễệíìỉĩịóòỏõọôốồổỗộơớờởỡợúùủũụưứừửữựýỳỷỹỵ·/_,:;";
    const to   = "aaaaaaaaaaaaaaaaadeeeeeeeeeeeiiiiiooooooooooooooooouuuuuuuuuuuyyyyy------";
    for (let i = 0, l = from.length; i < l; i++) {
        str = str.replace(new RegExp(from.charAt(i), 'g'), to.charAt(i));
    }
    return str.replace(/[^a-z0-9 -]/g, '').replace(/\s+/g, '-').replace(/-+/g, '-');
};

// Dùng cho ô Input nhập liệu (chỉ có số và dấu chấm)
export const formatMoney = (val) => {
    if (!val && val !== 0) return '';
    return val.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".");
};

export const parseMoney = (val) => {
    if (!val) return '';
    return val.toString().replace(/\D/g, '');
};

// Dùng cho hiển thị UI (Có chữ đ phía sau)
export const formatCurrency = (amount) => {
    if (!amount && amount !== 0) return '0đ';
    return new Intl.NumberFormat('vi-VN').format(amount) + 'đ';
};

// Hàm hiển thị thông báo góc màn hình (Toast)
export const showToast = (message, icon = 'success') => {
    Swal.fire({
        toast: true,
        position: 'top-end',
        icon: icon,
        title: message,
        showConfirmButton: false,
        timer: 3000,
        timerProgressBar: true
    });
};

// Hàm gọi hộp thoại xác nhận xóa chung
export const confirmDelete = async (title = 'Xác nhận xóa?', text = 'Dữ liệu sẽ được đưa vào thùng rác!') => {
    return await Swal.fire({
        title: title,
        text: text,
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#ef4444',
        cancelButtonColor: '#9ca3af',
        confirmButtonText: 'Đồng ý',
        cancelButtonText: 'Hủy bỏ',
        reverseButtons: true
    });
};
