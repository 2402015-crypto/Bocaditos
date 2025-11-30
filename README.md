# Bocaditos
Este repositorio contiene el modelado lógico y físico, archivos SQL y versiones documentadas del proyecto Bocaditos

**Descripción del Proyecto**

**Bocaditos** es un sistema de gestión para el programa de donaciones alimentarias de la Universidad Tecnológica de la Riviera Maya (UTRM) que permite:
- Registrar donadores y sus donaciones
- Almacenar información de la escuela (UTRM)
- Gestionar entregas a la escuela
- Administrar información de administradores
- Controlar inventario de alimentos con fechas de caducidad
 - Registrar beneficiarios
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
  - Scripts principales:
    - `database/sql/ddl/01_create_schema.sql` — esquema principal (tablas, índices, triggers y procedimientos)
  - Componentes incluidos:
    - Tablas principales (donadores, donaciones, escuelas, administradores, usuarios, productos, stocks, paquetes, entregas, etc.)
    - Sistema de mensajería: `conversaciones`, `conversacion_participantes`, `mensajes` (agregado en v2.0.0)
    - Triggers y procedimientos (por ejemplo `trg_validar_fecha_caducidad`, `trg_update_fecha_ultimo_mensaje`, `registrar_entrega`, `registrar_donacion`)
    - Índices, constraints y validaciones (CHECK, UNIQUE)

**Ver**: [Archivos SQL](./database/sql/)

### Versiones Documentadas
- Versión actual: **2.0.0**
- Historial completo de cambios
- Política de versionado semántico

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

El sistema gestiona las siguientes entidades principales (esquema actualizado):

 - **tipos_productos**: Tipos de productos (Frutas, Verduras, Enlatados, Pan, Lacteos, Cereales, Bebidas).
 - **productos**: Productos donados con fecha de caducidad y referencia a `tipos_productos`.
 - **donadores**: Personas o instituciones que realizan donaciones (RFC, contacto, ubicación).
 - **donaciones**: Cabecera de donación (donador, escuela destino, fecha y estado).
 - **detalle_donaciones**: Líneas de donación que relacionan donación con `productos` y cantidad.
 - **estados_donaciones**: Catálogo de estados de donación (pendiente, entregada, cancelada).
 - **escuelas**: Instituciones beneficiarias (referencia a `ubicaciones`).
- **ubicacion / ciudad / estado**: Jerarquía de localización geográfica.
 - **usuarios**: Usuarios del sistema (beneficiarios y administradores) con rol, escuela y contacto.
 - **roles**: Tipos de usuario (`beneficiario`, `administrador`).
 - **administradores**: Tabla que vincula un `usuario` con rol de administrador y fecha de asignación.
 - **stocks**: Control de existencias por `productos` y `escuelas` (entradas, salidas, disponible, fechas).
 - **paquetes**: Paquetes predefinidos compuestos por `stocks` (tabla pivote `paquetes_stock`).
 - **paquetes_stock**: Asociación muchos-a-muchos entre `paquete` y `stocks` indicando cantidades por paquete.
 - **entregas**: Registro de entregas de paquetes a beneficiarios.
 - **alergias / usuarios_alergias**: Catálogo de alergias y relación con usuarios.
 - **comentarios_beneficiarios**: Comentarios/sugerencias enviados por beneficiarios.
 - **conversaciones / conversacion_participantes / mensajes**: Sistema de mensajería entre administradores (usuarios) y donadores (conversaciones, participantes y mensajes).

Adicionalmente hay triggers y procedimientos para validaciones y operaciones frecuentes, por ejemplo:
- Triggers: `trg_validar_fecha_caducidad_*` (evitan insertar productos con caducidad pasada), `trg_update_fecha_ultimo_mensaje` (actualiza fecha del último mensaje en una conversación).
- Procedimientos: `registrar_entrega`, `registrar_donacion` (automatizan insert de cabeceras, detalles y actualización de stock).

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

**Versión de Base de Datos**: 2.0.3  
**Última Actualización**: 2025-11-27 
