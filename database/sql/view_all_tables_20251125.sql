-- Queries to inspect all tables and key views (development)
USE `bocadito_db`;

-- Simple counts
SELECT 'tipos_productos' AS table_name, COUNT(*) AS rows FROM tipos_productos;
SELECT 'productos' AS table_name, COUNT(*) AS rows FROM productos;
SELECT 'estados_entregas' AS table_name, COUNT(*) AS rows FROM estados_entregas;
SELECT 'estados' AS table_name, COUNT(*) AS rows FROM estados;
SELECT 'ciudades' AS table_name, COUNT(*) AS rows FROM ciudades;
SELECT 'ubicaciones' AS table_name, COUNT(*) AS rows FROM ubicaciones;
SELECT 'escuelas' AS table_name, COUNT(*) AS rows FROM escuelas;
SELECT 'usuarios' AS table_name, COUNT(*) AS rows FROM usuarios;
SELECT 'donadores' AS table_name, COUNT(*) AS rows FROM donadores;
SELECT 'stocks' AS table_name, COUNT(*) AS rows FROM stocks;
SELECT 'paquetes' AS table_name, COUNT(*) AS rows FROM paquetes;
SELECT 'paquetes_stock' AS table_name, COUNT(*) AS rows FROM paquetes_stock;
SELECT 'donaciones' AS table_name, COUNT(*) AS rows FROM donaciones;
SELECT 'detalle_donaciones' AS table_name, COUNT(*) AS rows FROM detalle_donaciones;
SELECT 'entregas' AS table_name, COUNT(*) AS rows FROM entregas;
SELECT 'conversaciones' AS table_name, COUNT(*) AS rows FROM conversaciones;
SELECT 'mensajes' AS table_name, COUNT(*) AS rows FROM mensajes;

-- Quick selects (small samples)
SELECT * FROM tipos_productos LIMIT 50;
SELECT * FROM productos LIMIT 50;
SELECT * FROM estados_entregas LIMIT 50;
SELECT * FROM estados LIMIT 50;
SELECT * FROM ciudades LIMIT 50;
SELECT * FROM ubicaciones LIMIT 50;
SELECT * FROM escuelas LIMIT 50;
SELECT id_usuario, nombre, apellido, correo, id_rol FROM usuarios LIMIT 50;
SELECT * FROM donadores LIMIT 50;
SELECT * FROM stocks LIMIT 50;
SELECT * FROM vw_stock_disponible LIMIT 50;
SELECT p.id_paquete, p.nombre, ps.id_stock, ps.cantidad FROM paquetes p JOIN paquetes_stock ps USING(id_paquete) LIMIT 50;
SELECT d.id_donacion, d.id_donador, dd.id_producto, dd.cantidad FROM donaciones d JOIN detalle_donaciones dd USING(id_donacion) LIMIT 50;
SELECT e.* FROM entregas e LIMIT 50;
SELECT c.* FROM conversaciones c LIMIT 50;
SELECT m.* FROM mensajes m LIMIT 50;

-- Useful joins
-- Inventory with product and school
SELECT s.id_stock, pr.nombre AS producto, sc.nombre AS escuela, s.cantidad_entrada, s.cantidad_salida, (IFNULL(s.cantidad_entrada,0)-IFNULL(s.cantidad_salida,0)) AS disponible
FROM stocks s
JOIN productos pr ON s.id_producto = pr.id_producto
JOIN escuelas sc ON s.id_escuela = sc.id_escuela
LIMIT 100;

-- Paquete contents and available stock
SELECT pa.id_paquete, pa.nombre AS paquete_nombre, pr.nombre AS producto, ps.cantidad AS cantidad_en_paquete, ws.cantidad_disponible
FROM paquetes pa
JOIN paquetes_stock ps ON pa.id_paquete = ps.id_paquete
JOIN stocks s ON ps.id_stock = s.id_stock
JOIN productos pr ON s.id_producto = pr.id_producto
LEFT JOIN vw_stock_disponible ws ON ws.id_producto = pr.id_producto AND ws.id_escuela = s.id_escuela
LIMIT 100;

-- End of inspection queries
