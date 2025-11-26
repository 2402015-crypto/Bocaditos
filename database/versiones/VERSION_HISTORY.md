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

---

## Versión 2.1.0
**Fecha de Lanzamiento**: 2025-11-25  
**Estado**: Actual  
**Tipo de Versión**: Mayor (esquema actualizado)

### Descripción
Refactor y mejoras importantes del esquema de base de datos para soportar mejor el flujo de entregas/paquetes, control de stock y gestión de ubicaciones.

### Cambios principales
- Se pluralizaron nombres y estandarizaron comentarios en el DDL (`-- TABLA: ...`).
- Añadida tabla `estados_entregas` para modelar estados de entregas y donaciones (p.ej. pendiente, entregado, cancelado).
- `ubicaciones` ahora incorpora `id_estado` además de `id_ciudad` para permitir elegir estado/ciudad o crear una ubicación nueva (se mantiene compatibilidad con flujos existentes).
- `donadores` ampliada con campos para empresa y representante (soporte a donantes institucionales).
- Refactor de `stocks` para usar registros de entrada/salida (`cantidad_entrada`, `cantidad_salida`) y creación de la vista calculada `vw_stock_disponible` para consultar disponibilidad.
- Nuevas tablas/relaciones para manejo de paquetes: `paquetes` y `paquetes_stock` (pivot) para agrupar unidades y registrar entregas por paquete.
- Procedimientos almacenados añadidos/actualizados: `registrar_entrega`, `registrar_donacion`, `crear_paquete`, `agregar_producto_a_paquete`, `entregar_paquete`.
- Índices y constraints actualizados para mejorar integridad y rendimiento (ej. índices en `stocks`, unicity donde aplica).

### Archivos modificados
- `database/sql/ddl/01_create_schema.sql` — refactor y nuevas definiciones (vista, procedimientos, tablas, índices).

---

*(Registro generado automáticamente el 2025-11-25 por el asistente de desarrollo — detalles en los commits asociados.)*