# Control de Versiones - Base de Datos Bocaditos

## Información General
Este documento mantiene el registro de todas las versiones de la base de datos del sistema Bocaditos, incluyendo cambios realizados, fecha de implementación y responsable.

---

## Versión 1.0.0
**Fecha de Lanzamiento**: 2025-11-04  
**Estado**: Actualizada  
**Tipo de Versión**: Inicial  

### Descripción
Primera versión del esquema de base de datos para el sistema de donaciones alimentarias UTRM "Bocaditos". Implementado en **MySQL/MariaDB**.

### Componentes Incluidos

#### Tablas Principales (7 tablas)
1. **donadores** - Información de donadores (personas o instituciones)
2. **donaciones** - Registro de donaciones con cantidad y destino
3. **administradores** - Personal que gestiona entregas en la escuela
4. **alumnos** - Estudiantes beneficiarios del programa
5. **productos** - Catálogo de alimentos donados con fechas de caducidad
6. **entregas** - Registro de entregas de donaciones
7. **escuelas** - Datos de la escuela.

---

## Versión 2.0.0
**Fecha de Lanzamiento**: 2025-11-20  
**Estado**: Actual  
**Tipo de Versión**: Mayor (nuevas funcionalidades y correcciones)  

### Descripción
Actualización importante del esquema con nuevas funcionalidades (sistema de mensajería) y correcciones de esquema.

### Cambios principales
- Añadido sistema de mensajería entre administradores y donadores:
	- Tablas: `conversaciones`, `conversacion_participantes`, `mensajes`.
	- Trigger `trg_update_fecha_ultimo_mensaje` para mantener `conversaciones.fecha_ultimo_mensaje` actualizado.
- Correcciones en el DDL principal (`01_create_schema.sql`):
	- `paquete.nombre` cambiado a `VARCHAR(100)` (antes `DATE`).
	- Columnas con caracteres especiales renombradas de `contraseña` a `contrasena` para evitar problemas de encoding/compatibilidad.
	- Se agregó índice UNIQUE sobre `(id_producto, id_escuela)` en `stock` para permitir operaciones `INSERT ... ON DUPLICATE KEY UPDATE`.
	- Se corrigieron procedimientos almacenados (por ejemplo `registrar_donacion`) y triggers de validación (`trg_validar_fecha_caducidad`).

### Archivos añadidos/actualizados
- `database/sql/ddl/01_create_schema.sql` — actualizado (v2.0.0): correcciones, procedimientos, triggers y mensajería.