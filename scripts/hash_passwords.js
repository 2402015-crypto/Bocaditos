import bcrypt from 'bcryptjs';
import { DatabaseConfig } from '../config/database.config.js';

async function main() {
  try {
    await DatabaseConfig.authenticate();
    console.log('DB connection OK');

    const [users] = await DatabaseConfig.query("SELECT id_usuario, contrasena FROM usuarios");
    if (!users || users.length === 0) {
      console.log('No users found');
      process.exit(0);
    }

    let updated = 0;
    for (const u of users) {
      const pass = u.contrasena || '';
      if (!pass.startsWith('$2')) { // not bcrypt
        const hash = await bcrypt.hash(pass, 10);
        await DatabaseConfig.query('UPDATE usuarios SET contrasena = ? WHERE id_usuario = ?', {
          replacements: [hash, u.id_usuario],
        });
        console.log(`Updated id=${u.id_usuario}`);
        updated++;
      } else {
        console.log(`Skip id=${u.id_usuario} (already hashed)`);
      }
    }

    console.log(`Done. Total updated: ${updated}`);
    process.exit(0);
  } catch (err) {
    console.error('Error:', err);
    process.exit(1);
  }
}

main();
