-- ============================================
-- Script de Creación de Base de Datos
-- Sistema: Bocaditos - Sistema de Donaciones Alimentarias
-- Versión: 1.0.0
-- Fecha: 2025-11-04
-- Motor: MySQL/MariaDB
-- Basado en: Esquema original del cliente
-- Adaptado para: Una sola escuela
-- ============================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- Crear base de datos
CREATE DATABASE IF NOT EXISTS `bocaditos_db`
    DEFAULT CHARACTER SET utf8mb4
    COLLATE utf8mb4_general_ci;

USE `bocaditos_db`;

-- ============================================
-- TABLA: donador
-- Descripción: Almacena información de donadores
-- ============================================
DROP TABLE IF EXISTS `donador`;
CREATE TABLE `donador` (
    `id_donador` INT NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(60) NOT NULL COMMENT 'Nombre del donador o institución',
    `correo` VARCHAR(150) NOT NULL COMMENT 'Correo electrónico de contacto',
    `celular` VARCHAR(10) NOT NULL COMMENT 'Número de teléfono celular',
    `direccion` VARCHAR(255) NOT NULL COMMENT 'Dirección física del donador',
    PRIMARY KEY (`id_donador`),
    INDEX `idx_donador_nombre` (`nombre`),
    INDEX `idx_donador_correo` (`correo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabla de donadores del sistema';

-- ============================================
-- TABLA: donacion
-- Descripción: Almacena información de donaciones
-- ============================================
DROP TABLE IF EXISTS `donacion`;
CREATE TABLE `donacion` (
    `id_donacion` INT NOT NULL AUTO_INCREMENT,
    `cantidad` INT NOT NULL COMMENT 'Cantidad de alimentos donados',
    `destino` VARCHAR(255) NOT NULL COMMENT 'Destino de la donación',
    `fecha_donacion` DATE NOT NULL COMMENT 'Fecha en que se realizó la donación',
    `id_donador` INT NOT NULL,
    PRIMARY KEY (`id_donacion`),
    INDEX `idx_donacion_donador` (`id_donador`),
    INDEX `idx_donacion_fecha` (`fecha_donacion`),
    CONSTRAINT `fk_donacion_donador` FOREIGN KEY (`id_donador`) 
        REFERENCES `donador` (`id_donador`) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT `chk_cantidad` CHECK (`cantidad` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabla de donaciones realizadas';

-- ============================================
-- TABLA: administrador
-- Descripción: Almacena información de administradores de la escuela
-- ============================================
DROP TABLE IF EXISTS `administrador`;
CREATE TABLE `administrador` (
    `id_admi` INT NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(60) NOT NULL COMMENT 'Nombre completo del administrador',
    `numero` VARCHAR(10) NOT NULL COMMENT 'Número de teléfono',
    `correo` VARCHAR(100) NOT NULL COMMENT 'Correo electrónico',
    PRIMARY KEY (`id_admi`),
    INDEX `idx_administrador_nombre` (`nombre`),
    INDEX `idx_administrador_correo` (`correo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabla de administradores de la escuela';

-- ============================================
-- TABLA: alumno
-- Descripción: Almacena información de alumnos beneficiarios
-- ============================================
DROP TABLE IF EXISTS `alumno`;
CREATE TABLE `alumno` (
    `id_alumno` INT NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(60) NOT NULL COMMENT 'Nombre del alumno',
    `apellido` VARCHAR(60) NOT NULL COMMENT 'Apellido del alumno',
    `grupo` VARCHAR(10) NOT NULL COMMENT 'Grupo al que pertenece',
    `cuatrimestre` VARCHAR(10) NOT NULL COMMENT 'Cuatrimestre actual',
    `matricula` VARCHAR(7) NOT NULL COMMENT 'Matrícula única del alumno',
    PRIMARY KEY (`id_alumno`),
    UNIQUE KEY `uk_alumno_matricula` (`matricula`),
    INDEX `idx_alumno_nombre` (`nombre`, `apellido`),
    INDEX `idx_alumno_grupo` (`grupo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabla de alumnos beneficiarios';

-- ============================================
-- TABLA: comida
-- Descripción: Almacena información de alimentos donados
-- ============================================
DROP TABLE IF EXISTS `comida`;
CREATE TABLE `comida` (
    `id_comida` INT NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(255) NOT NULL COMMENT 'Nombre del producto alimenticio',
    `tipo_comida` VARCHAR(50) NOT NULL COMMENT 'Tipo o categoría del alimento',
    `fecha_caducidad` DATE NOT NULL COMMENT 'Fecha de caducidad del producto',
    `id_donacion` INT NOT NULL,
    PRIMARY KEY (`id_comida`),
    INDEX `idx_comida_nombre` (`nombre`),
    INDEX `idx_comida_tipo` (`tipo_comida`),
    INDEX `idx_comida_fecha_caducidad` (`fecha_caducidad`),
    INDEX `idx_comida_donacion` (`id_donacion`),
    CONSTRAINT `fk_comida_donacion` FOREIGN KEY (`id_donacion`) 
        REFERENCES `donacion` (`id_donacion`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Catálogo de alimentos donados';

-- ============================================
-- TABLA: entrega
-- Descripción: Almacena información de entregas
-- ============================================
DROP TABLE IF EXISTS `entrega`;
CREATE TABLE `entrega` (
    `id_entrega` INT NOT NULL AUTO_INCREMENT,
    `estado` VARCHAR(20) NOT NULL COMMENT 'Estado de la entrega: pendiente, en_proceso, completada, cancelada',
    `fecha_entrega` DATE NOT NULL COMMENT 'Fecha programada o realizada de entrega',
    `id_admin` INT NOT NULL,
    `id_donacion` INT NOT NULL,
    PRIMARY KEY (`id_entrega`),
    INDEX `idx_entrega_fecha` (`fecha_entrega`),
    INDEX `idx_entrega_estado` (`estado`),
    INDEX `idx_entrega_admin` (`id_admin`),
    INDEX `idx_entrega_donacion` (`id_donacion`),
    CONSTRAINT `fk_entrega_administrador` FOREIGN KEY (`id_admin`) 
        REFERENCES `administrador` (`id_admi`) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT `fk_entrega_donacion` FOREIGN KEY (`id_donacion`) 
        REFERENCES `donacion` (`id_donacion`) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT `chk_estado` CHECK (`estado` IN ('pendiente', 'en_proceso', 'completada', 'cancelada'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabla de entregas de donaciones';

-- ============================================
-- VISTAS
-- ============================================

-- Vista: Donaciones con información del donador
CREATE OR REPLACE VIEW `v_donaciones_completas` AS
SELECT 
    d.id_donacion,
    d.cantidad,
    d.destino,
    d.fecha_donacion,
    don.nombre AS donador,
    don.correo AS correo_donador,
    don.celular AS celular_donador,
    don.direccion AS direccion_donador
FROM donacion d
JOIN donador don ON d.id_donador = don.id_donador
ORDER BY d.fecha_donacion DESC;

-- Vista: Entregas con detalles
CREATE OR REPLACE VIEW `v_entregas_detalladas` AS
SELECT 
    e.id_entrega,
    e.estado,
    e.fecha_entrega,
    a.nombre AS administrador,
    a.correo AS correo_admin,
    a.numero AS telefono_admin,
    d.cantidad AS cantidad_donacion,
    d.destino,
    don.nombre AS donador
FROM entrega e
JOIN administrador a ON e.id_admin = a.id_admi
JOIN donacion d ON e.id_donacion = d.id_donacion
JOIN donador don ON d.id_donador = don.id_donador
ORDER BY e.fecha_entrega DESC;

-- Vista: Lista de alumnos
CREATE OR REPLACE VIEW `v_alumnos` AS
SELECT 
    al.id_alumno,
    CONCAT(al.nombre, ' ', al.apellido) AS alumno_completo,
    al.matricula,
    al.grupo,
    al.cuatrimestre
FROM alumno al
ORDER BY al.grupo, al.nombre;

-- Vista: Comidas próximas a caducar (30 días)
CREATE OR REPLACE VIEW `v_comidas_proximas_caducar` AS
SELECT 
    c.id_comida,
    c.nombre,
    c.tipo_comida,
    c.fecha_caducidad,
    DATEDIFF(c.fecha_caducidad, CURDATE()) AS dias_hasta_caducidad,
    d.destino,
    d.cantidad AS cantidad_donacion,
    don.nombre AS donador
FROM comida c
JOIN donacion d ON c.id_donacion = d.id_donacion
JOIN donador don ON d.id_donador = don.id_donador
WHERE c.fecha_caducidad BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 30 DAY)
ORDER BY c.fecha_caducidad ASC;

-- ============================================
-- TRIGGERS
-- ============================================

-- Trigger: Validar fecha de caducidad al insertar comida
DELIMITER $$
CREATE TRIGGER `trg_validar_fecha_caducidad_insert`
BEFORE INSERT ON `comida`
FOR EACH ROW
BEGIN
    IF NEW.fecha_caducidad < CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La fecha de caducidad no puede ser anterior a la fecha actual';
    END IF;
END$$
DELIMITER ;

-- Trigger: Validar fecha de caducidad al actualizar comida
DELIMITER $$
CREATE TRIGGER `trg_validar_fecha_caducidad_update`
BEFORE UPDATE ON `comida`
FOR EACH ROW
BEGIN
    IF NEW.fecha_caducidad < CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La fecha de caducidad no puede ser anterior a la fecha actual';
    END IF;
END$$
DELIMITER ;

SET FOREIGN_KEY_CHECKS = 1;

-- Script completado
SELECT 'Base de datos Bocaditos creada exitosamente' AS mensaje;
