# Modelado Físico de Base de Datos - Sistema Bocaditos

## Descripción General
Este documento describe el modelo físico de la base de datos para el sistema de donaciones alimentarias "Bocaditos" en UTRM, adaptado desde MySQL/MariaDB a PostgreSQL 14+.

## Especificaciones Técnicas

- **Motor de Base de Datos**: PostgreSQL 14+
- **Charset**: UTF-8
- **Collation**: es_ES.UTF-8
- **Zona Horaria**: America/Mexico_City

## Tablas

### 1. donador
```sql
Nombre de tabla: donador
Columnas:
- id_donador: INTEGER PRIMARY KEY
- nombre: VARCHAR(60) NOT NULL
- correo: VARCHAR(150) NOT NULL
- celular: VARCHAR(10) NOT NULL
- direccion: VARCHAR(255) NOT NULL

Índices:
- PK_donador: PRIMARY KEY (id_donador)
- IDX_donador_nombre: INDEX (nombre)
- IDX_donador_correo: INDEX (correo)

Descripción: Almacena información de personas o instituciones que realizan donaciones.
```

### 2. donacion
```sql
Nombre de tabla: donacion
Columnas:
- id_donacion: INTEGER PRIMARY KEY
- cantidad: INTEGER NOT NULL
- destino: VARCHAR(255) NOT NULL
- fecha_donacion: DATE NOT NULL
- id_donador: INTEGER NOT NULL

Índices:
- PK_donacion: PRIMARY KEY (id_donacion)
- FK_donacion_donador: FOREIGN KEY (id_donador) REFERENCES donador(id_donador)
- IDX_donacion_donador: INDEX (id_donador)
- IDX_donacion_fecha: INDEX (fecha_donacion)

Constraints:
- CHECK (cantidad > 0)

Descripción: Registra las donaciones realizadas con cantidad y destino.
```

### 3. escuela
```sql
Nombre de tabla: escuela
Columnas:
- id_escuela: INTEGER PRIMARY KEY
- nombre: VARCHAR(60) NOT NULL
- ubicacion: VARCHAR(255) NOT NULL
- id_donacion: INTEGER NOT NULL

Índices:
- PK_escuela: PRIMARY KEY (id_escuela)
- FK_escuela_donacion: FOREIGN KEY (id_donacion) REFERENCES donacion(id_donacion)
- IDX_escuela_nombre: INDEX (nombre)
- IDX_escuela_donacion: INDEX (id_donacion)

Descripción: Instituciones educativas beneficiarias del programa.
```

### 4. administrador
```sql
Nombre de tabla: administrador
Columnas:
- id_admi: INTEGER PRIMARY KEY
- nombre: VARCHAR(60) NOT NULL
- numero: VARCHAR(10) NOT NULL
- correo: VARCHAR(100) NOT NULL
- id_escuela: INTEGER NOT NULL

Índices:
- PK_administrador: PRIMARY KEY (id_admi)
- FK_administrador_escuela: FOREIGN KEY (id_escuela) REFERENCES escuela(id_escuela)
- IDX_administrador_nombre: INDEX (nombre)
- IDX_administrador_escuela: INDEX (id_escuela)
- IDX_administrador_correo: INDEX (correo)

Descripción: Personal administrativo que gestiona las donaciones en cada escuela.
```

### 5. alumno
```sql
Nombre de tabla: alumno
Columnas:
- id_alumno: INTEGER PRIMARY KEY
- nombre: VARCHAR(60) NOT NULL
- apellido: VARCHAR(60) NOT NULL
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

Descripción: Estudiantes beneficiarios del programa de donaciones.
Nota: En la implementación PostgreSQL se recomienda agregar FK a escuela.
```

### 6. comida
```sql
Nombre de tabla: comida
Columnas:
- id_comida: INTEGER PRIMARY KEY
- nombre: VARCHAR(255) NOT NULL
- tipo_comida: VARCHAR(50) NOT NULL
- fecha_caducidad: DATE NOT NULL
- id_donacion: INTEGER NOT NULL

Índices:
- PK_comida: PRIMARY KEY (id_comida)
- IDX_comida_nombre: INDEX (nombre)
- IDX_comida_tipo: INDEX (tipo_comida)
- IDX_comida_fecha_caducidad: INDEX (fecha_caducidad)
- IDX_comida_donacion: INDEX (id_donacion)

Descripción: Catálogo de alimentos incluidos en las donaciones.
Nota: En la implementación PostgreSQL se recomienda agregar FK a donacion.
```

### 7. entrega
```sql
Nombre de tabla: entrega
Columnas:
- id_entrega: INTEGER PRIMARY KEY
- estado: VARCHAR(20) NOT NULL
- fecha_entrega: DATE NOT NULL
- id_admin: INTEGER NOT NULL
- id_donacion: INTEGER NOT NULL

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

Descripción: Registro de entregas de donaciones a las escuelas.
```

## Vistas Implementadas

### 1. v_donaciones_completas
Combina información de donaciones con datos del donador para consultas rápidas.

### 2. v_entregas_detalladas
Presenta un resumen completo de cada entrega con información del administrador, escuela y donación.

