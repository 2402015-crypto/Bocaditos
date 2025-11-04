-- ============================================
-- Script de Creación de Base de Datos
-- Sistema: Bocaditos - Apoyo Alimentario Escolar UTRM
-- Versión: 1.0.0
-- Fecha: 2025-11-04
-- Motor: PostgreSQL 14+
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
-- TABLA: tutor
-- Descripción: Almacena información de tutores/padres
-- ============================================
CREATE TABLE tutor (
    id_tutor SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    direccion TEXT,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    activo BOOLEAN DEFAULT TRUE
);

-- Índices para tutor
CREATE INDEX idx_tutor_nombre ON tutor(nombre, apellido);
CREATE INDEX idx_tutor_email ON tutor(email);

-- Comentarios
COMMENT ON TABLE tutor IS 'Tabla de tutores o padres de familia';
COMMENT ON COLUMN tutor.id_tutor IS 'Identificador único del tutor';
COMMENT ON COLUMN tutor.email IS 'Correo electrónico único del tutor';

-- ============================================
-- TABLA: estudiante
-- Descripción: Almacena información de estudiantes
-- ============================================
CREATE TABLE estudiante (
    id_estudiante SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    grado VARCHAR(20) NOT NULL,
    id_tutor INTEGER NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    activo BOOLEAN DEFAULT TRUE,
    CONSTRAINT fk_estudiante_tutor FOREIGN KEY (id_tutor) 
        REFERENCES tutor(id_tutor) ON DELETE RESTRICT,
    CONSTRAINT chk_fecha_nacimiento CHECK (fecha_nacimiento < CURRENT_DATE),
    CONSTRAINT chk_grado CHECK (grado IN ('1ro', '2do', '3ro', '4to', '5to', '6to', '7mo', '8vo', '9no', '10mo'))
);

-- Índices para estudiante
CREATE INDEX idx_estudiante_tutor ON estudiante(id_tutor);
CREATE INDEX idx_estudiante_grado ON estudiante(grado);
CREATE INDEX idx_estudiante_nombre ON estudiante(nombre, apellido);

-- Comentarios
COMMENT ON TABLE estudiante IS 'Tabla de estudiantes del sistema';
COMMENT ON COLUMN estudiante.grado IS 'Grado académico del estudiante';

-- ============================================
-- TABLA: bocadito
-- Descripción: Catálogo de alimentos disponibles
-- ============================================
CREATE TABLE bocadito (
    id_bocadito SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    categoria VARCHAR(50) NOT NULL,
    calorias INTEGER,
    precio DECIMAL(10,2) NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    activo BOOLEAN DEFAULT TRUE,
    CONSTRAINT chk_calorias CHECK (calorias >= 0),
    CONSTRAINT chk_precio CHECK (precio > 0),
    CONSTRAINT chk_categoria CHECK (categoria IN ('bebida', 'sandwich', 'fruta', 'snack', 'postre', 'plato_principal'))
);

-- Índices para bocadito
CREATE INDEX idx_bocadito_categoria ON bocadito(categoria);
CREATE INDEX idx_bocadito_nombre ON bocadito(nombre);
CREATE INDEX idx_bocadito_activo ON bocadito(activo);

-- Comentarios
COMMENT ON TABLE bocadito IS 'Catálogo de alimentos y bocaditos disponibles';
COMMENT ON COLUMN bocadito.categoria IS 'Categoría del alimento';
COMMENT ON COLUMN bocadito.calorias IS 'Contenido calórico aproximado';

-- ============================================
-- TABLA: menu_diario
-- Descripción: Menús diarios disponibles
-- ============================================
CREATE TABLE menu_diario (
    id_menu SERIAL PRIMARY KEY,
    fecha DATE NOT NULL UNIQUE,
    descripcion TEXT,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    activo BOOLEAN DEFAULT TRUE,
    CONSTRAINT chk_fecha_menu CHECK (fecha >= CURRENT_DATE - INTERVAL '30 days')
);

-- Índices para menu_diario
CREATE INDEX idx_menu_fecha ON menu_diario(fecha);
CREATE INDEX idx_menu_activo ON menu_diario(activo);

-- Comentarios
COMMENT ON TABLE menu_diario IS 'Menús diarios del sistema';
COMMENT ON COLUMN menu_diario.fecha IS 'Fecha del menú (única)';

