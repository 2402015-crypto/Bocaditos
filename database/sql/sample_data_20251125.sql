-- Sample data for development/testing
-- File: sample_data_20251125.sql
-- WARNING: Run only in development or after taking a DB backup.

USE `bocadito_db`;
SET FOREIGN_KEY_CHECKS = 0;

-- Catalogs / lookups
INSERT INTO tipos_productos (id_tipo_producto, nombre_tipo) VALUES
 (1,'Frutas'),(2,'Verduras'),(3,'Enlatados')
ON DUPLICATE KEY UPDATE nombre_tipo = VALUES(nombre_tipo);

INSERT INTO estados_entregas (id_estado_entrega, nombre_estado) VALUES
 (1,'pendiente'),(2,'entregada'),(3,'cancelada')
ON DUPLICATE KEY UPDATE nombre_estado = VALUES(nombre_estado);

INSERT INTO estados (id_estado, nombre_estado) VALUES
 (1,'Estado A'),(2,'Estado B')
ON DUPLICATE KEY UPDATE nombre_estado = VALUES(nombre_estado);

INSERT INTO ciudades (id_ciudad, nombre_ciudad, id_estado) VALUES
 (1,'Ciudad X',1),(2,'Ciudad Y',2)
ON DUPLICATE KEY UPDATE nombre_ciudad = VALUES(nombre_ciudad), id_estado = VALUES(id_estado);

INSERT INTO ubicaciones (id_ubicacion, direccion, codigo_postal, id_estado, id_ciudad) VALUES
 (1,'Calle Falsa 123','12345',1,1),(2,'Avenida Siempre Viva 742','54321',2,2)
ON DUPLICATE KEY UPDATE direccion=VALUES(direccion), codigo_postal=VALUES(codigo_postal), id_estado=VALUES(id_estado), id_ciudad=VALUES(id_ciudad);

INSERT INTO escuelas (id_escuela, nombre, id_ubicacion) VALUES
 (1,'Escuela Primaria 1',1),(2,'Escuela Secundaria 2',2)
ON DUPLICATE KEY UPDATE nombre=VALUES(nombre), id_ubicacion=VALUES(id_ubicacion);

INSERT INTO roles (id_rol, nombre_rol) VALUES
 (1,'alumno'),(2,'administrador')
ON DUPLICATE KEY UPDATE nombre_rol=VALUES(nombre_rol);

-- Users (note: passwords are plain text here for demo; hash before using in production)
INSERT INTO usuarios (id_usuario, nombre, apellido, telefono, matricula, cuatrimestre, correo, contrasena, id_rol, id_escuela, id_ubicacion) VALUES
 (1,'Juan','Perez','5551000100','A001','2','juan.perez@example.com','password123',1,1,1),
 (2,'Ana','Lopez','5552000200','A002','4','ana.lopez@example.com','password123',2,2,2)
ON DUPLICATE KEY UPDATE nombre=VALUES(nombre), apellido=VALUES(apellido), telefono=VALUES(telefono), matricula=VALUES(matricula), cuatrimestre=VALUES(cuatrimestre), correo=VALUES(correo), contrasena=VALUES(contrasena), id_rol=VALUES(id_rol), id_escuela=VALUES(id_escuela), id_ubicacion=VALUES(id_ubicacion);

INSERT INTO administradores (id_admin, id_usuario, fecha_asignacion) VALUES
 (1,2,CURDATE())
ON DUPLICATE KEY UPDATE id_usuario=VALUES(id_usuario), fecha_asignacion=VALUES(fecha_asignacion);

-- Donors
INSERT INTO donadores (id_donador, nombre_empresa, rfc_empresa, razon_social, empresa_telefono, empresa_correo, contrasena, id_ubicacion, representante_nombre, representante_telefono, representante_correo, representante_cargo) VALUES
 (1,'Panificadora Demo','RFC1234567890','Panificadora Demo S.A.','5553000300','ventas@panificadora.demo','password123',1,'Luis Gomez','5553000301','luis.gomez@panificadora.demo','Gerente Comercial')
ON DUPLICATE KEY UPDATE nombre_empresa=VALUES(nombre_empresa), rfc_empresa=VALUES(rfc_empresa), razon_social=VALUES(razon_social), empresa_telefono=VALUES(empresa_telefono), empresa_correo=VALUES(empresa_correo), contrasena=VALUES(contrasena), id_ubicacion=VALUES(id_ubicacion), representante_nombre=VALUES(representante_nombre);

