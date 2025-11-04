-- ============================================
-- Script de Datos Iniciales
-- Sistema: Bocaditos - Sistema de Donaciones Alimentarias
-- Versión: 1.0.0
-- Fecha: 2025-11-04
-- Motor: MySQL/MariaDB
-- Descripción: Inserta datos de prueba para una escuela
-- ============================================

USE `bocaditos_db`;

SET FOREIGN_KEY_CHECKS = 0;

-- ============================================
-- DONADORES
-- ============================================
INSERT INTO `donador` (`nombre`, `correo`, `celular`, `direccion`) VALUES
('Fundación Alimentos Para Todos', 'contacto@alimentosparatodos.org', '5551234567', 'Av. Reforma 123, Ciudad de México'),
('Banco de Alimentos Regional', 'info@bancoalimentos.mx', '5552345678', 'Calle Juárez 456, Guadalajara'),
('Comercial La Despensa S.A.', 'donaciones@ladespensa.com.mx', '5553456789', 'Blvd. Insurgentes 789, Monterrey'),
('Supermercados Unidos', 'responsabilidad@superunidos.mx', '5554567890', 'Av. Universidad 321, Puebla'),
('Asociación de Productores Locales', 'contacto@productoreslocales.org', '5555678901', 'Carretera Nacional Km 15, Querétaro');

-- ============================================
-- DONACIONES
-- ============================================
INSERT INTO `donacion` (`cantidad`, `destino`, `fecha_donacion`, `id_donador`) VALUES
(500, 'Universidad Técnica Regional Metropolitana', '2025-10-15', 1),
(300, 'Universidad Técnica Regional Metropolitana', '2025-10-20', 2),
(750, 'Universidad Técnica Regional Metropolitana', '2025-10-25', 3),
(400, 'Universidad Técnica Regional Metropolitana', '2025-11-01', 4),
(600, 'Universidad Técnica Regional Metropolitana', '2025-11-03', 5);

-- ============================================
-- ADMINISTRADORES
-- ============================================
INSERT INTO `administrador` (`nombre`, `numero`, `correo`) VALUES
('Ana Martínez Sánchez', '5558901234', 'ana.martinez@utrm.edu.mx'),
('Laura Pérez Domínguez', '5550123456', 'laura.perez@utrm.edu.mx'),
('Carlos Gómez Rivera', '5559012345', 'carlos.gomez@utrm.edu.mx'),
('María González Torres', '5557890123', 'maria.gonzalez@utrm.edu.mx'),
('Roberto Hernández López', '5556789012', 'roberto.hernandez@utrm.edu.mx');

-- ============================================
-- ALUMNOS
-- ============================================
INSERT INTO `alumno` (`nombre`, `apellido`, `grupo`, `cuatrimestre`, `matricula`) VALUES
('Valentina', 'Torres Díaz', 'A', '1ro', '2023001'),
('Andrés', 'Díaz Morales', 'B', '2do', '2023002'),
('Isabella', 'Morales Castro', 'A', '3ro', '2023003'),
('Mateo', 'Castro Ruiz', 'C', '4to', '2023004'),
('Camila', 'Ruiz Herrera', 'B', '5to', '2023005'),
('Santiago', 'Herrera Vega', 'A', '6to', '2023006'),
('Sofía', 'Vega Mendoza', 'C', '1ro', '2023007'),
('Lucas', 'Mendoza Silva', 'B', '2do', '2023008'),
('Emma', 'Silva Rojas', 'A', '3ro', '2023009'),
('Sebastián', 'Rojas Ortiz', 'C', '4to', '2023010'),
('Martina', 'Ortiz Ramos', 'B', '5to', '2023011'),
('Diego', 'Ramos Flores', 'A', '6to', '2023012');

-- ============================================
-- COMIDAS
-- ============================================
INSERT INTO `comida` (`nombre`, `tipo_comida`, `fecha_caducidad`, `id_donacion`) VALUES
('Arroz Integral 1kg', 'Granos', '2026-03-15', 1),
('Frijoles Negros 1kg', 'Legumbres', '2026-03-15', 1),
('Aceite Vegetal 1L', 'Aceites', '2025-12-31', 1),
('Leche en Polvo 500g', 'Lácteos', '2026-02-28', 2),
('Avena en Hojuelas 500g', 'Cereales', '2026-01-31', 2),
('Atún en Lata 170g', 'Conservas', '2026-06-30', 3),
('Sardinas en Lata 125g', 'Conservas', '2026-06-30', 3),
('Pasta Integral 500g', 'Pastas', '2026-04-30', 3),
('Salsa de Tomate 500ml', 'Salsas', '2025-12-15', 4),
('Galletas Integrales 200g', 'Snacks', '2025-12-01', 4),
('Jugos de Fruta 1L', 'Bebidas', '2025-11-30', 5),
('Manzanas Frescas', 'Frutas', '2025-11-15', 5),
('Plátanos', 'Frutas', '2025-11-12', 5),
('Naranjas', 'Frutas', '2025-11-20', 5),
('Yogurt Natural 1L', 'Lácteos', '2025-11-25', 2);

-- ============================================
-- ENTREGAS
-- ============================================
INSERT INTO `entrega` (`estado`, `fecha_entrega`, `id_admin`, `id_donacion`) VALUES
('completada', '2025-10-16', 1, 1),
('completada', '2025-10-22', 2, 2),
('en_proceso', '2025-10-26', 3, 3),
('pendiente', '2025-11-02', 4, 4),
('pendiente', '2025-11-04', 5, 5);

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================
-- VERIFICACIÓN DE DATOS
-- ============================================

-- Mostrar resumen de datos insertados
SELECT 'Donadores insertados:' AS tipo, COUNT(*) AS cantidad FROM donador
UNION ALL
SELECT 'Donaciones registradas:', COUNT(*) FROM donacion
UNION ALL
SELECT 'Administradores insertados:', COUNT(*) FROM administrador
UNION ALL
SELECT 'Alumnos insertados:', COUNT(*) FROM alumno
UNION ALL
SELECT 'Alimentos registrados:', COUNT(*) FROM comida
UNION ALL
SELECT 'Entregas registradas:', COUNT(*) FROM entrega;

-- Script completado
SELECT 'Datos iniciales insertados exitosamente' AS mensaje;
