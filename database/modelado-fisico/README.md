# Modelado Físico de Base de Datos - Sistema Bocaditos

## Descripción General
Este documento describe el modelo físico de la base de datos para el sistema de donaciones alimentarias "Bocaditos" en UTRM, implementado en **MySQL/MariaDB**. Sistema diseñado para operar en **una sola escuela**.

## Especificaciones Técnicas

- **Motor de Base de Datos**: MySQL 8.0+ / MariaDB 10.4+
- **Charset**: utf8mb4
- **Collation**: utf8mb4_general_ci
- **Storage Engine**: InnoDB
- **Zona Horaria**: America/Mexico_City

## Tablas

### 1. donador
```sql
Nombre de tabla: donador
Columnas:
- id_donador: INT AUTO_INCREMENT PRIMARY KEY
- nombre: VARCHAR(60) NOT NULL
- correo: VARCHAR(150) NOT NULL
- celular: VARCHAR(10) NOT NULL
- direccion: VARCHAR(255) NOT NULL

Índices:
- PK_donador: PRIMARY KEY (id_donador)
- IDX_donador_nombre: INDEX (nombre)
- IDX_donador_correo: INDEX (correo)

Storage Engine: InnoDB
Descripción: Almacena información de personas o instituciones que realizan donaciones.
```

### 2. donacion
```sql
Nombre de tabla: donacion
Columnas:
- id_donacion: INT AUTO_INCREMENT PRIMARY KEY
- cantidad: INT NOT NULL
- destino: VARCHAR(255) NOT NULL
- fecha_donacion: DATE NOT NULL
- id_donador: INT NOT NULL

Índices:
- PK_donacion: PRIMARY KEY (id_donacion)
- FK_donacion_donador: FOREIGN KEY (id_donador) REFERENCES donador(id_donador)
- IDX_donacion_donador: INDEX (id_donador)
- IDX_donacion_fecha: INDEX (fecha_donacion)

Constraints:
- CHECK (cantidad > 0)

Storage Engine: InnoDB
Descripción: Registra las donaciones realizadas con cantidad y destino (UTRM).
```

### 3. administrador
```sql
Nombre de tabla: administrador
Columnas:
- id_admi: INT AUTO_INCREMENT PRIMARY KEY
- nombre: VARCHAR(60) NOT NULL
- numero: VARCHAR(10) NOT NULL
- correo: VARCHAR(100) NOT NULL

Índices:
- PK_administrador: PRIMARY KEY (id_admi)
- IDX_administrador_nombre: INDEX (nombre)
- IDX_administrador_correo: INDEX (correo)

Storage Engine: InnoDB
Descripción: Personal administrativo de la escuela que gestiona las donaciones.
Nota: Simplificado para una sola escuela - no tiene FK a tabla escuela.
```

### 4. alumno
```sql
Nombre de tabla: alumno
Columnas:
- id_alumno: INT AUTO_INCREMENT PRIMARY KEY
- nombre: VARCHAR(60) NOT NULL
- apellido: VARCHAR(60) NOT NULL
- grupo: VARCHAR(10) NOT NULL
- cuatrimestre: VARCHAR(10) NOT NULL
- matricula: VARCHAR(7) NOT NULL UNIQUE
- grupo: VARCHAR(10) NOT NULL
- cuatrimestre: VARCHAR(10) NOT NULL
- matricula: VARCHAR(7) NOT NULL UNIQUE
- id_escuela: INTEGER NOT NULL

Índices:
- PK_alumno: PRIMARY KEY (id_alumno)
- UK_alumno_matricula: UNIQUE (matricula)
- IDX_alumno_nombre: INDEX (nombre, apellido)
- IDX_alumno_matricula: INDEX (matricula)
- IDX_alumno_grupo: INDEX (grupo)
- IDX_alumno_escuela: INDEX (id_escuela)


Índices:
- PK_alumno: PRIMARY KEY (id_alumno)
- UK_alumno_matricula: UNIQUE (matricula)
- IDX_alumno_nombre: INDEX (nombre, apellido)
- IDX_alumno_grupo: INDEX (grupo)

Storage Engine: InnoDB
Descripción: Estudiantes beneficiarios del programa de donaciones.
Nota: Simplificado para una sola escuela - no tiene FK a tabla escuela.
```

