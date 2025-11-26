-- ============================================
-- Script de Creación de Base de Datos
-- Sistema: Bocaditos - Sistema de Donaciones Alimentarias
-- Versión: 2.0.2
-- Fecha: 2025-11-24
-- Motor: MySQL/MariaDB
-- ============================================


SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- Crear base de datos
CREATE DATABASE IF NOT EXISTS `bocadito_db`
    DEFAULT CHARACTER SET utf8mb4
    COLLATE utf8mb4_general_ci;

USE `bocadito_db`;
SET FOREIGN_KEY_CHECKS = 0;

-- Tabla: tipos_productos
CREATE TABLE tipos_productos (
  id_tipo_producto INT AUTO_INCREMENT PRIMARY KEY,
  nombre_tipo ENUM('Frutas', 'Verduras', 'Enlatados', 'Pan', 'Lacteos', 'Cereales', 'Bebidas') NOT NULL
);

-- Tabla: productos
CREATE TABLE productos (
  id_producto INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  fecha_caducidad DATE NOT NULL,
  id_tipo_producto INT NOT NULL,
  FOREIGN KEY (id_tipo_producto) REFERENCES tipos_productos(id_tipo_producto)
);

 
-- Tabla: estados_donaciones
CREATE TABLE estados_donaciones (
  id_estado_donacion INT AUTO_INCREMENT PRIMARY KEY,
  nombre_estado ENUM('pendiente','entregada','cancelada') NOT NULL
);

-- Tabla: estados
CREATE TABLE estados (
  id_estado INT AUTO_INCREMENT PRIMARY KEY,
  nombre_estado VARCHAR(100) NOT NULL UNIQUE
);

-- Tabla: ciudades
CREATE TABLE ciudades (
  id_ciudad INT AUTO_INCREMENT PRIMARY KEY,
  nombre_ciudad VARCHAR(100) NOT NULL,
  id_estado INT NOT NULL,
  FOREIGN KEY (id_estado) REFERENCES estados(id_estado)
);

-- Tabla: ubicaciones
CREATE TABLE ubicaciones (
  id_ubicacion INT AUTO_INCREMENT PRIMARY KEY,
  direccion VARCHAR(255),
  codigo_postal VARCHAR(10),
  id_ciudad INT NOT NULL,
  FOREIGN KEY (id_ciudad) REFERENCES ciudades(id_ciudad)
);

CREATE INDEX IF NOT EXISTS idx_ubicaciones_ciudad ON ubicaciones (id_ciudad);

-- Tabla: escuelas
CREATE TABLE escuelas (
  id_escuela INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  id_ubicacion INT,
  FOREIGN KEY (id_ubicacion) REFERENCES ubicaciones(id_ubicacion)
);

-- Tabla: rol
CREATE TABLE roles (
  id_rol INT AUTO_INCREMENT PRIMARY KEY,
    nombre_rol ENUM('alumno','administrador') NOT NULL
);

-- Tabla: usuario
CREATE TABLE usuarios (
  id_usuario INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  apellido VARCHAR(100) NOT NULL,
  telefono VARCHAR(15) NOT NULL,
  matricula VARCHAR(10) NOT NULL,
  cuatrimestre VARCHAR(10) NOT NULL,
  correo VARCHAR(150) NOT NULL UNIQUE,
  contrasena VARCHAR(255) NOT NULL,
  id_rol INT NOT NULL,
  id_escuela INT NOT NULL,
  id_ubicacion INT,
  FOREIGN KEY (id_rol) REFERENCES roles(id_rol),
  FOREIGN KEY (id_escuela) REFERENCES escuelas(id_escuela),
  FOREIGN KEY (id_ubicacion) REFERENCES ubicaciones(id_ubicacion)
);

