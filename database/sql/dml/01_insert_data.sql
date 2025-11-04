-- ============================================
-- Script de Datos Iniciales
-- Sistema: Bocaditos - Sistema de Donaciones Alimentarias
-- Versión: 1.0.0
-- Fecha: 2025-11-04
-- Descripción: Inserta datos de prueba en el sistema
-- ============================================

-- Usar base de datos
\c bocaditos_db;

-- ============================================
-- DONADORES
-- ============================================
INSERT INTO donador (id_donador, nombre, correo, celular, direccion) VALUES
(1, 'Fundación Alimentos Para Todos', 'contacto@alimentosparatodos.org', '5551234567', 'Av. Reforma 123, Ciudad de México'),
(2, 'Banco de Alimentos Regional', 'info@bancoalimentos.mx', '5552345678', 'Calle Juárez 456, Guadalajara'),
(3, 'Comercial La Despensa S.A.', 'donaciones@ladespensa.com.mx', '5553456789', 'Blvd. Insurgentes 789, Monterrey'),
(4, 'Supermercados Unidos', 'responsabilidad@superunidos.mx', '5554567890', 'Av. Universidad 321, Puebla'),
(5, 'Asociación de Productores Locales', 'contacto@productoreslocales.org', '5555678901', 'Carretera Nacional Km 15, Querétaro');

-- ============================================
-- DONACIONES
-- ============================================
INSERT INTO donacion (id_donacion, cantidad, destino, fecha_donacion, id_donador) VALUES
(1, 500, 'Escuela Primaria Benito Juárez', '2025-10-15', 1),
(2, 300, 'Escuela Secundaria Técnica 25', '2025-10-20', 2),
(3, 750, 'Universidad Técnica Regional Metropolitana', '2025-10-25', 3),
(4, 400, 'Escuela Primaria Miguel Hidalgo', '2025-11-01', 4),
(5, 600, 'Universidad Técnica Regional Metropolitana', '2025-11-03', 5);

-- ============================================
-- ESCUELAS
-- ============================================
INSERT INTO escuela (id_escuela, nombre, ubicacion, id_donacion) VALUES
(1, 'Escuela Primaria Benito Juárez', 'Calle Morelos 45, Col. Centro', 1),
(2, 'Escuela Secundaria Técnica 25', 'Av. Tecnológico 890, Col. Industrial', 2),
(3, 'Universidad Técnica Regional Metropolitana', 'Blvd. Universitario 1500, Campus Norte', 3);

-- ============================================
-- ADMINISTRADORES
-- ============================================
INSERT INTO administrador (id_admi, nombre, numero, correo, id_escuela) VALUES
(1, 'María López Hernández', '5556789012', 'maria.lopez@primaria-juarez.edu.mx', 1),
(2, 'Carlos Ramírez García', '5557890123', 'carlos.ramirez@secundaria25.edu.mx', 2),
(3, 'Ana Martínez Sánchez', '5558901234', 'ana.martinez@utrm.edu.mx', 3),
(4, 'José González Torres', '5559012345', 'jose.gonzalez@primaria-juarez.edu.mx', 1),
(5, 'Laura Pérez Domínguez', '5550123456', 'laura.perez@utrm.edu.mx', 3);

-- ============================================
-- ALUMNOS
-- ============================================
INSERT INTO alumno (id_alumno, nombre, apellido, grupo, cuatrimestre, matricula, id_escuela) VALUES
(1, 'Juan', 'Pérez López', 'A', '1ro', '2025001', 1),
(2, 'María', 'García Martínez', 'A', '1ro', '2025002', 1),
(3, 'Carlos', 'Rodríguez Sánchez', 'B', '2do', '2025003', 1),
(4, 'Ana', 'Hernández Flores', 'B', '2do', '2025004', 1),
(5, 'Luis', 'Martínez Ramírez', 'A', '1ro', '2024001', 2),
(6, 'Sofia', 'López García', 'B', '2do', '2024002', 2),
(7, 'Diego', 'Sánchez Torres', 'C', '3ro', '2024003', 2),
(8, 'Valentina', 'Torres Díaz', 'A', '1ro', '2023001', 3),
(9, 'Andrés', 'Díaz Morales', 'B', '2do', '2023002', 3),
(10, 'Isabella', 'Morales Castro', 'A', '3ro', '2023003', 3),
(11, 'Mateo', 'Castro Ruiz', 'C', '4to', '2023004', 3),
(12, 'Camila', 'Ruiz Herrera', 'B', '5to', '2023005', 3);

-- ============================================
-- COMIDAS
-- ============================================
INSERT INTO comida (id_comida, nombre, tipo_comida, fecha_caducidad, id_donacion) VALUES
(1, 'Arroz Integral 1kg', 'Granos', '2026-03-15', 1),
(2, 'Frijoles Negros 1kg', 'Legumbres', '2026-03-15', 1),
(3, 'Aceite Vegetal 1L', 'Aceites', '2025-12-31', 1),
(4, 'Leche en Polvo 500g', 'Lácteos', '2026-02-28', 2),
(5, 'Avena en Hojuelas 500g', 'Cereales', '2026-01-31', 2),
(6, 'Atún en Lata 170g', 'Conservas', '2026-06-30', 3),
(7, 'Sardinas en Lata 125g', 'Conservas', '2026-06-30', 3),
(8, 'Pasta Integral 500g', 'Pastas', '2026-04-30', 3),
(9, 'Salsa de Tomate 500ml', 'Salsas', '2025-12-15', 4),
(10, 'Galletas Integrales 200g', 'Snacks', '2025-12-01', 4),
(11, 'Jugos de Fruta 1L', 'Bebidas', '2025-11-30', 5),
(12, 'Manzanas Frescas', 'Frutas', '2025-11-15', 5),
(13, 'Plátanos', 'Frutas', '2025-11-12', 5),
(14, 'Naranjas', 'Frutas', '2025-11-20', 5),
(15, 'Yogurt Natural 1L', 'Lácteos', '2025-11-25', 2);

-- ============================================
-- ENTREGAS
-- ============================================
INSERT INTO entrega (id_entrega, estado, fecha_entrega, id_admin, id_donacion) VALUES
(1, 'completada', '2025-10-16', 1, 1),
(2, 'completada', '2025-10-22', 2, 2),
(3, 'en_proceso', '2025-10-26', 3, 3),
(4, 'pendiente', '2025-11-02', 4, 4),
(5, 'pendiente', '2025-11-04', 5, 5);

-- ============================================
-- VERIFICACIÓN DE DATOS
-- ============================================

-- Mostrar resumen de datos insertados
SELECT 'Donadores insertados:' AS tipo, COUNT(*) AS cantidad FROM donador
UNION ALL
SELECT 'Donaciones registradas:', COUNT(*) FROM donacion
UNION ALL
SELECT 'Escuelas registradas:', COUNT(*) FROM escuela
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