### 5. comida
```sql
Nombre de tabla: comida
Columnas:
- id_comida: INT AUTO_INCREMENT PRIMARY KEY
- nombre: VARCHAR(255) NOT NULL
- tipo_comida: VARCHAR(50) NOT NULL
- fecha_caducidad: DATE NOT NULL
- id_donacion: INT NOT NULL

Índices:
- PK_comida: PRIMARY KEY (id_comida)
- FK_comida_donacion: FOREIGN KEY (id_donacion) REFERENCES donacion(id_donacion)
- IDX_comida_nombre: INDEX (nombre)
- IDX_comida_tipo: INDEX (tipo_comida)
- IDX_comida_fecha_caducidad: INDEX (fecha_caducidad)
- IDX_comida_donacion: INDEX (id_donacion)

Storage Engine: InnoDB
Descripción: Catálogo de alimentos incluidos en las donaciones.
```

### 6. entrega
```sql
Nombre de tabla: entrega
Columnas:
- id_entrega: INT AUTO_INCREMENT PRIMARY KEY
- estado: VARCHAR(20) NOT NULL
- fecha_entrega: DATE NOT NULL
- id_admin: INT NOT NULL
- id_donacion: INT NOT NULL

Índices:
- PK_entrega: PRIMARY KEY (id_entrega)
- FK_entrega_administrador: FOREIGN KEY (id_admin) REFERENCES administrador(id_admi)
- FK_entrega_donacion: FOREIGN KEY (id_donacion) REFERENCES donacion(id_donacion)
- IDX_entrega_fecha: INDEX (fecha_entrega)
- IDX_entrega_estado: INDEX (estado)
- IDX_entrega_admin: INDEX (id_admin)
- IDX_entrega_donacion: INDEX (id_donacion)

Constraints:
- CHECK (estado IN ('pendiente', 'en_proceso', 'completada', 'cancelada'))

Storage Engine: InnoDB
Descripción: Registro de entregas de donaciones a la escuela.
```

## Vistas Implementadas

### 1. v_donaciones_completas
Combina información de donaciones con datos del donador para consultas rápidas.

### 2. v_entregas_detalladas
Presenta un resumen completo de cada entrega con información del administrador y donación.

### 3. v_alumnos
Lista de alumnos completa para reportes administrativos.

### 4. v_comidas_proximas_caducar
Alerta sobre alimentos que caducarán en los próximos 30 días.

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

### 3. Mantenimiento
- **OPTIMIZE TABLE**: Mensual para desfragmentar tablas
- **ANALYZE TABLE**: Después de cargas masivas de datos
- **Limpieza de logs**: Rotación semanal

### 4. Monitoreo
- Slow query log habilitado
- Performance schema para análisis
- Monitoreo de uso de índices

## Estimación de Volumen de Datos

### Producción Estimada (1 año) - Una Escuela
- Donadores: ~50 registros
- Donaciones: ~200 registros/año
- Administradores: ~10 personas
- Alumnos: ~1,000 estudiantes
- Comidas: ~2,000 productos
- Entregas: ~200 registros/año

### Crecimiento Proyectado
- **Año 1**: 3,500 registros totales
- **Año 3**: 10,500 registros totales
- **Año 5**: 17,500 registros totales

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

### Recomendaciones
- Usar SSL/TLS para conexiones remotas
- Contraseñas fuertes para todos los usuarios
- Auditoría con general_log o binary log
- Encriptación de datos sensibles (correos, teléfonos)
- Backups diarios automáticos
- Firewall para limitar acceso al puerto 3306

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

## Scripts de Mantenimiento MySQL

```sql
-- Optimizar todas las tablas
OPTIMIZE TABLE donador, donacion, administrador, alumno, comida, entrega;

-- Analizar tablas para actualizar estadísticas
ANALYZE TABLE donador, donacion, administrador, alumno, comida, entrega;

-- Verificar integridad de tablas
CHECK TABLE donador, donacion, administrador, alumno, comida, entrega;

-- Reparar tabla si es necesario
REPAIR TABLE nombre_tabla;

-- Ver tamaño de tablas
SELECT 
    table_name,
    ROUND(((data_length + index_length) / 1024 / 1024), 2) AS size_mb
FROM information_schema.TABLES
WHERE table_schema = 'bocaditos_db'
ORDER BY (data_length + index_length) DESC;
```

## Configuración Recomendada my.cnf

```ini
[mysqld]
# Configuración básica
innodb_buffer_pool_size = 2G
innodb_log_file_size = 256M
max_connections = 100
query_cache_size = 64M
query_cache_type = 1

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
