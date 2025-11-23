import { Sequelize } from 'sequelize';

const {
    DB_HOST = 'localhost',
    DB_NAME = 'bocaditos_db',
    DB_USER = 'root',
    DB_PASS = '',
    DB_PORT = '3306',
    DB_DIALECT = 'mysql',
    DB_TIMEZONE = '-05:00',
    DB_LOGGING = 'false',
} = process.env;

const pool = {
    max: 5,
    min: 0,
    acquire: 60000,
    idle: 15000,
};

export const DatabaseConfig = new Sequelize(DB_NAME, DB_USER, DB_PASS, {
    host: DB_HOST,
    port: Number(DB_PORT),
    dialect: DB_DIALECT,
    timezone: DB_TIMEZONE,
    logging: DB_LOGGING === 'true' ? console.log : false,
    pool,
});

export class Database {
    /**
     * Start the database connection
     * @returns {Promise<{ok: boolean, message: string}>}
     */
    async connection() {
        try {
            await DatabaseConfig.authenticate();
            console.log('Connection has been established successfully.');
            return { ok: true, message: 'Connection to the database established correctly' };
        } catch (error) {
            console.error('Unable to connect to the database:', error);
            return { ok: false, message: `Could not connect to the database. Please check the following: ${error}` };
        }
    }
}