-- ============================================
-- TABLA: menu_bocadito
-- Descripción: Relación entre menús y bocaditos
-- ============================================
CREATE TABLE menu_bocadito (
    id_menu INTEGER NOT NULL,
    id_bocadito INTEGER NOT NULL,
    cantidad_disponible INTEGER NOT NULL DEFAULT 0,
    PRIMARY KEY (id_menu, id_bocadito),
    CONSTRAINT fk_menu_bocadito_menu FOREIGN KEY (id_menu) 
        REFERENCES menu_diario(id_menu) ON DELETE CASCADE,
    CONSTRAINT fk_menu_bocadito_bocadito FOREIGN KEY (id_bocadito) 
        REFERENCES bocadito(id_bocadito) ON DELETE RESTRICT,
    CONSTRAINT chk_cantidad CHECK (cantidad_disponible >= 0)
);

-- Índices para menu_bocadito
CREATE INDEX idx_menu_bocadito_menu ON menu_bocadito(id_menu);
CREATE INDEX idx_menu_bocadito_bocadito ON menu_bocadito(id_bocadito);

-- Comentarios
COMMENT ON TABLE menu_bocadito IS 'Relación entre menús diarios y bocaditos disponibles';
COMMENT ON COLUMN menu_bocadito.cantidad_disponible IS 'Cantidad disponible para ese día';

-- ============================================
-- TABLA: responsable
-- Descripción: Personal responsable de entregas
-- ============================================
CREATE TABLE responsable (
    id_responsable SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    cargo VARCHAR(100) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    activo BOOLEAN DEFAULT TRUE,
    CONSTRAINT chk_cargo CHECK (cargo IN ('coordinador', 'asistente', 'voluntario', 'supervisor'))
);

-- Índices para responsable
CREATE INDEX idx_responsable_cargo ON responsable(cargo);
CREATE INDEX idx_responsable_activo ON responsable(activo);

-- Comentarios
COMMENT ON TABLE responsable IS 'Personal responsable de las entregas';
COMMENT ON COLUMN responsable.cargo IS 'Cargo o función del responsable';

-- ============================================
-- TABLA: pedido
-- Descripción: Pedidos de estudiantes
-- ============================================
CREATE TABLE pedido (
    id_pedido SERIAL PRIMARY KEY,
    id_estudiante INTEGER NOT NULL,
    id_menu INTEGER NOT NULL,
    fecha_pedido TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado VARCHAR(20) NOT NULL DEFAULT 'pendiente',
    notas TEXT,
    CONSTRAINT fk_pedido_estudiante FOREIGN KEY (id_estudiante) 
        REFERENCES estudiante(id_estudiante) ON DELETE RESTRICT,
    CONSTRAINT fk_pedido_menu FOREIGN KEY (id_menu) 
        REFERENCES menu_diario(id_menu) ON DELETE RESTRICT,
    CONSTRAINT chk_estado CHECK (estado IN ('pendiente', 'confirmado', 'entregado', 'cancelado')),
    CONSTRAINT uk_pedido_estudiante_menu UNIQUE (id_estudiante, id_menu)
);

-- Índices para pedido
CREATE INDEX idx_pedido_estudiante ON pedido(id_estudiante);
CREATE INDEX idx_pedido_menu ON pedido(id_menu);
CREATE INDEX idx_pedido_fecha ON pedido(fecha_pedido);
CREATE INDEX idx_pedido_estado ON pedido(estado);

-- Comentarios
COMMENT ON TABLE pedido IS 'Pedidos realizados por estudiantes';
COMMENT ON COLUMN pedido.estado IS 'Estado del pedido: pendiente, confirmado, entregado, cancelado';
COMMENT ON CONSTRAINT uk_pedido_estudiante_menu ON pedido IS 'Un estudiante solo puede hacer un pedido por menú';

-- ============================================
-- TABLA: entrega
-- Descripción: Entregas de pedidos
-- ============================================
CREATE TABLE entrega (
    id_entrega SERIAL PRIMARY KEY,
    id_pedido INTEGER NOT NULL UNIQUE,
    fecha_entrega TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_responsable INTEGER NOT NULL,
    observaciones TEXT,
    CONSTRAINT fk_entrega_pedido FOREIGN KEY (id_pedido) 
        REFERENCES pedido(id_pedido) ON DELETE RESTRICT,
    CONSTRAINT fk_entrega_responsable FOREIGN KEY (id_responsable) 
        REFERENCES responsable(id_responsable) ON DELETE RESTRICT
);

-- Índices para entrega
CREATE INDEX idx_entrega_pedido ON entrega(id_pedido);
CREATE INDEX idx_entrega_fecha ON entrega(fecha_entrega);
CREATE INDEX idx_entrega_responsable ON entrega(id_responsable);

