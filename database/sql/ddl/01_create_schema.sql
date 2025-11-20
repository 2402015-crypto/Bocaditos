-- ============================================
-- Script de Creación de Base de Datos
-- Sistema: Bocaditos - Sistema de Donaciones Alimentarias
-- Versión: 2.0.0
-- Fecha: 2025-11-20
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

-- Tabla: tipo_producto
CREATE TABLE tipo_producto (
  id_tipo_producto INT AUTO_INCREMENT PRIMARY KEY,
  nombre_tipo VARCHAR(100) NOT NULL UNIQUE
);

-- Tabla: producto
CREATE TABLE producto (
  id_producto INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  id_tipo_producto INT NOT NULL,
  FOREIGN KEY (id_tipo_producto) REFERENCES tipo_producto(id_tipo_producto)
);

-- Tabla: estado_donacion
CREATE TABLE estado_donacion (
  id_estado_donacion INT AUTO_INCREMENT PRIMARY KEY,
  nombre_estado ENUM('pendiente','entregada','cancelada') NOT NULL
);

-- Tabla: estado
CREATE TABLE estado (
  id_estado INT AUTO_INCREMENT PRIMARY KEY,
  nombre_estado VARCHAR(100) NOT NULL UNIQUE
);

-- Tabla: ciudad
CREATE TABLE ciudad (
  id_ciudad INT AUTO_INCREMENT PRIMARY KEY,
  nombre_ciudad VARCHAR(100) NOT NULL,
  id_estado INT NOT NULL,
  FOREIGN KEY (id_estado) REFERENCES estado(id_estado)
);

-- Tabla: ubicacion
CREATE TABLE ubicacion (
  id_ubicacion INT AUTO_INCREMENT PRIMARY KEY,
  direccion VARCHAR(255),
  codigo_postal VARCHAR(10),
  id_ciudad INT NOT NULL,
  FOREIGN KEY (id_ciudad) REFERENCES ciudad(id_ciudad)
);

-- Tabla: escuela
CREATE TABLE escuela (
  id_escuela INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  id_ubicacion INT,
  FOREIGN KEY (id_ubicacion) REFERENCES ubicacion(id_ubicacion)
);

-- Tabla: rol
CREATE TABLE rol (
  id_rol INT AUTO_INCREMENT PRIMARY KEY,
  nombre_rol ENUM('alumno','administrador') NOT NULL
);

-- Tabla: usuario
CREATE TABLE usuario (
  id_usuario INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  apellido VARCHAR(100) NOT NULL,
  telefono VARCHAR(15) NOT NULL,
  matricula VARCHAR(10) NOT NULL,
  cuatrimestre VARCHAR(10) NOT NULL,
  correo VARCHAR(150) NOT NULL UNIQUE,
  contraseña VARCHAR(255) NOT NULL,
  id_rol INT NOT NULL,
  id_escuela INT NOT NULL,
  id_ubicacion INT,
  FOREIGN KEY (id_rol) REFERENCES rol(id_rol),
  FOREIGN KEY (id_escuela) REFERENCES escuela(id_escuela),
  FOREIGN KEY (id_ubicacion) REFERENCES ubicacion(id_ubicacion)
);

