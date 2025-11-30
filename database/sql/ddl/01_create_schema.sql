-- ============================================
-- Script de Creación de Base de Datos
-- Sistema: Bocaditos - Sistema de Donaciones Alimentarias
-- Versión: 2.0.2
-- Fecha: 2025-11-25
-- Motor: 10.4.32-MariaDB 
-- ============================================


SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- Crear base de datos
CREATE DATABASE IF NOT EXISTS `bocadito_db`
    DEFAULT CHARACTER SET utf8mb4
    COLLATE utf8mb4_general_ci;

USE `bocadito_db`;
SET FOREIGN_KEY_CHECKS = 0;

-- TABLA: tipos_productos - Catálogo de tipos de producto (categorías usadas por `productos`).
CREATE TABLE tipos_productos (
  id_tipo_producto INT AUTO_INCREMENT PRIMARY KEY,
  nombre_tipo ENUM('Frutas', 'Verduras', 'Enlatados', 'Pan', 'Lacteos', 'Cereales', 'Bebidas') NOT NULL
);

-- TABLA: productos - Lista de productos donados; referencia al tipo y fecha de caducidad.
CREATE TABLE productos (
  id_producto INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  fecha_caducidad DATE NOT NULL,
  id_tipo_producto INT NOT NULL,
  FOREIGN KEY (id_tipo_producto) REFERENCES tipos_productos(id_tipo_producto)
);

 
-- TABLA: estados_entregas - Estados usados por donaciones y entregas (pendiente/entregada/cancelada).
CREATE TABLE estados_entregas (
  id_estado_entrega INT AUTO_INCREMENT PRIMARY KEY,
  nombre_estado ENUM('pendiente','entregada','cancelada') NOT NULL UNIQUE
);
-- Valores por defecto para estados de entrega/donación
INSERT INTO estados_entregas (nombre_estado) VALUES ('pendiente') ON DUPLICATE KEY UPDATE nombre_estado = nombre_estado;
INSERT INTO estados_entregas (nombre_estado) VALUES ('entregada') ON DUPLICATE KEY UPDATE nombre_estado = nombre_estado;
INSERT INTO estados_entregas (nombre_estado) VALUES ('cancelada') ON DUPLICATE KEY UPDATE nombre_estado = nombre_estado;

-- TABLA: estados - Catálogo genérico de estados (usado por ciudades/ubicaciones).
CREATE TABLE estados (
  id_estado INT AUTO_INCREMENT PRIMARY KEY,
  nombre_estado VARCHAR(100) NOT NULL UNIQUE
);

-- TABLA: ciudades - Ciudades con FK a `estados`.
CREATE TABLE ciudades (
  id_ciudad INT AUTO_INCREMENT PRIMARY KEY,
  nombre_ciudad VARCHAR(100) NOT NULL,
  id_estado INT NOT NULL,
  FOREIGN KEY (id_estado) REFERENCES estados(id_estado)
);

-- TABLA: ubicaciones - Direcciones físicas que apuntan a una ciudad.
CREATE TABLE ubicaciones (
  id_ubicacion INT AUTO_INCREMENT PRIMARY KEY,
  direccion VARCHAR(255),
  codigo_postal VARCHAR(10),
  id_estado INT NOT NULL,
  id_ciudad INT NULL,
  FOREIGN KEY (id_estado) REFERENCES estados(id_estado),
  FOREIGN KEY (id_ciudad) REFERENCES ciudades(id_ciudad)
);

-- Índices para consultas por estado/ciudad
CREATE INDEX IF NOT EXISTS idx_ubicaciones_ciudad ON ubicaciones (id_ciudad);
CREATE INDEX IF NOT EXISTS idx_ubicaciones_estado ON ubicaciones (id_estado);

-- TABLA: escuelas - Escuelas beneficiarias; opcionalmente apuntan a una ubicación.
CREATE TABLE escuelas (
  id_escuela INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  id_ubicacion INT,
  FOREIGN KEY (id_ubicacion) REFERENCES ubicaciones(id_ubicacion)
);

-- TABLA: roles - Roles de usuario (alumno o administrador).
CREATE TABLE roles (
  id_rol INT AUTO_INCREMENT PRIMARY KEY,
    nombre_rol ENUM('alumno','administrador') NOT NULL
);

-- TABLA: usuarios - Usuarios del sistema (alumnos); credenciales y referencias a rol/escuela.
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

