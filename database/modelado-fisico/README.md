# Modelado Físico de Base de Datos - Sistema Bocaditos

## Descripción General
Este documento describe el modelo físico de la base de datos para el sistema de donaciones alimentarias "Bocaditos" en UTRM, implementado en **MySQL/MariaDB**.

## Especificaciones Técnicas

- **Motor de Base de Datos**: MySQL 8.0+ / MariaDB 10.4+
- **Charset**: utf8mb4
- **Collation**: utf8mb4_general_ci
- **Storage Engine**: InnoDB
- **Zona Horaria**: America/Mexico_City

## Tablas (resumen actualizado)

Esta sección resume el modelo físico actual tal como está definido en `database/sql/ddl/01_create_schema.sql` (v2.0.1).

- `tipo_producto` (catálogo): `id_tipo_producto` (PK), `nombre_tipo` (ENUM).
- `producto`: `id_producto` (PK), `nombre`, `fecha_caducidad`, `id_tipo_producto` (FK).
- `estado_donacion`: `id_estado_donacion` (PK), `nombre_estado` (ENUM).
- `estado`: `id_estado` (PK), `nombre_estado` (UNIQUE) — usado por `ciudad`.
- `ciudad`: `id_ciudad` (PK), `nombre_ciudad`, `id_estado` (FK).
- `ubicacion`: `id_ubicacion` (PK), `direccion`, `codigo_postal`, `id_ciudad` (FK).
- `escuela`: `id_escuela` (PK), `nombre`, `id_ubicacion` (FK).
- `rol`: `id_rol` (PK), `nombre_rol` (ENUM: 'alumno','administrador').
- `usuario`: `id_usuario` (PK), `nombre`, `apellido`, `telefono`, `matricula`, `cuatrimestre`, `correo` (UNIQUE), `contrasena`, `id_rol` (FK), `id_escuela` (FK), `id_ubicacion` (FK).
- `comentario_alumno`: `id_comentario` (PK), `id_alumno` (FK->usuario), `contenido`, `fecha_envio`.
- `administrador`: `id_admin` (PK), `id_usuario` (FK UNIQUE), `fecha_asignacion`.
- `donador`: `id_donador` (PK), `nombre`, `rfc` (UNIQUE), `razon_social`, `telefono`, `correo`, `contrasena`, `id_ubicacion` (FK).
- `donacion`: `id_donacion` (PK), `id_donador` (FK), `id_escuela` (FK), `fecha_donacion`, `id_estado_donacion` (FK).
- `detalle_donacion`: `id_detalle_donacion` (PK), `id_donacion` (FK), `id_producto` (FK), `cantidad` (CHECK > 0).
-- `stocks`: `id_stock` (PK), `id_producto` (FK), `id_escuela` (FK), `cantidad_entrada`, `cantidad_salida`, fechas (entrada/salida). La columna `cantidad_disponible` fue removida y se calcula mediante la vista `vw_stock_disponible` (cantidad_entrada - cantidad_salida). Se creó un índice UNIQUE `(id_producto,id_escuela)` para soportar `INSERT ... ON DUPLICATE KEY UPDATE`.
- `paquete`: `id_paquete` (PK), `nombre`, `descripcion`, `fecha_creacion`, `id_admin` (FK).
- `paquete_stock`: pivote (`id_paquete`, `id_stock`) PK compuesta, `cantidad`.
- `entrega`: `id_entrega` (PK), `fecha`, `id_paquete` (FK), `id_alumno` (FK->usuario).
- `alergia`: `id_alergia` (PK), `descripcion_alergia`.
- `usuario_alergia`: pivote (`id_usuario`, `id_alergia`) PK compuesta.
- Mensajería:
    - `conversacion`: `id_conversacion` (PK), `asunto`, `fecha_creacion`, `fecha_ultimo_mensaje`, `estado` (ENUM).
    - `conversacion_participante`: `id_participante` (PK), `id_conversacion` (FK), `id_usuario` (nullable), `id_donador` (nullable), `rol` (ENUM), con CHECK que obliga a uno de los dos (usuario o donador).
    - `mensaje`: `id_mensaje` (PK), `id_conversacion` (FK), `id_usuario` (nullable), `id_donador` (nullable), `contenido`, `fecha_envio`, `leido`, con CHECK que obliga a un emisor válido.

## Triggers y Procedimientos

- Triggers de validación de producto:
    - `trg_validar_fecha_caducidad_insert` (BEFORE INSERT ON `producto`): evita insertar `fecha_caducidad` menor a `CURDATE()`.
    - `trg_validar_fecha_caducidad_update` (BEFORE UPDATE ON `producto`).
- Mensajería:
    - `trg_update_fecha_ultimo_mensaje` (AFTER INSERT ON `mensaje`): actualiza `conversacion.fecha_ultimo_mensaje`.
- Procedimientos almacenados:
    - `registrar_entrega(alumno_id, paquete_id, entrega_fecha)`: inserta en `entrega` y actualiza `stock` según `paquete_stock`.
    - `registrar_donacion(donador_id, escuela_id, estado_id, producto_id, cantidad)`: inserta `donacion`, `detalle_donacion` y actualiza `stock` con `ON DUPLICATE KEY UPDATE`.


## Triggers

### 1. trg_validar_fecha_caducidad_insert
**Tipo**: Trigger BEFORE INSERT
**Propósito**: Validar que la fecha de caducidad no sea anterior a la fecha actual
**Tabla**: comida

