import { DatabaseConfig } from '../../config/database.config.js';

export class HealthRoute {
  constructor(app) {
    this.app = app;
  }

  initHealthRoutes() {
    this.app.get('/health', async (req, res) => {
      try {
        await DatabaseConfig.authenticate();
        return res.json({ db: 'ok', message: 'Database connection OK' });
      } catch (error) {
        console.error('Health check DB error:', error);
        return res.status(503).json({ db: 'error', message: error.message || String(error) });
      }
    });
  }
}
