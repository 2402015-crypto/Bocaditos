-- Create database and application user for Bocaditos
-- Usage (in shell): mysql -u root -p < scripts/create_db_user.sql

CREATE DATABASE IF NOT EXISTS `bocaditos_db` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Create application user and grant privileges (change password before use)
CREATE USER IF NOT EXISTS 'bocaditos_user'@'localhost' IDENTIFIED BY 'strong_password';
GRANT ALL PRIVILEGES ON `bocaditos_db`.* TO 'bocaditos_user'@'localhost';
FLUSH PRIVILEGES;

-- Optional: if you run into authentication plugin issues, uncomment and run:
-- ALTER USER 'bocaditos_user'@'localhost' IDENTIFIED WITH mysql_native_password BY 'strong_password';
-- FLUSH PRIVILEGES;

-- Verify:
-- SHOW DATABASES LIKE 'bocaditos_db';
-- SHOW GRANTS FOR 'bocaditos_user'@'localhost';