### 2. trg_validar_fecha_caducidad_update
**Tipo**: Trigger BEFORE UPDATE
**Propósito**: Validar que la fecha de caducidad no sea anterior a la fecha actual
**Tabla**: comida

## Estrategias de Almacenamiento

### Storage Engine
- **InnoDB**: Usado en todas las tablas para soporte completo de transacciones y foreign keys

### Índices
- **Claves Primarias**: AUTO_INCREMENT con índice automático
- **Claves Foráneas**: Índices en todas las FKs para optimizar JOINs
- **Campos de Búsqueda**: Índices en campos frecuentemente consultados (nombres, correos, fechas)
- **Campos Únicos**: Índice UNIQUE en matrícula de alumnos

### Restricciones de Integridad
- **ON DELETE RESTRICT**: Evita eliminación de registros con dependencias
- **ON UPDATE RESTRICT**: Evita actualización de PKs referenciadas
- **CHECK Constraints**: Validación de cantidades positivas y estados válidos
- **UNIQUE Constraints**: Matrícula única por alumno

## Características MySQL/MariaDB

| Característica | Implementación |
|----------------|----------------|
| Auto-incremento | AUTO_INCREMENT en PKs |
| Motor | ENGINE = InnoDB |
| Charset | utf8mb4 |
| Collation | utf8mb4_general_ci |
| Foreign Keys | CONSTRAINT con nombres descriptivos |
| Índices | Definidos en CREATE TABLE |
| Triggers | DELIMITER $$ syntax |
| Vistas | CREATE OR REPLACE VIEW |

## Consideraciones de Performance

### 1. Índices Optimizados
- Índices compuestos en (nombre, apellido) para búsquedas frecuentes
- Índices en fechas para consultas de rango
- Índices en claves foráneas para mejorar JOINs

### 2. Optimización de Queries
- Uso de vistas para consultas frecuentes
- Query cache habilitado
- Índices en campos de búsqueda y filtrado


## Requerimientos de Hardware

### Desarrollo
- CPU: 2 cores
- RAM: 2 GB
- Disco: 10 GB
- Conexiones simultáneas: 10

### Producción
- CPU: 4+ cores
- RAM: 8 GB
- Disco: 50 GB SSD
- Conexiones simultáneas: 50
- Backup storage: 100 GB

## Seguridad

### Usuarios MySQL
1. **root**: Acceso completo (solo local)
2. **bocaditos_admin**: Acceso completo a bocaditos_db
3. **bocaditos_app**: Acceso de aplicación (CRUD)
4. **bocaditos_readonly**: Solo lectura

## Backup y Recuperación

### Estrategia de Backup
- **Completo**: Semanal (Domingos 02:00 AM)
- **Incremental**: Diario (02:00 AM) con binary logs
- **Retención**: 30 días en línea, 1 año en archivo

### Comandos de Backup MySQL
```bash
# Backup completo
mysqldump -u root -p bocaditos_db > backup_$(date +%Y%m%d).sql

# Backup solo estructura
mysqldump -u root -p --no-data bocaditos_db > schema.sql

# Backup solo datos
mysqldump -u root -p --no-create-info bocaditos_db > data.sql

# Backup con compresión
mysqldump -u root -p bocaditos_db | gzip > backup_$(date +%Y%m%d).sql.gz
```

### Restauración
```bash
# Restaurar desde backup
mysql -u root -p bocaditos_db < backup_20251104.sql

# Restaurar desde backup comprimido
gunzip < backup_20251104.sql.gz | mysql -u root -p bocaditos_db
```

## Configuración Recomendada my.cnf
# Character set
character-set-server = utf8mb4
collation-server = utf8mb4_general_ci

# Logs
slow_query_log = 1
slow_query_log_file = /var/log/mysql/slow-query.log
long_query_time = 2

# Binary log para backups incrementales
log_bin = /var/log/mysql/mysql-bin.log
expire_logs_days = 7
```

---

## Cambios recientes (2025-11-25)
Se agregan aquí las notas de los cambios realizados en la versión del DDL publicada el 2025-11-25.

- Pluralización y estandarización de nombres de objetos en el DDL.
- Nueva tabla `estados_entregas` para modelar estados de entrega/donación.
- `ubicaciones` ahora incluye `id_estado` además de `id_ciudad`; esto permite seleccionar estado/ciudad o crear una ubicación nueva en la UX.
- `donadores` ampliada para soportar donantes institucionales (`razon_social`, representante, campos adicionales).
- `stocks` fue refactorizada para registrar `cantidad_entrada` y `cantidad_salida`; se eliminó la columna calculada y se creó la vista `vw_stock_disponible` que expone `cantidad_disponible` = `cantidad_entrada - cantidad_salida`.
- Introducción de `paquetes` y `paquetes_stock` (tabla pivote) para agrupar unidades y gestionar entregas por paquete.
- Procedimientos almacenados añadidos/actualizados: `registrar_entrega`, `registrar_donacion`, `crear_paquete`, `agregar_producto_a_paquete`, `entregar_paquete`.

Notas de migración:
- Antes de ejecutar migraciones sobre datos existentes hacer un respaldo completo (`mysqldump`).
- Se preparó una consulta para poblar `ubicaciones.id_estado` desde `ciudades` si se desea ejecutar la migración de forma segura; no se ejecutó automáticamente.

Referencias:
- `database/sql/ddl/01_create_schema.sql` (commit reciente en `main`): revisión y objetos añadidos.

