import 'bootstrap/dist/css/bootstrap.min.css';
import './login.css';

window.addEventListener('DOMContentLoaded', () => {
    const form = document.getElementById('loginForm') as HTMLFormElement | null;
    const msg = document.getElementById('message');

    if (!form) return;

    form.addEventListener('submit', async (ev) => {
        ev.preventDefault();
        if (!msg) return;
        msg.textContent = '';

        const emailInput = document.getElementById('email') as HTMLInputElement | null;
        const passwordInput = document.getElementById('password') as HTMLInputElement | null;
        if (!emailInput || !passwordInput) return;

        const email = emailInput.value.trim();
        const password = passwordInput.value;

        if (!email || !password) {
            msg.textContent = 'Email y contraseña son requeridos';
            return;
        }

        try {
            const res = await window.http.post('http://localhost:3000/login', { email, password });
            if (!res || !res.ok) {
                const bodyPreview = res && res.body ? (typeof res.body === 'string' ? res.body : JSON.stringify(res.body)) : '';
                msg.textContent = `Error: ${res?.status} ${bodyPreview}`;
                return;
            }

            // El backend debe devolver { user, token }
            const token = res.body && res.body.token;
            if (!token) {
                msg.textContent = 'No se recibió token del servidor';
                return;
            }

            // Guardar token en preload (no en localStorage)
            if (window.auth && typeof window.auth.setToken === 'function') {
                window.auth.setToken(token);
            } else {
                // Fallback para entornos donde preload no exponga auth
                localStorage.setItem('auth_token', token);
            }

            // Ir a la pantalla principal
            await window.appNav.toHome();
        } catch (err) {
            console.error('Login request error', err);
            msg.textContent = 'Error en la petición: ' + (err && err.message ? err.message : String(err));
        }
    });
});