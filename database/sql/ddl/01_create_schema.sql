-- ============================================
-- Script de Creación de Base de Datos
-- Sistema: Bocaditos - Sistema de Donaciones Alimentarias
-- Versión: 1.0.3
-- Fecha: 2025-11-04
-- Motor: MySQL/MariaDB
-- ============================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- Crear base de datos
CREATE DATABASE IF NOT EXISTS `bocaditos_db`
    DEFAULT CHARACTER SET utf8mb4
    COLLATE utf8mb4_general_ci;

USE `bocaditos_db`;
SET FOREIGN_KEY_CHECKS = 0;

-- ========================
-- Tabla: estado
-- ========================
CREATE TABLE estado (
  id_estado INT AUTO_INCREMENT PRIMARY KEY,
  nombre_estado VARCHAR(100) NOT NULL UNIQUE
);

-- ========================
-- Tabla: ciudad
-- ========================
CREATE TABLE ciudad (
  id_ciudad INT AUTO_INCREMENT PRIMARY KEY,
  nombre_ciudad VARCHAR(100) NOT NULL,
  id_estado INT NOT NULL,
  FOREIGN KEY (id_estado) REFERENCES estado(id_estado)
);

-- ========================
-- Tabla: ubicacion
-- ========================
CREATE TABLE ubicacion (
  id_ubicacion INT AUTO_INCREMENT PRIMARY KEY,
  direccion VARCHAR(255),
  codigo_postal VARCHAR(10),
  id_ciudad INT NOT NULL,
  FOREIGN KEY (id_ciudad) REFERENCES ciudad(id_ciudad)
);

-- ========================
-- Tabla: escuela
-- ========================
CREATE TABLE escuela (
  id_escuela INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  id_ubicacion INT,
  FOREIGN KEY (id_ubicacion) REFERENCES ubicacion(id_ubicacion)
);

-- ========================
-- Tabla: rol
-- ========================
CREATE TABLE rol (
  id_rol INT AUTO_INCREMENT PRIMARY KEY,
  nombre_rol ENUM('alumno','donador','administrador') NOT NULL
);

-- ========================
-- Tabla: usuario
-- ========================
CREATE TABLE usuario (
  id_usuario INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  apellido VARCHAR(100),
  telefono VARCHAR(15),
  matricula VARCHAR(10),
  cuatrimestre VARCHAR(10),
  correo VARCHAR(150) UNIQUE,
  contrasena VARCHAR(255),
  id_rol INT,
  id_escuela INT,
  id_ubicacion INT,
  FOREIGN KEY (id_rol) REFERENCES rol(id_rol),
  FOREIGN KEY (id_escuela) REFERENCES escuela(id_escuela),
  FOREIGN KEY (id_ubicacion) REFERENCES ubicacion(id_ubicacion)
);

