-- ============================================
-- Script de Creación de Base de Datos
-- Sistema: Bocaditos - Sistema de Donaciones Alimentarias
-- Versión: 1.0.0
-- Fecha: 2025-11-04
-- Motor: PostgreSQL 14+
-- Adaptado de: MySQL/MariaDB Schema Original
-- ============================================

-- Crear base de datos
CREATE DATABASE bocaditos_db
    WITH 
    ENCODING = 'UTF8'
    LC_COLLATE = 'es_ES.UTF-8'
    LC_CTYPE = 'es_ES.UTF-8'
    TEMPLATE = template0;

-- Conectar a la base de datos
\c bocaditos_db;

-- Crear extensiones necesarias
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================
-- TABLA: donador
-- Descripción: Almacena información de donadores
-- ============================================
CREATE TABLE donador (
    id_donador INTEGER PRIMARY KEY,
    nombre VARCHAR(60) NOT NULL,
    correo VARCHAR(150) NOT NULL,
    celular VARCHAR(10) NOT NULL,
    direccion VARCHAR(255) NOT NULL
);

-- Índices para donador
CREATE INDEX idx_donador_nombre ON donador(nombre);
CREATE INDEX idx_donador_correo ON donador(correo);

-- Comentarios
COMMENT ON TABLE donador IS 'Tabla de donadores del sistema';
COMMENT ON COLUMN donador.id_donador IS 'Identificador único del donador';
COMMENT ON COLUMN donador.correo IS 'Correo electrónico del donador';

-- ============================================
-- TABLA: donacion
-- Descripción: Almacena información de donaciones
-- ============================================
CREATE TABLE donacion (
    id_donacion INTEGER PRIMARY KEY,
    cantidad INTEGER NOT NULL,
    destino VARCHAR(255) NOT NULL,
    fecha_donacion DATE NOT NULL,
    id_donador INTEGER NOT NULL,
    CONSTRAINT fk_donacion_donador FOREIGN KEY (id_donador) 
        REFERENCES donador(id_donador) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT chk_cantidad CHECK (cantidad > 0)
);

-- Índices para donacion
CREATE INDEX idx_donacion_donador ON donacion(id_donador);
CREATE INDEX idx_donacion_fecha ON donacion(fecha_donacion);

-- Comentarios
COMMENT ON TABLE donacion IS 'Tabla de donaciones realizadas';
COMMENT ON COLUMN donacion.cantidad IS 'Cantidad de alimentos donados';
COMMENT ON COLUMN donacion.destino IS 'Destino de la donación';

-- ============================================
-- TABLA: escuela
-- Descripción: Almacena información de escuelas
-- ============================================
CREATE TABLE escuela (
    id_escuela INTEGER PRIMARY KEY,
    nombre VARCHAR(60) NOT NULL,
    ubicacion VARCHAR(255) NOT NULL,
    id_donacion INTEGER NOT NULL,
    CONSTRAINT fk_escuela_donacion FOREIGN KEY (id_donacion) 
        REFERENCES donacion(id_donacion) ON DELETE RESTRICT ON UPDATE RESTRICT
);

-- Índices para escuela
CREATE INDEX idx_escuela_nombre ON escuela(nombre);
CREATE INDEX idx_escuela_donacion ON escuela(id_donacion);

-- Comentarios
COMMENT ON TABLE escuela IS 'Tabla de escuelas beneficiarias';
COMMENT ON COLUMN escuela.ubicacion IS 'Ubicación física de la escuela';

-- ============================================
-- TABLA: administrador
-- Descripción: Almacena información de administradores
-- ============================================
CREATE TABLE administrador (
    id_admi INTEGER PRIMARY KEY,
    nombre VARCHAR(60) NOT NULL,
    numero VARCHAR(10) NOT NULL,
    correo VARCHAR(100) NOT NULL,
    id_escuela INTEGER NOT NULL,
    CONSTRAINT fk_administrador_escuela FOREIGN KEY (id_escuela) 
        REFERENCES escuela(id_escuela) ON DELETE RESTRICT ON UPDATE RESTRICT
);