CREATE TABLE comentarios_alumnos (
  id_comentario INT AUTO_INCREMENT PRIMARY KEY,
  id_alumno INT NOT NULL,
  contenido TEXT NOT NULL,
  fecha_envio DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (id_alumno) REFERENCES usuarios(id_usuario)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- Tabla: administrador
CREATE TABLE administradores (
  id_admin INT AUTO_INCREMENT PRIMARY KEY,
  id_usuario INT NOT NULL UNIQUE,
  fecha_asignacion DATE,
  FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);

-- Tabla: donador
CREATE TABLE donadores (
  id_donador INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  rfc VARCHAR(12) NOT NULL UNIQUE,
  razon_social VARCHAR(100) NOT NULL,
  telefono VARCHAR(15) NOT NULL,
  correo VARCHAR(150) NOT NULL,
  contrasena VARCHAR(255) NOT NULL,
  id_ubicacion INT NOT NULL,
  FOREIGN KEY (id_ubicacion) REFERENCES ubicaciones(id_ubicacion)
);

-- Tabla: donacion
CREATE TABLE donaciones (
  id_donacion INT AUTO_INCREMENT PRIMARY KEY,
  id_donador INT NOT NULL,
  id_escuela INT NOT NULL,
  fecha_donacion DATE NOT NULL,
  id_estado_donacion INT NOT NULL,
  FOREIGN KEY (id_donador) REFERENCES donadores(id_donador),
  FOREIGN KEY (id_escuela) REFERENCES escuelas(id_escuela),
  FOREIGN KEY (id_estado_donacion) REFERENCES estados_donaciones(id_estado_donacion)
);

-- Tabla: detalle_donacion
CREATE TABLE detalle_donaciones (
  id_detalle_donacion INT AUTO_INCREMENT PRIMARY KEY,
  id_donacion INT NOT NULL,
  id_producto INT NOT NULL,
  cantidad INT CHECK (cantidad > 0),
  FOREIGN KEY (id_donacion) REFERENCES donaciones(id_donacion),
  FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

-- Tabla: stocks
-- La cantidad disponible se calcula como (cantidad_entrada - cantidad_salida)
CREATE TABLE stocks (
  id_stock INT AUTO_INCREMENT PRIMARY KEY,
  id_producto INT NOT NULL,
  id_escuela INT NOT NULL,
  cantidad_entrada INT DEFAULT 0,
  cantidad_salida INT DEFAULT 0,
  fecha_entrada DATE,
  fecha_salida DATE,
  FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
  FOREIGN KEY (id_escuela) REFERENCES escuelas(id_escuela),
  UNIQUE KEY uniq_producto_escuela (id_producto, id_escuela)
);

-- Tabla: paquetes
CREATE TABLE paquetes (
  id_paquete INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  descripcion TEXT,
  fecha_creacion DATE NOT NULL,
  id_admin INT NOT NULL,
  FOREIGN KEY (id_admin) REFERENCES administradores(id_admin)
);

-- Tabla pivote: paquetes_stock
CREATE TABLE paquetes_stock (
  id_paquete INT,
  id_stock INT,
  cantidad INT CHECK (cantidad > 0),
  PRIMARY KEY (id_paquete, id_stock),
  FOREIGN KEY (id_paquete) REFERENCES paquetes(id_paquete),
  FOREIGN KEY (id_stock) REFERENCES stocks(id_stock)
);

-- Tabla de estados para entregas
CREATE TABLE estados_entregas (
  id_estado_entrega INT AUTO_INCREMENT PRIMARY KEY,
  nombre_estado ENUM('pendiente','entregada','cancelada') NOT NULL UNIQUE
);
-- Valores por defecto para estados de entregas
INSERT INTO estados_entregas (nombre_estado) VALUES ('pendiente') ON DUPLICATE KEY UPDATE nombre_estado = nombre_estado;
INSERT INTO estados_entregas (nombre_estado) VALUES ('entregada') ON DUPLICATE KEY UPDATE nombre_estado = nombre_estado;
INSERT INTO estados_entregas (nombre_estado) VALUES ('cancelada') ON DUPLICATE KEY UPDATE nombre_estado = nombre_estado;

CREATE TABLE entregas (
  id_entrega INT AUTO_INCREMENT PRIMARY KEY,
  fecha DATE NOT NULL,
  id_paquete INT NOT NULL,
  id_alumno INT NOT NULL,
  id_estado_entrega INT NOT NULL,
  FOREIGN KEY (id_paquete) REFERENCES paquetes(id_paquete),
  FOREIGN KEY (id_alumno) REFERENCES usuarios(id_usuario),
  FOREIGN KEY (id_estado_entrega) REFERENCES estados_entregas(id_estado_entrega)
);

-- Tabla: alergia
CREATE TABLE alergias (
  id_alergia INT AUTO_INCREMENT PRIMARY KEY,
  descripcion_alergia VARCHAR(255)
);

-- Tabla pivote: usuarios_alergia
CREATE TABLE usuarios_alergias (
  id_usuario INT,
  id_alergia INT,
  PRIMARY KEY (id_usuario, id_alergia),
  FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
  FOREIGN KEY (id_alergia) REFERENCES alergias(id_alergia)
);

-- Triggers: Validación de fecha de caducidad
DELIMITER $$

CREATE TRIGGER trg_validar_fecha_caducidad_insert
BEFORE INSERT ON productos
FOR EACH ROW
BEGIN
  IF NEW.fecha_caducidad < CURDATE() THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'La fecha de caducidad no puede ser anterior a la fecha actual';
  END IF;
END$$

CREATE TRIGGER trg_validar_fecha_caducidad_update
BEFORE UPDATE ON productos
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
  DECLARE estado_default INT;
  -- obtener id de estado 'entregada' si existe
  SELECT id_estado_entrega INTO estado_default FROM estados_entregas WHERE nombre_estado = 'entregada' LIMIT 1;

  -- Insertar entrega con estado por defecto (si no existe, deberá insertarse manualmente en estados_entregas)
  INSERT INTO entregas (id_alumno, id_paquete, fecha, id_estado_entrega)
  VALUES (alumno_id, paquete_id, entrega_fecha, COALESCE(estado_default, 1));

  -- Actualizar stock por cada producto del paquete: aumentamos cantidad_salida
  UPDATE stocks s
  JOIN paquetes_stock ps ON s.id_stock = ps.id_stock
  SET 
    s.cantidad_salida = s.cantidad_salida + ps.cantidad,
    s.fecha_salida = entrega_fecha
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
  INSERT INTO donaciones (id_donador, id_escuela, id_estado_donacion, fecha_donacion)
  VALUES (donador_id, escuela_id, estado_id, CURDATE());

  SET nueva_donacion_id = LAST_INSERT_ID();
  
  -- Insertar detalle
  INSERT INTO detalle_donaciones (id_donacion, id_producto, cantidad)
  VALUES (nueva_donacion_id, producto_id, cantidad);

  -- Actualizar stock
  INSERT INTO stocks (id_producto, id_escuela, cantidad_entrada, fecha_entrada)
  VALUES (producto_id, escuela_id, cantidad, CURDATE())
  ON DUPLICATE KEY UPDATE
    cantidad_entrada = cantidad_entrada + VALUES(cantidad_entrada),
    fecha_entrada = CURDATE();
END$$

DELIMITER ;

-- ==========================
-- Sistema de mensajería
-- ==========================

SET FOREIGN_KEY_CHECKS = 0;
-- Tabla: conversaciones
CREATE TABLE IF NOT EXISTS conversaciones (
  id_conversacion INT AUTO_INCREMENT PRIMARY KEY,
  asunto VARCHAR(255),
  fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
  fecha_ultimo_mensaje DATETIME,
  estado ENUM('abierta','cerrada') DEFAULT 'abierta'
);

-- Tabla: registro_conversaciones
CREATE TABLE IF NOT EXISTS registro_conversaciones (
  id_participante INT AUTO_INCREMENT PRIMARY KEY,
  id_conversacion INT NOT NULL,
  tipo_participante ENUM('usuario','donador') NOT NULL,
  id_participante_ref INT NOT NULL,
  rol ENUM('administrador','donador') NOT NULL,
  FOREIGN KEY (id_conversacion) REFERENCES conversaciones(id_conversacion) ON DELETE CASCADE
);

-- Tabla: mensajes
CREATE TABLE IF NOT EXISTS mensajes (
  id_mensaje INT AUTO_INCREMENT PRIMARY KEY,
  id_conversacion INT NOT NULL,
  sender_type ENUM('usuario','donador') NOT NULL,
  sender_id INT NOT NULL,
  contenido TEXT NOT NULL,
  fecha_envio DATETIME DEFAULT CURRENT_TIMESTAMP,
  leido BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (id_conversacion) REFERENCES conversaciones(id_conversacion) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_mensaje_conversacion_fecha ON mensajes (id_conversacion, fecha_envio);

-- Trigger para actualizar fecha_ultimo_mensaje en la conversación
DELIMITER $$
CREATE TRIGGER trg_update_fecha_ultimo_mensaje
AFTER INSERT ON mensajes
FOR EACH ROW
BEGIN
  UPDATE conversaciones
  SET fecha_ultimo_mensaje = NEW.fecha_envio
  WHERE id_conversacion = NEW.id_conversacion;
END$$
DELIMITER ;

SET FOREIGN_KEY_CHECKS = 1;

-- Vista: stock disponible calculado
CREATE OR REPLACE VIEW vw_stock_disponible AS
SELECT
  id_producto,
  id_escuela,
  (IFNULL(cantidad_entrada,0) - IFNULL(cantidad_salida,0)) AS cantidad_disponible
FROM stocks;

DELIMITER $$
-- Procedimiento: crear_paquete
CREATE PROCEDURE crear_paquete (
  IN p_admin_id INT,
  IN p_nombre VARCHAR(100),
  IN p_descripcion TEXT
)
BEGIN
  INSERT INTO paquetes (nombre, descripcion, fecha_creacion, id_admin)
  VALUES (p_nombre, p_descripcion, CURDATE(), p_admin_id);
  SELECT LAST_INSERT_ID() AS paquete_id;
END$$

-- Procedimiento: agregar_producto_a_paquete
CREATE PROCEDURE agregar_producto_a_paquete (
  IN p_paquete_id INT,
  IN p_stock_id INT,
  IN p_cantidad INT
)
BEGIN
  INSERT INTO paquetes_stock (id_paquete, id_stock, cantidad)
  VALUES (p_paquete_id, p_stock_id, p_cantidad)
  ON DUPLICATE KEY UPDATE cantidad = cantidad + VALUES(cantidad);
END$$

-- Procedimiento: entregar_paquete (usa paquetes_stock para decrementar stocks)
CREATE PROCEDURE entregar_paquete (
  IN p_alumno_id INT,
  IN p_paquete_id INT,
  IN p_fecha DATE
)
BEGIN
  DECLARE estado_entregada INT;
  SELECT id_estado_entrega INTO estado_entregada FROM estados_entregas WHERE nombre_estado = 'entregada' LIMIT 1;

  INSERT INTO entregas (fecha, id_paquete, id_alumno, id_estado_entrega)
  VALUES (p_fecha, p_paquete_id, p_alumno_id, COALESCE(estado_entregada,1));

  -- decrementar stocks (sumamos a cantidad_salida)
  UPDATE stocks s
  JOIN paquetes_stock ps ON s.id_stock = ps.id_stock
  SET s.cantidad_salida = s.cantidad_salida + ps.cantidad,
      s.fecha_salida = p_fecha
  WHERE ps.id_paquete = p_paquete_id;
END$$

DELIMITER ;