-- Products
INSERT INTO productos (id_producto, nombre, fecha_caducidad, id_tipo_producto) VALUES
 (1,'Pan Integral', DATE_ADD(CURDATE(), INTERVAL 30 DAY), 3),
 (2,'Manzana', DATE_ADD(CURDATE(), INTERVAL 20 DAY), 1),
 (3,'Lechuga', DATE_ADD(CURDATE(), INTERVAL 10 DAY), 2)
ON DUPLICATE KEY UPDATE nombre=VALUES(nombre), fecha_caducidad=VALUES(fecha_caducidad), id_tipo_producto=VALUES(id_tipo_producto);

-- Stocks
INSERT INTO stocks (id_stock, id_producto, id_escuela, cantidad_entrada, cantidad_salida, fecha_entrada) VALUES
 (1,1,1,100,0,CURDATE()),
 (2,2,1,50,0,CURDATE()),
 (3,3,2,30,0,CURDATE())
ON DUPLICATE KEY UPDATE cantidad_entrada=VALUES(cantidad_entrada), cantidad_salida=VALUES(cantidad_salida), fecha_entrada=VALUES(fecha_entrada);

-- Paquetes and pivot
INSERT INTO paquetes (id_paquete, nombre, descripcion, fecha_creacion, id_admin) VALUES
 (1,'Paquete Escolar A','Paquete básico de alimentos',CURDATE(),1)
ON DUPLICATE KEY UPDATE nombre=VALUES(nombre), descripcion=VALUES(descripcion), fecha_creacion=VALUES(fecha_creacion), id_admin=VALUES(id_admin);

INSERT INTO paquetes_stock (id_paquete, id_stock, cantidad) VALUES
 (1,1,10),(1,2,5)
ON DUPLICATE KEY UPDATE cantidad=VALUES(cantidad);

-- Donations
INSERT INTO donaciones (id_donacion, id_donador, id_escuela, fecha_donacion, id_estado_entrega) VALUES
 (1,1,1,CURDATE(),1)
ON DUPLICATE KEY UPDATE id_donador=VALUES(id_donador), id_escuela=VALUES(id_escuela), fecha_donacion=VALUES(fecha_donacion), id_estado_entrega=VALUES(id_estado_entrega);

INSERT INTO detalle_donaciones (id_detalle_donacion, id_donacion, id_producto, cantidad) VALUES
 (1,1,1,20),(2,1,2,10)
ON DUPLICATE KEY UPDATE id_donacion=VALUES(id_donacion), id_producto=VALUES(id_producto), cantidad=VALUES(cantidad);

-- Allergies
INSERT INTO alergias (id_alergia, descripcion_alergia) VALUES
 (1,'Sin alergias conocidas'),(2,'Alergia a frutos secos')
ON DUPLICATE KEY UPDATE descripcion_alergia=VALUES(descripcion_alergia);

INSERT INTO usuarios_alergias (id_usuario, id_alergia) VALUES
 (1,1)
ON DUPLICATE KEY UPDATE id_alergia=VALUES(id_alergia);

-- Messaging (conversations)
INSERT INTO conversaciones (id_conversacion, asunto, fecha_creacion, estado) VALUES
 (1,'Coordinación de entrega', CURDATE(), 'abierta')
ON DUPLICATE KEY UPDATE asunto=VALUES(asunto), fecha_creacion=VALUES(fecha_creacion), estado=VALUES(estado);

INSERT INTO registro_conversaciones (id_participante, id_conversacion, tipo_participante, id_participante_ref, rol) VALUES
 (1,1,'usuario',2,'administrador'),(2,1,'donador',1,'donador')
ON DUPLICATE KEY UPDATE id_conversacion=VALUES(id_conversacion), tipo_participante=VALUES(tipo_participante), id_participante_ref=VALUES(id_participante_ref), rol=VALUES(rol);

INSERT INTO mensajes (id_mensaje, id_conversacion, sender_type, sender_id, contenido, fecha_envio, leido) VALUES
 (1,1,'usuario',2,'Hola, podemos coordinar la entrega el próximo martes?',NOW(),FALSE),(2,1,'donador',1,'Sí, martes por la mañana está bien.',NOW(),FALSE)
ON DUPLICATE KEY UPDATE contenido=VALUES(contenido), fecha_envio=VALUES(fecha_envio), leido=VALUES(leido);

-- Example entrega (delivery) created from paquete 1 to alumno 1
INSERT INTO entregas (id_entrega, fecha, id_paquete, id_alumno, id_estado_entrega) VALUES
 (1,CURDATE(),1,1,2)
ON DUPLICATE KEY UPDATE fecha=VALUES(fecha), id_paquete=VALUES(id_paquete), id_alumno=VALUES(id_alumno), id_estado_entrega=VALUES(id_estado_entrega);

SET FOREIGN_KEY_CHECKS = 1;

-- End of sample data