-- Índices para administrador
CREATE INDEX idx_administrador_nombre ON administrador(nombre);
CREATE INDEX idx_administrador_escuela ON administrador(id_escuela);
CREATE INDEX idx_administrador_correo ON administrador(correo);

-- Comentarios
COMMENT ON TABLE administrador IS 'Tabla de administradores del sistema';
COMMENT ON COLUMN administrador.numero IS 'Número de teléfono del administrador';

-- ============================================
-- TABLA: alumno
-- Descripción: Almacena información de alumnos
-- ============================================
CREATE TABLE alumno (
    id_alumno INTEGER PRIMARY KEY,
    nombre VARCHAR(60) NOT NULL,
    apellido VARCHAR(60) NOT NULL,
    grupo VARCHAR(10) NOT NULL,
    cuatrimestre VARCHAR(10) NOT NULL,
    matricula VARCHAR(7) NOT NULL UNIQUE,
    id_escuela INTEGER NOT NULL
);

-- Índices para alumno
CREATE INDEX idx_alumno_nombre ON alumno(nombre, apellido);
CREATE INDEX idx_alumno_matricula ON alumno(matricula);
CREATE INDEX idx_alumno_grupo ON alumno(grupo);
CREATE INDEX idx_alumno_escuela ON alumno(id_escuela);

-- Comentarios
COMMENT ON TABLE alumno IS 'Tabla de alumnos beneficiarios';
COMMENT ON COLUMN alumno.matricula IS 'Matrícula única del alumno';
COMMENT ON COLUMN alumno.grupo IS 'Grupo al que pertenece el alumno';
COMMENT ON COLUMN alumno.cuatrimestre IS 'Cuatrimestre actual del alumno';

-- ============================================
-- TABLA: comida
-- Descripción: Almacena información de alimentos
-- ============================================
CREATE TABLE comida (
    id_comida INTEGER PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    tipo_comida VARCHAR(50) NOT NULL,
    fecha_caducidad DATE NOT NULL,
    id_donacion INTEGER NOT NULL
);

-- Índices para comida
CREATE INDEX idx_comida_nombre ON comida(nombre);
CREATE INDEX idx_comida_tipo ON comida(tipo_comida);
CREATE INDEX idx_comida_fecha_caducidad ON comida(fecha_caducidad);
CREATE INDEX idx_comida_donacion ON comida(id_donacion);

-- Comentarios
COMMENT ON TABLE comida IS 'Catálogo de alimentos donados';
COMMENT ON COLUMN comida.tipo_comida IS 'Tipo de alimento (bebida, snack, plato principal, etc.)';
COMMENT ON COLUMN comida.fecha_caducidad IS 'Fecha de caducidad del alimento';

-- ============================================
-- TABLA: entrega
-- Descripción: Almacena información de entregas
-- ============================================
CREATE TABLE entrega (
    id_entrega INTEGER PRIMARY KEY,
    estado VARCHAR(20) NOT NULL,
    fecha_entrega DATE NOT NULL,
    id_admin INTEGER NOT NULL,
    id_donacion INTEGER NOT NULL,
    CONSTRAINT fk_entrega_administrador FOREIGN KEY (id_admin) 
        REFERENCES administrador(id_admi) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT fk_entrega_donacion FOREIGN KEY (id_donacion) 
        REFERENCES donacion(id_donacion) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT chk_estado CHECK (estado IN ('pendiente', 'en_proceso', 'completada', 'cancelada'))
);

-- Índices para entrega
CREATE INDEX idx_entrega_fecha ON entrega(fecha_entrega);
CREATE INDEX idx_entrega_estado ON entrega(estado);
CREATE INDEX idx_entrega_admin ON entrega(id_admin);
CREATE INDEX idx_entrega_donacion ON entrega(id_donacion);

-- Comentarios
COMMENT ON TABLE entrega IS 'Tabla de entregas de donaciones';
COMMENT ON COLUMN entrega.estado IS 'Estado de la entrega: pendiente, en_proceso, completada, cancelada';

