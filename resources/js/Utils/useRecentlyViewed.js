/**
 * useRecentlyViewed composable
 * Stores and retrieves recently viewed product IDs in localStorage.
 */
export function useRecentlyViewed() {
    const STORAGE_KEY = 'recently_viewed_products';
    const MAX_COUNT   = 15;

    const getProducts = () => {
        try {
            const data = localStorage.getItem(STORAGE_KEY);
            return data ? JSON.parse(data) : [];
        } catch {
            return [];
        }
    };

    const addProduct = (productId) => {
        const ids = getProducts();
        // Remove if already present so we can re-insert at front (most-recent first)
        const filtered = ids.filter(id => id !== productId);
        filtered.unshift(productId);
        if (filtered.length > MAX_COUNT) filtered.pop();
        localStorage.setItem(STORAGE_KEY, JSON.stringify(filtered));
    };

    const clearProducts = () => localStorage.removeItem(STORAGE_KEY);

    return { addProduct, getProducts, clearProducts };
}
