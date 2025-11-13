# Base de Datos - Sistema Bocaditos

## Descripción
Este directorio contiene el **repositorio completo de base de datos** para el sistema de donaciones alimentarias "Bocaditos" de UTRM. Este sistema gestiona donaciones de alimentos incluyendo donadores, entregas, administradores y alumnos beneficiarios. Incluye modelado lógico, modelado físico, archivos SQL y control de versiones documentado.

**Motor de Base de Datos**: MySQL/MariaDB
**Basado en**: Esquema original del cliente adaptado para una escuela

## Estructura del Directorio

```
database/
├── modelado-logico/          # Diseño conceptual y lógico de la BD
│   └── README.md             # Documentación del modelo lógico
├── modelado-fisico/          # Implementación física de la BD
│   └── README.md             # Documentación del modelo físico
├── sql/                      # Scripts SQL
│   ├── ddl/                  # Data Definition Language (Estructura)
│   │   └── 01_create_schema.sql
├── versiones/                # Control de versiones
│   └── VERSION_HISTORY.md    # Historial de versiones
└── README.md                 # Este archivo
```

## Componentes del Repositorio

### 1. Modelado Lógico
**Ubicación**: `/database/modelado-logico/`

Contiene la documentación del diseño conceptual de la base de datos:
- Diagrama Entidad-Relación (ER)
- Descripción de entidades y atributos
- Relaciones entre entidades
- Reglas de negocio
- Normalización (3FN)

**Ver**: [Documentación del Modelo Lógico](./modelado-logico/README.md)

### 2. Modelado Físico
**Ubicación**: `/database/modelado-fisico/`

Describe la implementación física en MySQL/MariaDB:
- Especificaciones técnicas de tablas
- Índices y restricciones
- Tipos de datos
- Estrategias de almacenamiento
- Consideraciones de performance
- Requerimientos de hardware

**Ver**: [Documentación del Modelo Físico](./modelado-fisico/README.md)

### 3. Archivos SQL

#### DDL (Data Definition Language)
**Ubicación**: `/database/sql/ddl/`

Scripts para crear la estructura de la base de datos:
- `01_create_schema.sql`: Creación completa del esquema MySQL
  - Tablas (7 tablas: donador, donacion, escuela, administrador, alumno, comida, entrega)
  - Índices
  - Constraints
  - Triggers
  - Vistas

### 4. Versiones Documentadas
**Ubicación**: `/database/versiones/`

Control de versiones de la base de datos:
- Historial completo de cambios
- Versión actual: **1.0.0**
- Scripts de migración
- Notas de actualización
- Política de versionado

**Ver**: [Historial de Versiones](./versiones/VERSION_HISTORY.md)

## Guía de Instalación

### Requisitos Previos
- MySQL 8.0+ o MariaDB 10.4+
- Cliente mysql o herramienta de administración (MySQL Workbench, phpMyAdmin, DBeaver, etc.)
- Usuario con privilegios de creación de base de datos

### Instalación Paso a Paso

#### 1. Clonar el repositorio (si no está clonado)
```bash
git clone https://github.com/2402015-crypto/Bocaditos.git
cd Bocaditos/database
```

#### 2. Crear la base de datos y esquema
```bash
# Conectar a MySQL
mysql -u root -p

# Ejecutar script de creación
source sql/ddl/01_create_schema.sql;
```

#### 3. Verificar instalación
```sql
-- Listar todas las tablas
USE bocaditos_db;
SHOW TABLES;

-- Verificar conteo de registros
SELECT COUNT(*) FROM donador;
SELECT COUNT(*) FROM donacion;
SELECT COUNT(*) FROM alumno;
```

### Instalación Rápida
```bash
# Ejecutar todos los scripts en orden
mysql -u root -p < sql/ddl/01_create_schema.sql
```

## Uso de los Scripts

### Crear la estructura completa
```bash
mysql -u root -p < sql/ddl/01_create_schema.sql
```

### Ejecutar consultas de ejemplo
```bash
mysql -u root -p bocaditos_db < sql/dml/02_queries.sql
```

## Entidades Principales

El sistema maneja las siguientes entidades:

1. **Donador**: Personas o instituciones que realizan donaciones
2. **Donación**: Registro de donaciones con cantidad y destino
3. **Escuela**: Información de la institución educativa (UTRM)
4. **Administrador**: Personal que gestiona entregas en la escuela
5. **Alumno**: Estudiantes beneficiarios del programa
6. **Comida**: Catálogo de alimentos donados
7. **Entrega**: Registro de entregas de donaciones