-- TABLA: comentarios_alumnos - Comentarios hechos por alumnos; FK a `usuarios`.
CREATE TABLE comentarios_alumnos (
  id_comentario INT AUTO_INCREMENT PRIMARY KEY,
  id_alumno INT NOT NULL,
  contenido TEXT NOT NULL,
  fecha_envio DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (id_alumno) REFERENCES usuarios(id_usuario)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- TABLA: administradores - Tabla que marca qué `usuario` es administrador con fecha de asignación.
CREATE TABLE administradores (
  id_admin INT AUTO_INCREMENT PRIMARY KEY,
  id_usuario INT NOT NULL UNIQUE,
  fecha_asignacion DATE,
  FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);

-- TABLA: donadores - Registro de donadores/empresas y datos del representante responsable de la donación.
CREATE TABLE donadores (
  id_donador INT AUTO_INCREMENT PRIMARY KEY,
  nombre_empresa VARCHAR(100) NOT NULL,
  rfc_empresa VARCHAR(12) NOT NULL UNIQUE,
  razon_social VARCHAR(100) NOT NULL,
  empresa_telefono VARCHAR(15),
  empresa_correo VARCHAR(150),
  contrasena VARCHAR(255) NOT NULL,
  id_ubicacion INT NOT NULL,
  -- Datos del representante/contacto que realiza la donación (persona encargada)
  representante_nombre VARCHAR(100),
  representante_telefono VARCHAR(15),
  representante_correo VARCHAR(150),
  representante_cargo VARCHAR(100),
  FOREIGN KEY (id_ubicacion) REFERENCES ubicaciones(id_ubicacion)
);

-- TABLA: donaciones - Cabecera de una donación hecha por un donador a una escuela.
-- TABLA: donaciones - Cabecera de una donación hecha por un donador a una escuela.
CREATE TABLE donaciones (
  id_donacion INT AUTO_INCREMENT PRIMARY KEY,
  id_donador INT NOT NULL,
  id_escuela INT NOT NULL,
  fecha_donacion DATE NOT NULL,
  id_estado_entrega INT NOT NULL,
  FOREIGN KEY (id_donador) REFERENCES donadores(id_donador),
  FOREIGN KEY (id_escuela) REFERENCES escuelas(id_escuela),
  FOREIGN KEY (id_estado_entrega) REFERENCES estados_entregas(id_estado_entrega)
);

-- TABLA: detalle_donaciones - Detalle por producto de cada donación (cantidad por producto).
CREATE TABLE detalle_donaciones (
  id_detalle_donacion INT AUTO_INCREMENT PRIMARY KEY,
  id_donacion INT NOT NULL,
  id_producto INT NOT NULL,
  cantidad INT CHECK (cantidad > 0),
  FOREIGN KEY (id_donacion) REFERENCES donaciones(id_donacion),
  FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

-- TABLA: stocks - Registro de movimientos de inventario por `producto` y `escuela`.
-- Cada fila representa una entrada ('E') o salida ('S').
CREATE TABLE stocks (
  id_stock INT AUTO_INCREMENT PRIMARY KEY,
  id_producto INT NOT NULL,
  id_escuela INT NOT NULL,
  cantidad INT NOT NULL,
  fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  tipo ENUM('E','S') NOT NULL,
  FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
  FOREIGN KEY (id_escuela) REFERENCES escuelas(id_escuela)
);
-- Índices para acelerar consultas por producto/escuela/fecha/tipo
CREATE INDEX IF NOT EXISTS idx_stocks_producto_escuela_fecha ON stocks (id_producto, id_escuela, fecha);
CREATE INDEX IF NOT EXISTS idx_stocks_producto_escuela_tipo ON stocks (id_producto, id_escuela, tipo);

-- TABLA: paquetes - Paquetes predefinidos de productos que administra un `administrador`.
CREATE TABLE paquetes (
  id_paquete INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  descripcion TEXT,
  fecha_creacion DATE NOT NULL,
  id_admin INT NOT NULL,
  FOREIGN KEY (id_admin) REFERENCES administradores(id_admin)
);

-- Tabla: detalle_paquete - Contenido detallado de cada paquete (producto + cantidad)
CREATE TABLE detalle_paquete (
  id_detalle_paquete INT AUTO_INCREMENT PRIMARY KEY,
  id_paquete INT NOT NULL,
  id_producto INT NOT NULL,
  cantidad INT NOT NULL CHECK (cantidad > 0),
  FOREIGN KEY (id_paquete) REFERENCES paquetes(id_paquete) ON DELETE CASCADE,
  FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
  UNIQUE KEY uniq_paquete_producto (id_paquete, id_producto)
);

-- TABLA: entregas - Registro de entregas realizadas a alumnos (relaciona paquete y alumno).
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
-- Breve: Catálogo de alergias que pueden tener los usuarios.
CREATE TABLE alergias (
  id_alergia INT AUTO_INCREMENT PRIMARY KEY,
  descripcion_alergia VARCHAR(255)
);

-- Tabla pivote: usuarios_alergia
-- Breve: Asociación N:M entre `usuarios` y `alergias`.
CREATE TABLE usuarios_alergias (
  id_usuario INT,
  id_alergia INT,
  PRIMARY KEY (id_usuario, id_alergia),
  FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
  FOREIGN KEY (id_alergia) REFERENCES alergias(id_alergia)
);

-- Triggers: Validación de fecha de caducidad
-- Breve: Evitan insertar/actualizar productos con fecha de caducidad pasada.
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
  -- obtener id de estado 'entregada' si existe (usando `estados_entregas`)
  SELECT id_estado_entrega INTO estado_default FROM estados_entregas WHERE nombre_estado = 'entregada' LIMIT 1;

  -- Insertar entrega con estado por defecto (si no existe, se usa id 1 por compatibilidad)
  INSERT INTO entregas (fecha, id_paquete, id_alumno, id_estado_entrega)
  VALUES (entrega_fecha, paquete_id, alumno_id, COALESCE(estado_default, 1));

  -- Registrar movimientos de stock como salidas ('S') por cada producto del paquete
  INSERT INTO stocks (id_producto, id_escuela, cantidad, fecha, tipo)
  SELECT dp.id_producto, u.id_escuela, dp.cantidad, entrega_fecha, 'S'
  FROM detalle_paquete dp
  JOIN usuarios u ON u.id_usuario = alumno_id
  WHERE dp.id_paquete = paquete_id;
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

  -- Insertar donación (usa `id_estado_entrega` para el estado de la donación)
  INSERT INTO donaciones (id_donador, id_escuela, id_estado_entrega, fecha_donacion)
  VALUES (donador_id, escuela_id, estado_id, CURDATE());

  SET nueva_donacion_id = LAST_INSERT_ID();
  
  -- Insertar detalle
  INSERT INTO detalle_donaciones (id_donacion, id_producto, cantidad)
  VALUES (nueva_donacion_id, producto_id, cantidad);

  -- Actualizar stock: insertar movimiento de entrada ('E') con escuela
  INSERT INTO stocks (id_producto, id_escuela, cantidad, fecha, tipo)
  VALUES (producto_id, escuela_id, cantidad, CURDATE(), 'E');
END$$

DELIMITER ;

-- ==========================
-- Sistema de mensajería
-- ==========================

SET FOREIGN_KEY_CHECKS = 0;
-- Tabla: conversaciones
-- Breve: Conversaciones entre participantes; guarda metadatos y estado.
CREATE TABLE IF NOT EXISTS conversaciones (
  id_conversacion INT AUTO_INCREMENT PRIMARY KEY,
  asunto VARCHAR(255),
  fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
  fecha_ultimo_mensaje DATETIME,
  estado ENUM('abierta','cerrada') DEFAULT 'abierta'
);

-- NOTE: La tabla `registro_conversaciones` se elimina: ahora los mensajes referencian directamente a administradores o donadores.

-- Tabla: mensajes
-- Breve: Mensajes de las conversaciones; referencian directamente a `administradores` o `donadores`.
CREATE TABLE IF NOT EXISTS mensajes (
  id_mensaje INT AUTO_INCREMENT PRIMARY KEY,
  id_conversacion INT NOT NULL,
  id_admin INT NULL,
  id_donador INT NULL,
  contenido TEXT NOT NULL,
  fecha_envio DATETIME DEFAULT CURRENT_TIMESTAMP,
  leido BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (id_conversacion) REFERENCES conversaciones(id_conversacion) ON DELETE CASCADE,
  FOREIGN KEY (id_admin) REFERENCES administradores(id_admin),
  FOREIGN KEY (id_donador) REFERENCES donadores(id_donador),
  CHECK (
    (id_admin IS NOT NULL AND id_donador IS NULL) OR
    (id_admin IS NULL AND id_donador IS NOT NULL)
  )
);

CREATE INDEX IF NOT EXISTS idx_mensaje_conversacion_fecha ON mensajes (id_conversacion, fecha_envio);

-- Trigger para actualizar fecha_ultimo_mensaje en la conversación
-- Breve: Mantiene `fecha_ultimo_mensaje` sincronizada al insertar un nuevo mensaje.
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
-- Breve: Calcula la cantidad disponible por producto sumando entradas y restando salidas.
CREATE OR REPLACE VIEW vw_stock_disponible AS
SELECT
  id_producto,
  id_escuela,
  COALESCE(SUM(CASE WHEN tipo = 'E' THEN cantidad WHEN tipo = 'S' THEN -cantidad END),0) AS cantidad_disponible
FROM stocks
GROUP BY id_producto, id_escuela;

DELIMITER $$
-- Procedimiento: crear_paquete
-- Breve: Crea un paquete y devuelve su id.
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

CREATE PROCEDURE agregar_producto_a_paquete (
  IN p_paquete_id INT,
  IN p_producto_id INT,
  IN p_cantidad INT
)
BEGIN
  INSERT INTO detalle_paquete (id_paquete, id_producto, cantidad)
  VALUES (p_paquete_id, p_producto_id, p_cantidad)
  ON DUPLICATE KEY UPDATE cantidad = cantidad + VALUES(cantidad);
END$$

-- PROCEDIMIENTO: entregar_paquete - Registra la entrega de un paquete a un alumno y ajusta stocks (aumentando salidas).
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

  -- Registrar salidas ('S') por cada producto del paquete (atribuidas a la escuela del alumno)
  INSERT INTO stocks (id_producto, id_escuela, cantidad, fecha, tipo)
  SELECT dp.id_producto, u.id_escuela, dp.cantidad, p_fecha, 'S'
  FROM detalle_paquete dp
  JOIN usuarios u ON u.id_usuario = p_alumno_id
  WHERE dp.id_paquete = p_paquete_id;
END$$

DELIMITER ;