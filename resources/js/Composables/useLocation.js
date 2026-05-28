import { ref } from 'vue';

export function useLocation() {
    const provinces = ref([]);
    const districts = ref([]);
    const wards     = ref([]);

    const fetchProvinces = async () => {
        try {
            const response = await fetch('https://esgoo.net/api-tinhthanh/1/0.htm');
            const result   = await response.json();
            if (result.error === 0) provinces.value = result.data;
        } catch (e) { console.error('Lỗi load Tỉnh:', e); }
    };

    const fetchDistricts = async (provinceId) => {
        districts.value = [];
        wards.value     = [];
        if (!provinceId) return;
        try {
            const response = await fetch(`https://esgoo.net/api-tinhthanh/2/${provinceId}.htm`);
            const result   = await response.json();
            if (result.error === 0) districts.value = result.data;
        } catch (e) { console.error('Lỗi load Huyện:', e); }
    };

    const fetchWards = async (districtId) => {
        wards.value = [];
        if (!districtId) return;
        try {
            const response = await fetch(`https://esgoo.net/api-tinhthanh/3/${districtId}.htm`);
            const result   = await response.json();
            if (result.error === 0) wards.value = result.data;
        } catch (e) { console.error('Lỗi load Xã:', e); }
    };

    return { provinces, districts, wards, fetchProvinces, fetchDistricts, fetchWards };
}
