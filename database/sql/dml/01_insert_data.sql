-- ============================================
-- Script de Datos Iniciales
-- Sistema: Bocaditos - Apoyo Alimentario Escolar UTRM
-- Versión: 1.0.0
-- Fecha: 2025-11-04
-- Descripción: Inserta datos de prueba en el sistema
-- ============================================

-- Usar base de datos
\c bocaditos_db;

-- ============================================
-- TUTORES
-- ============================================
INSERT INTO tutor (nombre, apellido, telefono, email, direccion) VALUES
('María', 'González', '0991234567', 'maria.gonzalez@email.com', 'Av. Principal 123, Quito'),
('Carlos', 'Ramírez', '0992345678', 'carlos.ramirez@email.com', 'Calle Secundaria 456, Quito'),
('Ana', 'Pérez', '0993456789', 'ana.perez@email.com', 'Barrio Norte 789, Quito'),
('José', 'Martínez', '0994567890', 'jose.martinez@email.com', 'Sector Sur 321, Quito'),
('Laura', 'Sánchez', '0995678901', 'laura.sanchez@email.com', 'Zona Centro 654, Quito'),
('Pedro', 'López', '0996789012', 'pedro.lopez@email.com', 'Urbanización Este 987, Quito'),
('Carmen', 'Torres', '0997890123', 'carmen.torres@email.com', 'Conjunto Oeste 147, Quito'),
('Miguel', 'Flores', '0998901234', 'miguel.flores@email.com', 'Villa Nueva 258, Quito');

-- ============================================
-- ESTUDIANTES
-- ============================================
INSERT INTO estudiante (nombre, apellido, fecha_nacimiento, grado, id_tutor) VALUES
('Juan', 'González', '2014-03-15', '4to', 1),
('María', 'González', '2016-07-22', '2do', 1),
('Carlos', 'Ramírez', '2013-11-08', '5to', 2),
('Ana', 'Ramírez', '2015-05-30', '3ro', 2),
('Luis', 'Pérez', '2014-09-12', '4to', 3),
('Sofia', 'Martínez', '2015-01-25', '3ro', 4),
('Diego', 'Martínez', '2017-06-18', '1ro', 4),
('Valentina', 'Sánchez', '2013-04-07', '6to', 5),
('Andrés', 'López', '2014-12-03', '4to', 6),
('Isabella', 'Torres', '2016-08-20', '2do', 7),
('Mateo', 'Flores', '2015-10-15', '3ro', 8),
('Camila', 'Flores', '2014-02-28', '5to', 8);

-- ============================================
-- BOCADITOS
-- ============================================
INSERT INTO bocadito (nombre, descripcion, categoria, calorias, precio) VALUES
('Jugo de Naranja Natural', 'Jugo natural de naranja recién exprimido', 'bebida', 120, 1.50),
('Agua Mineral', 'Agua mineral sin gas', 'bebida', 0, 0.75),
('Batido de Fresa', 'Batido de fresa con leche', 'bebida', 200, 2.00),
('Sandwich de Jamón y Queso', 'Pan integral con jamón de pavo y queso', 'sandwich', 350, 2.50),
('Sandwich Vegetariano', 'Pan con vegetales frescos y queso crema', 'sandwich', 280, 2.25),
('Manzana Roja', 'Manzana fresca de temporada', 'fruta', 95, 0.50),
('Plátano', 'Plátano maduro', 'fruta', 105, 0.40),
('Naranja', 'Naranja fresca', 'fruta', 62, 0.45),
('Yogurt con Granola', 'Yogurt natural con granola y miel', 'snack', 180, 1.75),
('Barrita de Cereal', 'Barrita energética de cereal', 'snack', 150, 1.25),
('Galletas Integrales', 'Paquete de galletas integrales', 'snack', 130, 1.00),
('Gelatina de Frutas', 'Gelatina con trozos de frutas', 'postre', 85, 1.00),
('Ensalada de Frutas', 'Mix de frutas frescas de temporada', 'postre', 120, 1.50),
('Arroz con Pollo', 'Porción de arroz con pollo y ensalada', 'plato_principal', 450, 3.50),
('Pasta con Vegetales', 'Pasta integral con vegetales al vapor', 'plato_principal', 380, 3.00);

-- ============================================
-- RESPONSABLES
-- ============================================
INSERT INTO responsable (nombre, apellido, cargo, telefono) VALUES
('Roberto', 'Vásquez', 'coordinador', '0999012345'),
('Patricia', 'Morales', 'asistente', '0990123456'),
('Fernando', 'Castro', 'asistente', '0991234560'),
('Gabriela', 'Ruiz', 'voluntario', '0992345601'),
('Ricardo', 'Herrera', 'supervisor', '0993456012');

