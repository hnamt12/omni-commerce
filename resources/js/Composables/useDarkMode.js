import { ref, onMounted, onUnmounted } from 'vue';

export function useDarkMode() {
    const isDark = ref(false);

    const applyTheme = (dark) => {
        isDark.value = dark;
        if (dark) {
            document.documentElement.classList.add('dark');
            localStorage.setItem('theme', 'dark');
        } else {
            document.documentElement.classList.remove('dark');
            localStorage.setItem('theme', 'light');
        }
    };

    const toggleDarkMode = () => applyTheme(!isDark.value);

    // Watch system preference changes
    let mediaQuery = null;
    const onSystemChange = (e) => {
        if (!('theme' in localStorage)) applyTheme(e.matches);
    };

    onMounted(() => {
        const prefersDark = window.matchMedia('(prefers-color-scheme: dark)');
        if (localStorage.theme === 'dark' || (!('theme' in localStorage) && prefersDark.matches)) {
            applyTheme(true);
        } else {
            applyTheme(false);
        }
        mediaQuery = prefersDark;
        mediaQuery.addEventListener('change', onSystemChange);
    });

    onUnmounted(() => {
        mediaQuery?.removeEventListener('change', onSystemChange);
    });

    return { isDark, toggleDarkMode };
}