-- Comentarios
COMMENT ON TABLE entrega IS 'Registro de entregas de pedidos';
COMMENT ON COLUMN entrega.fecha_entrega IS 'Fecha y hora de la entrega';

-- ============================================
-- VISTAS
-- ============================================

-- Vista: Resumen de pedidos por estudiante
CREATE VIEW v_pedidos_estudiante AS
SELECT 
    e.id_estudiante,
    e.nombre || ' ' || e.apellido AS estudiante,
    e.grado,
    t.nombre || ' ' || t.apellido AS tutor,
    COUNT(p.id_pedido) AS total_pedidos,
    SUM(CASE WHEN p.estado = 'entregado' THEN 1 ELSE 0 END) AS pedidos_entregados,
    SUM(CASE WHEN p.estado = 'pendiente' THEN 1 ELSE 0 END) AS pedidos_pendientes
FROM estudiante e
LEFT JOIN tutor t ON e.id_tutor = t.id_tutor
LEFT JOIN pedido p ON e.id_estudiante = p.id_estudiante
GROUP BY e.id_estudiante, e.nombre, e.apellido, e.grado, t.nombre, t.apellido;

-- Vista: Menú del día con bocaditos
CREATE VIEW v_menu_del_dia AS
SELECT 
    m.id_menu,
    m.fecha,
    m.descripcion AS menu_descripcion,
    b.nombre AS bocadito,
    b.categoria,
    b.precio,
    mb.cantidad_disponible
FROM menu_diario m
JOIN menu_bocadito mb ON m.id_menu = mb.id_menu
JOIN bocadito b ON mb.id_bocadito = b.id_bocadito
WHERE m.activo = TRUE AND b.activo = TRUE
ORDER BY m.fecha DESC, b.categoria;

-- Vista: Entregas por responsable
CREATE VIEW v_entregas_responsable AS
SELECT 
    r.id_responsable,
    r.nombre || ' ' || r.apellido AS responsable,
    r.cargo,
    COUNT(ent.id_entrega) AS total_entregas,
    DATE(ent.fecha_entrega) AS fecha
FROM responsable r
LEFT JOIN entrega ent ON r.id_responsable = ent.id_responsable
GROUP BY r.id_responsable, r.nombre, r.apellido, r.cargo, DATE(ent.fecha_entrega);

-- ============================================
-- FUNCIONES Y TRIGGERS
-- ============================================

-- Función: Actualizar cantidad disponible al crear pedido
CREATE OR REPLACE FUNCTION actualizar_cantidad_disponible()
RETURNS TRIGGER AS $$
BEGIN
    -- Decrementar cantidad disponible cuando se confirma un pedido
    IF NEW.estado = 'confirmado' AND (OLD.estado IS NULL OR OLD.estado != 'confirmado') THEN
        UPDATE menu_bocadito
        SET cantidad_disponible = cantidad_disponible - 1
        WHERE id_menu = NEW.id_menu;
    END IF;
    
    -- Incrementar cantidad si se cancela un pedido confirmado
    IF NEW.estado = 'cancelado' AND OLD.estado = 'confirmado' THEN
        UPDATE menu_bocadito
        SET cantidad_disponible = cantidad_disponible + 1
        WHERE id_menu = NEW.id_menu;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger: Actualizar disponibilidad
CREATE TRIGGER trg_actualizar_disponibilidad
AFTER UPDATE ON pedido
FOR EACH ROW
EXECUTE FUNCTION actualizar_cantidad_disponible();

-- Función: Validar entrega solo para pedidos confirmados
CREATE OR REPLACE FUNCTION validar_entrega()
RETURNS TRIGGER AS $$
BEGIN
    IF (SELECT estado FROM pedido WHERE id_pedido = NEW.id_pedido) != 'confirmado' THEN
        RAISE EXCEPTION 'Solo se pueden entregar pedidos confirmados';
    END IF;
    
    -- Actualizar estado del pedido a entregado
    UPDATE pedido SET estado = 'entregado' WHERE id_pedido = NEW.id_pedido;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger: Validar estado antes de entrega
CREATE TRIGGER trg_validar_entrega
BEFORE INSERT ON entrega
FOR EACH ROW
EXECUTE FUNCTION validar_entrega();

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
-- DATOS INICIALES
-- ============================================

-- Script completado
SELECT 'Base de datos Bocaditos creada exitosamente' AS mensaje;