-- ========================
-- Tabla: administrador
-- ========================
CREATE TABLE administrador (
  id_admin INT AUTO_INCREMENT PRIMARY KEY,
  id_usuario INT NOT NULL UNIQUE,
  fecha_asignacion DATE DEFAULT CURRENT_DATE,
  FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

-- ========================
-- Tabla: alergia
-- ========================
CREATE TABLE alergia (
  id_alergia INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  tipo VARCHAR(100)
);

-- ========================
-- Tabla pivote: usuario_alergia
-- ========================
CREATE TABLE usuario_alergia (
  id_usuario INT,
  id_alergia INT,
  PRIMARY KEY (id_usuario, id_alergia),
  FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
  FOREIGN KEY (id_alergia) REFERENCES alergia(id_alergia)
);

-- ========================
-- Tabla: producto
-- ========================
CREATE TABLE producto (
  id_producto INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  tipo_producto VARCHAR(100) NOT NULL
);

-- ========================
-- Tabla: stock (por escuela)
-- ========================
CREATE TABLE stock (
  id_stock INT AUTO_INCREMENT PRIMARY KEY,
  id_producto INT NOT NULL,
  id_escuela INT NOT NULL,
  cantidad_disponible INT DEFAULT 0,
  fecha_actualizacion DATE DEFAULT CURRENT_DATE,
  FOREIGN KEY (id_producto) REFERENCES producto(id_producto),
  FOREIGN KEY (id_escuela) REFERENCES escuela(id_escuela)
);

-- ========================
-- Tabla: detalle_donacion
-- ========================
CREATE TABLE detalle_donacion (
  id_detalle_donacion INT AUTO_INCREMENT PRIMARY KEY,
  cantidad INT CHECK (cantidad > 0),
  fecha_caducidad DATE NOT NULL,
  id_stock INT NOT NULL,
  FOREIGN KEY (id_stock) REFERENCES stock(id_stock)
);

-- ========================
-- Tabla: donador
-- ========================
CREATE TABLE donador (
  id_donador INT AUTO_INCREMENT PRIMARY KEY,
  id_usuario INT NOT NULL,
  FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

-- ========================
-- Tabla: donacion
-- ========================
CREATE TABLE donacion (
  id_donacion INT AUTO_INCREMENT PRIMARY KEY,
  id_donador INT NOT NULL,
  id_escuela INT NOT NULL,
  id_detalle_donacion INT NOT NULL,
  fecha_donacion DATE NOT NULL DEFAULT CURRENT_DATE,
  FOREIGN KEY (id_donador) REFERENCES donador(id_donador),
  FOREIGN KEY (id_escuela) REFERENCES escuela(id_escuela),
  FOREIGN KEY (id_detalle_donacion) REFERENCES detalle_donacion(id_detalle_donacion)
);

-- ========================
-- Tabla: paquete
-- ========================
CREATE TABLE paquete (
  id_paquete INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  descripcion TEXT,
  fecha_creacion DATE NOT NULL DEFAULT CURRENT_DATE,
  id_admin INT NOT NULL,
  FOREIGN KEY (id_admin) REFERENCES administrador(id_admin)
);

-- ========================
-- Tabla pivote: paquete_stock
-- ========================
CREATE TABLE paquete_stock (
  id_paquete INT,
  id_stock INT,
  cantidad INT CHECK (cantidad > 0),
  PRIMARY KEY (id_paquete, id_stock),
  FOREIGN KEY (id_paquete) REFERENCES paquete(id_paquete),
  FOREIGN KEY (id_stock) REFERENCES stock(id_stock)
);

-- ========================
-- Tabla: entrega (paquete entregado a alumno)
-- ========================
CREATE TABLE entrega (
  id_entrega INT AUTO_INCREMENT PRIMARY KEY,
  fecha DATE NOT NULL,
  id_paquete INT NOT NULL,
  id_alumno INT NOT NULL,
  FOREIGN KEY (id_paquete) REFERENCES paquete(id_paquete),
  FOREIGN KEY (id_alumno) REFERENCES usuario(id_usuario)
);

-- ========================
-- Triggers: Validación de fecha de caducidad
-- ========================
DELIMITER $$

CREATE TRIGGER trg_validar_fecha_caducidad_insert
BEFORE INSERT ON detalle_donacion
FOR EACH ROW
BEGIN
  IF NEW.fecha_caducidad < CURDATE() THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'La fecha de caducidad no puede ser anterior a la fecha actual';
  END IF;
END$$

CREATE TRIGGER trg_validar_fecha_caducidad_update
BEFORE UPDATE ON detalle_donacion
FOR EACH ROW
BEGIN
  IF NEW.fecha_caducidad < CURDATE() THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'La fecha de caducidad no puede ser anterior a la fecha actual';
  END IF;
END$$

DELIMITER ;

SET FOREIGN_KEY_CHECKS = 1;

SELECT 'Base de datos Bocaditos actualizada exitosamente' AS mensaje;