-- ============================================
-- MENÚS DIARIOS
-- ============================================
INSERT INTO menu_diario (fecha, descripcion) VALUES
(CURRENT_DATE, 'Menú nutritivo del día con opciones variadas'),
(CURRENT_DATE + INTERVAL '1 day', 'Menú especial con frutas de temporada'),
(CURRENT_DATE + INTERVAL '2 days', 'Menú balanceado con proteínas'),
(CURRENT_DATE + INTERVAL '3 days', 'Menú vegetariano del día'),
(CURRENT_DATE + INTERVAL '4 days', 'Menú completo con plato principal');

-- ============================================
-- MENÚ-BOCADITO (Asociaciones)
-- ============================================
-- Menú del día actual
INSERT INTO menu_bocadito (id_menu, id_bocadito, cantidad_disponible) VALUES
(1, 1, 50),  -- Jugo de Naranja
(1, 4, 40),  -- Sandwich de Jamón
(1, 6, 60),  -- Manzana
(1, 9, 30),  -- Yogurt con Granola
(1, 12, 35); -- Gelatina

-- Menú día +1
INSERT INTO menu_bocadito (id_menu, id_bocadito, cantidad_disponible) VALUES
(2, 2, 50),  -- Agua
(2, 5, 40),  -- Sandwich Vegetariano
(2, 7, 60),  -- Plátano
(2, 8, 60),  -- Naranja
(2, 13, 35); -- Ensalada de Frutas

-- Menú día +2
INSERT INTO menu_bocadito (id_menu, id_bocadito, cantidad_disponible) VALUES
(3, 3, 45),  -- Batido de Fresa
(3, 4, 50),  -- Sandwich de Jamón
(3, 10, 40), -- Barrita de Cereal
(3, 14, 30); -- Arroz con Pollo

-- Menú día +3 (Vegetariano)
INSERT INTO menu_bocadito (id_menu, id_bocadito, cantidad_disponible) VALUES
(4, 1, 50),  -- Jugo de Naranja
(4, 5, 45),  -- Sandwich Vegetariano
(4, 6, 50),  -- Manzana
(4, 11, 40), -- Galletas Integrales
(4, 15, 35); -- Pasta con Vegetales

-- Menú día +4
INSERT INTO menu_bocadito (id_menu, id_bocadito, cantidad_disponible) VALUES
(5, 2, 50),  -- Agua
(5, 4, 45),  -- Sandwich de Jamón
(5, 7, 55),  -- Plátano
(5, 9, 35),  -- Yogurt
(5, 14, 30); -- Arroz con Pollo

-- ============================================
-- PEDIDOS DE PRUEBA
-- ============================================
INSERT INTO pedido (id_estudiante, id_menu, estado, notas) VALUES
(1, 1, 'confirmado', 'Sin cebolla en el sandwich'),
(2, 1, 'confirmado', 'Alergia a frutos secos'),
(3, 1, 'confirmado', NULL),
(4, 2, 'pendiente', NULL),
(5, 2, 'pendiente', NULL),
(6, 1, 'confirmado', NULL),
(7, 2, 'pendiente', 'Primera vez que pide'),
(8, 1, 'entregado', NULL),
(9, 3, 'pendiente', NULL),
(10, 1, 'cancelado', 'Estudiante ausente');

-- ============================================
-- ENTREGAS
-- ============================================
INSERT INTO entrega (id_pedido, fecha_entrega, id_responsable, observaciones) VALUES
(8, CURRENT_TIMESTAMP - INTERVAL '2 hours', 1, 'Entrega sin problemas');

-- ============================================
-- VERIFICACIÓN DE DATOS
-- ============================================

-- Mostrar resumen de datos insertados
SELECT 'Tutores insertados:' AS tipo, COUNT(*) AS cantidad FROM tutor
UNION ALL
SELECT 'Estudiantes insertados:', COUNT(*) FROM estudiante
UNION ALL
SELECT 'Bocaditos insertados:', COUNT(*) FROM bocadito
UNION ALL
SELECT 'Responsables insertados:', COUNT(*) FROM responsable
UNION ALL
SELECT 'Menús creados:', COUNT(*) FROM menu_diario
UNION ALL
SELECT 'Asociaciones menú-bocadito:', COUNT(*) FROM menu_bocadito
UNION ALL
SELECT 'Pedidos creados:', COUNT(*) FROM pedido
UNION ALL
SELECT 'Entregas registradas:', COUNT(*) FROM entrega;

-- Script completado
SELECT 'Datos iniciales insertados exitosamente' AS mensaje;
