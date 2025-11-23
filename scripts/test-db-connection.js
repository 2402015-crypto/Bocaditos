import { Database } from '../config/database.config.js';

(async () => {
  const db = new Database();
  const result = await db.connection();
  // Imprimir resultado legible
  console.log('Resultado del test de conexión:', result);
  process.exit(result.ok ? 0 : 1);
})();
