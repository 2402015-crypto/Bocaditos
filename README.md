# Bocaditos
Este repositorio contiene el modelado lógico y físico, archivos SQL y versiones documentadas del proyecto Bocaditos

**Descripción del Proyecto**

**Bocaditos** es un sistema de gestión para el programa de donaciones alimentarias de la Universidad Tecnológica de la Riviera Maya (UTRM) que permite:
- Registrar donadores y sus donaciones
- Almacenar información de la escuela (UTRM)
- Gestionar entregas a la escuela
- Administrar información de administradores
- Controlar inventario de alimentos con fechas de caducidad
- Registrar alumnos beneficiarios
- Generar reportes y estadísticas del programa de donaciones

**Motor de Base de Datos**: MySQL/MariaDB

## Estructura del Repositorio

```
Bocaditos/
├── database/                    # Repositorio de Base de Datos
│   ├── modelado-logico/         # Modelado lógico de la BD
│   ├── modelado-fisico/         # Modelado físico de la BD
│   ├── sql/                     # Archivos SQL
│   │   └── ddl/                 # Scripts de definición (CREATE TABLE, etc.)
│   ├── versiones/               # Control de versiones documentado
│   └── README.md                # Documentación de la base de datos
└── README.md                    # Este archivo
```

## Repositorio de Base de Datos

El directorio `/database` contiene el repositorio completo de base de datos con:

### Modelado Lógico
- Diagrama Entidad-Relación
- Descripción de entidades y relaciones
- Reglas de negocio
- Normalización (3FN)

**Ver**: [Modelado Lógico](./database/modelado-logico/README.md)

### Modelado Físico
- Especificaciones técnicas de MySQL/MariaDB
- Definición de tablas, índices y constraints
- Estrategias de optimización
- Requerimientos de hardware

**Ver**: [Modelado Físico](./database/modelado-fisico/README.md)

### Archivos SQL
- **DDL**: Scripts de creación del esquema MySQL
  - Tablas (7 entidades: donador, donacion, escuela, administrador, alumno, comida, entrega)
  - Vistas (4 vistas)
  - Triggers (2 triggers)
  - Índices y constraints


**Ver**: [Archivos SQL](./database/sql/)

### Versiones Documentadas
- Versión actual: **1.0.0**
- Historial completo de cambios
- Política de versionado semántico
- Scripts de migración

**Ver**: [Control de Versiones](./database/versiones/VERSION_HISTORY.md)

## Inicio Rápido

### Requisitos
- MySQL 8.0+ o MariaDB 10.4+
- Cliente mysql o herramienta de administración de BD

### Instalación

1. **Clonar el repositorio**
```bash
git clone https://github.com/2402015-crypto/Bocaditos.git
cd Bocaditos/database
```

2. **Crear la base de datos**
```bash
mysql -u root -p < sql/ddl/01_create_schema.sql
```

3. **Verificar instalación**
```bash
mysql -u root -p bocaditos_db -e "SHOW TABLES;"
```

## Modelo de Datos

El sistema gestiona las siguientes entidades principales:

- **Donador**: Personas o instituciones donantes
- **Donación**: Registro de donaciones
- **Escuela**: Información de la institución educativa (UTRM)
- **Administrador**: Personal que gestiona entregas
- **Alumno**: Estudiantes beneficiarios
- **Comida**: Catálogo de alimentos donados
- **Entrega**: Registro de entregas

## Documentación Completa

Para información detallada sobre la base de datos, consulta:
- [**Documentación de Base de Datos**](./database/README.md) - Guía completa
- [**Modelo Lógico**](./database/modelado-logico/README.md) - Diseño conceptual
- [**Modelo Físico**](./database/modelado-fisico/README.md) - Implementación técnica
- [**Historial de Versiones**](./database/versiones/VERSION_HISTORY.md) - Control de cambios

## Tecnologías

- **Motor de Base de Datos**: MySQL 8.0+ / MariaDB 10.4+
- **Lenguaje**: SQL
- **Charset**: utf8mb4
- **Storage Engine**: InnoDB
- **Normalización**: 3FN (Tercera Forma Normal)




## Licencia

Este es un proyecto académico para UTRM.

## Autores
- Fabian Nava Maria Fernanda
- Elvia Alicia Garcia Garcia
- Martinez Jimenez Bryan
- Yam Cambara Oliver Josue
  
## Contacto

Para preguntas o sugerencias:
- **Repositorio**: https://github.com/2402015-crypto/Bocaditos

---

**Versión de Base de Datos**: 1.0.0  
**Última Actualización**: 2025-11-04