### 3. v_alumnos_por_escuela
Lista de alumnos organizados por escuela para reportes administrativos.

### 4. v_comidas_proximas_caducar
Alerta sobre alimentos que caducarán en los próximos 30 días.

## Funciones y Triggers

### 1. validar_fecha_caducidad()
**Tipo**: Función PL/pgSQL
**Propósito**: Validar que la fecha de caducidad no sea anterior a la fecha actual
**Uso**: Trigger BEFORE INSERT/UPDATE en tabla comida

### 2. actualizar_estado_entrega()
**Tipo**: Función PL/pgSQL
**Propósito**: Registrar cambios de estado en entregas
**Uso**: Trigger AFTER UPDATE en tabla entrega

## Estrategias de Almacenamiento

### Índices
- **Claves Primarias**: Índice automático en todas las PKs
- **Claves Foráneas**: Índices en todas las FKs para optimizar JOINs
- **Campos de Búsqueda**: Índices en campos frecuentemente consultados (nombres, correos, fechas)
- **Campos Únicos**: Índice UNIQUE en matrícula de alumnos

### Restricciones de Integridad
- **ON DELETE RESTRICT**: Evita eliminación de registros con dependencias
- **ON UPDATE RESTRICT**: Evita actualización de PKs referenciadas
- **CHECK Constraints**: Validación de cantidades positivas y estados válidos
- **UNIQUE Constraints**: Matrícula única por alumno

## Diferencias MySQL → PostgreSQL

| Característica | MySQL/MariaDB | PostgreSQL |
|----------------|---------------|------------|
| Auto-incremento | AUTO_INCREMENT | SERIAL o IDENTITY |
| Motor | ENGINE = InnoDB | No aplicable |
| Charset por tabla | CHARACTER SET | Definido en DB |
| Collation por tabla | COLLATE | Definido en DB |
| Verificación FK | SET FOREIGN_KEY_CHECKS | No necesario |
| Índices | Definidos en CREATE TABLE | CREATE INDEX separado |
| Secuencias | Implícitas | Explícitas con SERIAL |

## Consideraciones de Performance

### 1. Índices Optimizados
- Índices compuestos en (nombre, apellido) para búsquedas frecuentes
- Índices en fechas para consultas de rango
- Índices en claves foráneas para mejorar JOINs

### 2. Particionamiento (Futuro)
- Tabla `entrega` por mes para datos históricos
- Tabla `donacion` por año

### 3. Mantenimiento
- **VACUUM**: Semanal en tablas con alta actividad
- **ANALYZE**: Después de cargas masivas de datos
- **REINDEX**: Trimestral en tablas críticas

### 4. Monitoreo
- Consultas lentas (pg_stat_statements)
- Uso de índices (pg_stat_user_indexes)
- Tamaño de tablas (pg_relation_size)

## Estimación de Volumen de Datos

### Producción Estimada (1 año)
- Donadores: ~100 registros
- Donaciones: ~500 registros/año
- Escuelas: ~10 instituciones
- Administradores: ~30 personas
- Alumnos: ~2,000 estudiantes
- Comidas: ~5,000 productos
- Entregas: ~500 registros/año

### Crecimiento Proyectado
- **Año 1**: 50,000 registros totales
- **Año 3**: 150,000 registros totales
- **Año 5**: 300,000 registros totales

## Requerimientos de Hardware

### Desarrollo
- CPU: 2 cores
- RAM: 4 GB
- Disco: 20 GB SSD
- Conexiones simultáneas: 20

### Producción
- CPU: 4+ cores
- RAM: 16 GB
- Disco: 100 GB SSD con RAID 10
- Conexiones simultáneas: 100
- Backup storage: 200 GB

## Seguridad

### Roles Implementados
1. **bocaditos_admin**: Acceso completo (DDL y DML)
2. **bocaditos_user**: Operaciones CRUD estándar
3. **bocaditos_readonly**: Solo consultas SELECT

### Recomendaciones
- Usar SSL/TLS para conexiones remotas
- Implementar autenticación por certificado
- Auditoría de cambios en tablas críticas
- Encriptación de datos sensibles (correos, teléfonos)
- Backups diarios automáticos

## Backup y Recuperación

### Estrategia de Backup
- **Completo**: Semanal (Domingos 02:00 AM)
- **Incremental**: Diario (02:00 AM)
- **Retención**: 30 días en línea, 1 año en archivo

### Comandos de Backup
```bash
# Backup completo
pg_dump -U postgres bocaditos_db > backup_$(date +%Y%m%d).sql

# Backup solo estructura
pg_dump -U postgres --schema-only bocaditos_db > schema.sql

# Backup solo datos
pg_dump -U postgres --data-only bocaditos_db > data.sql
```

## Scripts de Mantenimiento

```sql
-- Vacuum y análisis
VACUUM ANALYZE;

-- Reindexar base de datos
REINDEX DATABASE bocaditos_db;

-- Verificar integridad
SELECT tablename, attname, null_frac, avg_width, n_distinct
FROM pg_stats
WHERE schemaname = 'public'
ORDER BY null_frac DESC;
```
