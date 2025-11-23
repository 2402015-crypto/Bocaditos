import 'bootstrap/dist/css/bootstrap.min.css';

window.addEventListener('DOMContentLoaded', async () => {
    const logoutBtn = document.getElementById('logoutBtn');
    const userInfo = document.getElementById('userInfo');

    if (userInfo) {
        // Mostrar información básica del usuario si está en el token (opcional)
        try {
            const token = (window.auth && typeof window.auth.getToken === 'function') ? window.auth.getToken() : localStorage.getItem('auth_token');
            if (token) {
                // Decodificar payload base64 (sin verificar) para mostrar email si existe
                const parts = token.split('.');
                if (parts.length >= 2) {
                    const payload = JSON.parse(decodeURIComponent(escape(atob(parts[1].replace(/-/g, '+').replace(/_/g, '/')))));
                    userInfo.textContent = `Conectado como: ${payload.email || payload.id || 'usuario'}`;
                }
            }
        } catch (e) {
            userInfo.textContent = '';
        }
    }

    if (logoutBtn) {
        logoutBtn.addEventListener('click', async () => {
            // Clear token from preload memory and localStorage fallback
            if (window.auth && typeof window.auth.clearToken === 'function') {
                window.auth.clearToken();
            }
            localStorage.removeItem('auth_token');
            await window.appNav.toLogin();
        });
    }
});