-- Tabla: comentarios y sugerencias de alumnos
CREATE TABLE comentario_alumno (
  id_comentario INT AUTO_INCREMENT PRIMARY KEY,
  id_alumno INT NOT NULL,
  tipo ENUM('comentario', 'sugerencia', 'queja') DEFAULT 'comentario',
  contenido TEXT NOT NULL,
  fecha_envio DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (id_alumno) REFERENCES usuario(id_usuario)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- Tabla: administrador
CREATE TABLE administrador (
  id_admin INT AUTO_INCREMENT PRIMARY KEY,
  id_usuario INT NOT NULL UNIQUE,
  fecha_asignacion DATE,
  FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

-- Tabla: donador
CREATE TABLE donador (
  id_donador INT AUTO_INCREMENT PRIMARY KEY,
  rfc VARCHAR(12) NOT NULL UNIQUE,
  razon_social VARCHAR(100) NOT NULL,
  telefono VARCHAR(15) NOT NULL,
  correo VARCHAR(150) NOT NULL,
  contraseña VARCHAR(255) NOT NULL,
  id_ubicacion INT NOT NULL,
  FOREIGN KEY (id_ubicacion) REFERENCES ubicacion(id_ubicacion)
);

-- Tabla: donacion
CREATE TABLE donacion (
  id_donacion INT AUTO_INCREMENT PRIMARY KEY,
  id_donador INT NOT NULL,
  id_escuela INT NOT NULL,
  fecha_donacion DATE NOT NULL,
  id_estado_donacion INT NOT NULL,
  FOREIGN KEY (id_donador) REFERENCES donador(id_donador),
  FOREIGN KEY (id_escuela) REFERENCES escuela(id_escuela),
  FOREIGN KEY (id_estado_donacion) REFERENCES estado_donacion(id_estado_donacion)
);

-- Tabla: detalle_donacion
CREATE TABLE detalle_donacion (
  id_detalle_donacion INT AUTO_INCREMENT PRIMARY KEY,
  id_donacion INT NOT NULL,
  id_producto INT NOT NULL,
  cantidad INT CHECK (cantidad > 0),
  fecha_caducidad DATE NOT NULL,
  FOREIGN KEY (id_donacion) REFERENCES donacion(id_donacion),
  FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);

-- Tabla: stock
CREATE TABLE stock (
  id_stock INT AUTO_INCREMENT PRIMARY KEY,
  id_producto INT NOT NULL,
  id_escuela INT NOT NULL,
  cantidad_disponible INT DEFAULT 0,
  cantidad_entrada INT DEFAULT 0,
  cantidad_salida INT DEFAULT 0,
  fecha_entrada DATE,
  fecha_salida DATE,
  fecha_actualizacion DATE,
  FOREIGN KEY (id_producto) REFERENCES producto(id_producto),
  FOREIGN KEY (id_escuela) REFERENCES escuela(id_escuela)
);

-- Tabla: paquete
CREATE TABLE paquete (
  id_paquete INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  descripcion TEXT,
  fecha_creacion DATE NOT NULL,
  id_admin INT NOT NULL,
  FOREIGN KEY (id_admin) REFERENCES administrador(id_admin)
);

-- Tabla pivote: paquete_stock
CREATE TABLE paquete_stock (
  id_paquete INT,
  id_stock INT,
  cantidad INT CHECK (cantidad > 0),
  PRIMARY KEY (id_paquete, id_stock),
  FOREIGN KEY (id_paquete) REFERENCES paquete(id_paquete),
  FOREIGN KEY (id_stock) REFERENCES stock(id_stock)
);

-- Tabla: entrega
CREATE TABLE entrega (
  id_entrega INT AUTO_INCREMENT PRIMARY KEY,
  fecha DATE NOT NULL,
  id_paquete INT NOT NULL,
  id_alumno INT NOT NULL,
  FOREIGN KEY (id_paquete) REFERENCES paquete(id_paquete),
  FOREIGN KEY (id_alumno) REFERENCES usuario(id_usuario)
);

-- Tabla: alergia
CREATE TABLE alergia (
  id_alergia INT AUTO_INCREMENT PRIMARY KEY,
  descripcion_alergia VARCHAR(255)
);

-- Tabla pivote: usuario_alergia
CREATE TABLE usuario_alergia (
  id_usuario INT,
  id_alergia INT,
  PRIMARY KEY (id_usuario, id_alergia),
  FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
  FOREIGN KEY (id_alergia) REFERENCES alergia(id_alergia)
);

-- Triggers: Validación de fecha de caducidad
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
DELIMITER $$

CREATE PROCEDURE registrar_entrega (
  IN alumno_id INT,
  IN paquete_id INT,
  IN entrega_fecha DATE
)
BEGIN
  -- Insertar entrega
  INSERT INTO entrega (id_alumno, id_paquete, fecha)
  VALUES (alumno_id, paquete_id, entrega_fecha);

  -- Actualizar stock por cada producto del paquete
  UPDATE stock s
  JOIN paquete_stock ps ON s.id_stock = ps.id_stock
  SET 
    s.cantidad_disponible = s.cantidad_disponible - ps.cantidad,
    s.cantidad_salida = s.cantidad_salida + ps.cantidad,
    s.fecha_salida = entrega_fecha,
    s.fecha_actualizacion = entrega_fecha
  WHERE ps.id_paquete = paquete_id;
END$$

DELIMITER ;
DELIMITER $$

CREATE PROCEDURE registrar_donacion (
  IN donador_id INT,
  IN escuela_id INT,
  IN estado_id INT,
  IN producto_id INT,
  IN cantidad INT,
  IN fecha_cad DATE
)
BEGIN
  DECLARE nueva_donacion_id INT;

  -- Insertar donación
  INSERT INTO donacion (id_donador, id_escuela, id_estado_donacion, fecha_donacion)
  VALUES (donador_id, escuela_id, estado_id, CURDATE());

  SET nueva_donacion_id = LAST_INSERT_ID();
  
  -- Insertar detalle
  INSERT INTO detalle_donacion (id_donacion, id_producto, cantidad, fecha_caducidad)
  VALUES (nueva_donacion_id, producto_id, cantidad, fecha_cad);

  -- Actualizar stock
  INSERT INTO stock (id_producto, id_escuela, cantidad_disponible, cantidad_entrada, fecha_entrada, fecha_actualizacion)
  VALUES (producto_id, escuela_id, cantidad, cantidad, CURDATE(), CURDATE())
  ON DUPLICATE KEY UPDATE
    cantidad_disponible = cantidad_disponible + cantidad,
    cantidad_entrada = cantidad_entrada + cantidad,
    fecha_entrada = CURDATE(),
    fecha_actualizacion = CURDATE();
END$$

DELIMITER ;

SET FOREIGN_KEY_CHECKS = 1;