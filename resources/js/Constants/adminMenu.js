/**
 * Admin sidebar navigation groups.
 * Each item: { name, route, icon (SVG path d=""), permission?, badge? }
 * permission: null  → visible to all authenticated users
 * permission: string → requires that permission (or admin role)
 */
export const adminMenuGroups = [
    {
        name: 'Tổng quan',
        items: [
            {
                name: 'Dashboard',
                route: 'dashboard',
                icon: 'M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6',
                permission: null,
            },
            {
                name: 'Báo cáo Analytics',
                route: '#',
                icon: 'M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z',
                permission: 'view_analytics',
            },
        ],
    },
    {
        name: 'Cửa hàng',
        items: [
            {
                name: 'Tất cả sản phẩm',
                route: 'admin.products.index',
                icon: 'M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10',
                permission: 'manage_products',
            },
            {
                name: 'Danh mục',
                route: 'admin.categories.index',
                icon: 'M4 6h16M4 10h16M4 14h16M4 18h16',
                permission: 'manage_products',
            },
            {
                name: 'Thương hiệu',
                route: 'admin.brands.index',
                icon: 'M7 7h.01M7 3h5c.512 0 1.024.195 1.414.586l7 7a2 2 0 010 2.828l-7 7a2 2 0 01-2.828 0l-7-7A1.994 1.994 0 013 12V7a4 4 0 014-4z',
                permission: 'manage_products',
            },
            {
                name: 'Thuộc tính',
                route: 'admin.attributes.index',
                icon: 'M10 20l4-16m4 4l4 4-4 4M6 16l-4-4 4-4',
                permission: 'manage_products',
            },
            {
                name: 'Quản lý kho',
                route: 'admin.inventory.index',
                icon: 'M5 8h14M5 8a2 2 0 110-4h14a2 2 0 110 4M5 8v10a2 2 0 002 2h10a2 2 0 002-2V8m-9 4h4',
                permission: 'manage_products',
            },
            {
                name: 'Tin tức / Blog',
                route: 'admin.posts.index',
                icon: 'M19 20H5a2 2 0 01-2-2V6a2 2 0 012-2h10a2 2 0 012 2v1m2 13a2 2 0 01-2-2V7m2 13a2 2 0 002-2V9a2 2 0 00-2-2h-2m-4-3H9M7 16h6M7 8h6v4H7V8z',
                permission: 'manage_products',
            },
        ],
    },
    {
        name: 'Bán hàng',
        items: [
            {
                name: 'Đơn hàng',
                route: 'admin.orders.index',
                icon: 'M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z',
                permission: 'manage_orders',
            },
            {
                name: 'Voucher',
                route: 'admin.vouchers.index',
                icon: 'M15 5v2m0 4v2m0 4v2M5 5a2 2 0 00-2 2v3a2 2 0 110 4v3a2 2 0 002 2h14a2 2 0 002-2v-3a2 2 0 110-4V7a2 2 0 00-2-2H5z',
                permission: 'manage_orders',
            },
            {
                name: 'Yêu cầu hủy',
                route: 'admin.cancel-requests.index',
                icon: 'M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z',
                permission: 'manage_orders',
            },
            {
                name: 'Flash Sale',
                route: 'admin.flash-sales.index',
                icon: 'M13 10V3L4 14h7v7l9-11h-7z',
                permission: 'manage_orders',
            },
        ],
    },
    {
        name: 'Khách hàng',
        items: [
            {
                name: 'Danh sách',
                route: '#',
                icon: 'M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z',
                permission: 'manage_users',
            },
        ],
    },
    {
        name: 'Thùng rác',
        items: [
            {
                name: 'Sản phẩm đã xóa',
                route: '#',
                icon: 'M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16',
                permission: 'manage_products',
            },
            {
                name: 'Danh mục đã xóa',
                route: 'admin.categories.trashed',
                icon: 'M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16',
                permission: 'manage_products',
            },
            {
                name: 'Thương hiệu đã xóa',
                route: 'admin.brands.trashed',
                icon: 'M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16',
                permission: 'manage_products',
            },
            {
                name: 'Thuộc tính đã xóa',
                route: 'admin.attributes.trashed',
                icon: 'M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16',
                permission: 'manage_products',
            },
        ],
    },
    {
        name: 'Hệ thống',
        items: [
            {
                name: 'Quản lý Banner',
                route: 'admin.banners.index',
                icon: 'M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z',
                permission: 'manage_settings',
            },
            {
                name: 'Cấu hình Vị trí',
                route: 'admin.banner-locations.index',
                icon: 'M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 002-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10',
                permission: 'manage_settings',
            },
            {
                name: 'Live Chat',
                route: '#',
                badge: '3',
                icon: 'M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z',
                permission: 'manage_settings',
            },
            {
                name: 'Quản lý Nhân sự',
                route: 'admin.staff.index',
                icon: 'M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z',
                permission: 'manage_users',
            },
            {
                name: 'Cấu hình Thanh toán',
                route: 'admin.payment-methods.index',
                icon: 'M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z',
                permission: 'manage_settings',
            },
            {
                name: 'Cài đặt',
                route: '#',
                icon: 'M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z',
                permission: 'manage_settings',
            },
            {
                name: 'Cấu hình liên hệ',
                // Dùng mã SVG Path hình "Quyển sổ danh bạ/Điện thoại" chuẩn Tailwind/Heroicons
                icon: 'M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z',
                route: 'admin.settings.index',
                permission: 'manage_settings2',
            },
        ],
    },
];