## Diagrama Simplificado

```
┌─────────┐       ┌──────────┐       ┌─────────┐
│ Donador │──1:N──│ Donación │──1:N──│ Escuela │
└─────────┘       └────┬─────┘       └────┬────┘
                       │                   │
                       │                   │
                      1:N                 1:N
                       │                   │
                  ┌────▼────┐         ┌────▼──────┐
                  │ Comida  │         │Administrador│
                  └─────────┘         └────┬───────┘
                                           │
                                          1:N
                                           │
                                      ┌────▼────┐
                                      │ Entrega │
                                      └─────────┘

┌─────────┐
│ Escuela │──1:N──┌────────┐
└─────────┘       │ Alumno │
                  └────────┘
```

## Funcionalidades Implementadas

### Triggers Automáticos
1. **Validación de Fechas (INSERT)**: Verifica que las fechas de caducidad sean válidas al insertar
2. **Validación de Fechas (UPDATE)**: Verifica que las fechas de caducidad sean válidas al actualizar

### Vistas Útiles
1. **v_donaciones_completas**: Donaciones con información del donador
2. **v_entregas_detalladas**: Detalles completos de entregas con escuela
3. **v_alumnos_por_escuela**: Lista de alumnos organizados por escuela
4. **v_comidas_proximas_caducar**: Alimentos próximos a vencer

### Consultas Predefinidas
- Donaciones con información completa
- Entregas pendientes
- Estadísticas de donaciones por donador
- Alumnos por escuela
- Inventario de comidas por tipo
- Alimentos próximos a caducar
- Rendimiento de administradores
- Donaciones por mes

## Mantenimiento

### Backup Recomendado
```bash
# Backup completo
pg_dump -U postgres bocaditos_db > backup_bocaditos_$(date +%Y%m%d).sql

# Backup solo estructura
pg_dump -U postgres --schema-only bocaditos_db > backup_schema.sql

# Backup solo datos
pg_dump -U postgres --data-only bocaditos_db > backup_data.sql
```

### Restauración
```bash
# Restaurar desde backup
psql -U postgres bocaditos_db < backup_bocaditos_20251104.sql
```

### Mantenimiento Rutinario
```sql
-- Análisis de tablas
ANALYZE;

-- Limpieza de espacio
VACUUM;

-- Reindexar
REINDEX DATABASE bocaditos_db;
```

## Seguridad

### Roles Implementados
- **bocaditos_admin**: Acceso completo
- **bocaditos_user**: Operaciones CRUD
- **bocaditos_readonly**: Solo lectura

### Mejores Prácticas
1. Usar roles con permisos mínimos necesarios
2. No usar el usuario postgres en aplicaciones
3. Activar SSL para conexiones remotas
4. Implementar auditoría de cambios
5. Realizar backups diarios automáticos

## Troubleshooting

### Error: Base de datos ya existe
```sql
DROP DATABASE IF EXISTS bocaditos_db;
-- Luego ejecutar 01_create_schema.sql
```

### Error: Extensión uuid-ossp no disponible
```bash
# Instalar contrib en PostgreSQL
sudo apt-get install postgresql-contrib
```

### Error: Permisos insuficientes
```sql
-- Otorgar permisos necesarios
GRANT ALL PRIVILEGES ON DATABASE bocaditos_db TO usuario;
```

## Contribución

Para contribuir al desarrollo de la base de datos:

1. Crear una rama para cambios
2. Documentar todos los cambios en VERSION_HISTORY.md
3. Actualizar modelado lógico/físico si aplica
4. Crear scripts de migración para cambios de esquema
5. Probar en entorno de desarrollo
6. Crear Pull Request con descripción detallada

## Versión Actual
**1.0.0** - Lanzamiento inicial (2025-11-04)

Ver [VERSION_HISTORY.md](./versiones/VERSION_HISTORY.md) para detalles completos.

## Recursos Adicionales

- [PostgreSQL Official Documentation](https://www.postgresql.org/docs/)
- [Database Design Best Practices](https://www.postgresql.org/docs/current/ddl.html)
- [SQL Style Guide](https://www.sqlstyle.guide/)

## Soporte

Para preguntas, sugerencias o reportar problemas:
- **Repositorio**: https://github.com/2402015-crypto/Bocaditos
- **Issues**: https://github.com/2402015-crypto/Bocaditos/issues

---

**Nota**: Este repositorio de base de datos es parte del proyecto académico del sistema de apoyo alimentario escolar en UTRM.