-- ============================================
-- VISTAS
-- ============================================

-- Vista: Donaciones con información del donador
CREATE VIEW v_donaciones_completas AS
SELECT 
    d.id_donacion,
    d.cantidad,
    d.destino,
    d.fecha_donacion,
    don.nombre AS donador,
    don.correo AS correo_donador,
    don.celular AS celular_donador
FROM donacion d
JOIN donador don ON d.id_donador = don.id_donador
ORDER BY d.fecha_donacion DESC;

-- Vista: Entregas con detalles
CREATE VIEW v_entregas_detalladas AS
SELECT 
    e.id_entrega,
    e.estado,
    e.fecha_entrega,
    a.nombre AS administrador,
    a.correo AS correo_admin,
    esc.nombre AS escuela,
    d.cantidad AS cantidad_donacion,
    d.destino
FROM entrega e
JOIN administrador a ON e.id_admin = a.id_admi
JOIN escuela esc ON a.id_escuela = esc.id_escuela
JOIN donacion d ON e.id_donacion = d.id_donacion
ORDER BY e.fecha_entrega DESC;

-- Vista: Alumnos por escuela
CREATE VIEW v_alumnos_por_escuela AS
SELECT 
    al.id_alumno,
    al.nombre || ' ' || al.apellido AS alumno_completo,
    al.matricula,
    al.grupo,
    al.cuatrimestre,
    al.id_escuela
FROM alumno al
ORDER BY al.id_escuela, al.grupo, al.nombre;

-- Vista: Comidas próximas a caducar (30 días)
CREATE VIEW v_comidas_proximas_caducar AS
SELECT 
    c.id_comida,
    c.nombre,
    c.tipo_comida,
    c.fecha_caducidad,
    CURRENT_DATE - c.fecha_caducidad AS dias_hasta_caducidad,
    d.destino,
    d.cantidad
FROM comida c
JOIN donacion d ON c.id_donacion = d.id_donacion
WHERE c.fecha_caducidad BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '30 days'
ORDER BY c.fecha_caducidad ASC;

-- ============================================
-- FUNCIONES Y TRIGGERS
-- ============================================

-- Función: Validar fecha de caducidad
CREATE OR REPLACE FUNCTION validar_fecha_caducidad()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.fecha_caducidad < CURRENT_DATE THEN
        RAISE EXCEPTION 'La fecha de caducidad no puede ser anterior a la fecha actual';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger: Validar fecha de caducidad al insertar comida
CREATE TRIGGER trg_validar_fecha_caducidad
BEFORE INSERT OR UPDATE ON comida
FOR EACH ROW
EXECUTE FUNCTION validar_fecha_caducidad();

-- Función: Actualizar estado de entrega
CREATE OR REPLACE FUNCTION actualizar_estado_entrega()
RETURNS TRIGGER AS $$
BEGIN
    -- Log de cambio de estado
    IF OLD.estado != NEW.estado THEN
        RAISE NOTICE 'Estado de entrega % cambiado de % a %', NEW.id_entrega, OLD.estado, NEW.estado;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger: Registrar cambios de estado
CREATE TRIGGER trg_actualizar_estado_entrega
AFTER UPDATE ON entrega
FOR EACH ROW
EXECUTE FUNCTION actualizar_estado_entrega();

-- ============================================
-- PERMISOS (Roles básicos)
-- ============================================

-- Crear roles
CREATE ROLE bocaditos_admin;
CREATE ROLE bocaditos_user;
CREATE ROLE bocaditos_readonly;

-- Permisos para admin (todos)
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO bocaditos_admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO bocaditos_admin;

-- Permisos para usuarios (CRUD básico)
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA public TO bocaditos_user;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO bocaditos_user;

-- Permisos para solo lectura
GRANT SELECT ON ALL TABLES IN SCHEMA public TO bocaditos_readonly;

-- ============================================
-- DATOS INICIALES (Opcional)
-- ============================================

-- Script completado
SELECT 'Base de datos Bocaditos creada exitosamente' AS mensaje;
