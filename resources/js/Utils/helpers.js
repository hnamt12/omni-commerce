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

// ===== MONEY FORMATTING (DRY - Single Source of Truth) =====
// CRITICAL: Laravel DECIMAL(15,2) returns strings like "2000000.00"
// We must parseFloat FIRST to handle the decimal point correctly,
// then Math.round to get clean integer (VND has no subunits).

// Dùng cho ô Input nhập liệu (chỉ có số và dấu chấm phân cách hàng nghìn)
export const formatMoney = (val) => {
    if (!val && val !== 0) return '';
    // Handle Laravel decimal strings like "2000000.00"
    const num = Math.round(parseFloat(val));
    if (isNaN(num) || num === 0) return '';
    return new Intl.NumberFormat('vi-VN').format(num);
};

// Parse chuỗi tiền tệ thành số nguyên thuần (loại bỏ mọi ký tự không phải số)
// Input có thể là: "2.000.000" (formatted) hoặc "2000000.00" (Laravel decimal) hoặc 2000000 (integer)
export const parseMoney = (val) => {
    if (!val && val !== 0) return 0;
    // If already a number, just round it
    if (typeof val === 'number') return Math.round(val);
    // If it's a Laravel decimal string (has exactly one dot followed by digits at end), parse as float
    const str = String(val);
    if (/^\d+\.\d{1,2}$/.test(str)) {
        return Math.round(parseFloat(str));
    }
    // Otherwise it's a formatted string like "2.000.000" — strip all non-digits
    const cleaned = str.replace(/[^0-9]/g, '');
    return cleaned ? parseInt(cleaned, 10) : 0;
};

// Dùng cho hiển thị UI chính thức (Có chữ đ phía sau)
export const formatCurrency = (amount) => {
    if (!amount && amount !== 0) return '0đ';
    const num = Math.round(parseFloat(amount));
    if (isNaN(num)) return '0đ';
    return new Intl.NumberFormat('vi-VN').format(num) + 'đ';
};

// Event handler cho @input trên ô tiền - gán số thô vào reactive object
export const handleMoneyInput = (e, obj, field) => {
    const raw = e.target.value.replace(/[^0-9]/g, '');
    obj[field] = raw ? parseInt(raw, 10) : '';
};

// Event handler cho @blur trên ô tiền - format lại hiển thị khi rời ô
export const handleMoneyBlur = (e, obj, field) => {
    if (obj[field]) {
        e.target.value = formatMoney(obj[field]);
    }
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
