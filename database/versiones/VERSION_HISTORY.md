# Control de Versiones - Base de Datos Bocaditos

## Información General
Este documento mantiene el registro de todas las versiones de la base de datos del sistema Bocaditos, incluyendo cambios realizados, fecha de implementación y responsable.

---

## Versión 1.0.0
**Fecha de Lanzamiento**: 2025-11-04  
**Estado**: Actual  
**Tipo de Versión**: Inicial  

### Descripción
Primera versión del esquema de base de datos para el sistema de apoyo alimentario escolar UTRM "Bocaditos". Incluye todas las estructuras básicas necesarias para la operación del sistema.

### Componentes Incluidos

#### Tablas Principales
1. **tutor** - Gestión de tutores/padres de familia
2. **estudiante** - Información de estudiantes beneficiarios
3. **bocadito** - Catálogo de alimentos disponibles
4. **menu_diario** - Menús diarios del sistema
5. **menu_bocadito** - Relación entre menús y bocaditos
6. **responsable** - Personal de entrega
7. **pedido** - Registro de pedidos
8. **entrega** - Registro de entregas realizadas

#### Vistas
1. **v_pedidos_estudiante** - Resumen de pedidos por estudiante
2. **v_menu_del_dia** - Vista del menú actual con detalles
3. **v_entregas_responsable** - Estadísticas de entregas por responsable

#### Funciones y Triggers
1. **actualizar_cantidad_disponible()** - Gestión automática de inventario
2. **validar_entrega()** - Validación de entregas solo para pedidos confirmados
3. **trg_actualizar_disponibilidad** - Trigger para actualizar disponibilidad
4. **trg_validar_entrega** - Trigger de validación de entregas

#### Índices Implementados
- Índices en claves primarias (automáticos)
- Índices en claves foráneas para optimizar JOINs
- Índices en campos de búsqueda frecuente (fecha, estado, grado)
- Índices compuestos para consultas complejas

#### Restricciones
- Claves primarias en todas las tablas
- Claves foráneas con integridad referencial
- Constraints CHECK para validación de datos
- Valores únicos donde corresponde (email, fecha de menú)

### Archivos de la Versión
- `/database/sql/ddl/01_create_schema.sql` - Definición completa del esquema
- `/database/sql/dml/01_insert_data.sql` - Datos iniciales de prueba
- `/database/sql/dml/02_queries.sql` - Consultas comunes del sistema

### Scripts de Migración
No aplica (versión inicial).

### Datos de Prueba
- 8 tutores
- 12 estudiantes
- 15 bocaditos en diferentes categorías
- 5 responsables de entrega
- 5 menús diarios con bocaditos asociados
- 10 pedidos de ejemplo
- 1 entrega registrada

### Requisitos del Sistema
- PostgreSQL 14 o superior
- Extensión uuid-ossp
- Soporte para procedimientos almacenados (PL/pgSQL)
- Mínimo 4GB RAM para desarrollo
- Mínimo 16GB RAM para producción

### Notas de Instalación
1. Ejecutar `01_create_schema.sql` para crear la estructura
2. Ejecutar `01_insert_data.sql` para cargar datos de prueba
3. Las consultas en `02_queries.sql` son opcionales y sirven como referencia

### Compatibilidad
- PostgreSQL 14.x ✓
- PostgreSQL 15.x ✓
- PostgreSQL 16.x ✓

### Problemas Conocidos
Ninguno reportado en esta versión.

### Cambios Respecto a Versión Anterior
No aplica (versión inicial).

---

## Plantilla para Futuras Versiones

### Versión X.Y.Z
**Fecha de Lanzamiento**: YYYY-MM-DD  
**Estado**: En Desarrollo / Beta / Estable / Deprecada  
**Tipo de Versión**: Mayor / Menor / Parche  

#### Descripción
[Descripción breve de los cambios principales]

#### Nuevas Características
- [Característica 1]
- [Característica 2]

#### Mejoras
- [Mejora 1]
- [Mejora 2]

#### Correcciones
- [Corrección 1]
- [Corrección 2]

#### Cambios Incompatibles (Breaking Changes)
- [Cambio incompatible 1, si aplica]

#### Scripts de Migración
- [Ruta al script de migración desde versión anterior]

#### Archivos Modificados
- [Lista de archivos modificados]

#### Requisitos Actualizados
- [Nuevos requisitos o cambios en requisitos existentes]

#### Notas de Actualización
1. [Paso 1]
2. [Paso 2]

---

## Política de Versionado

### Esquema de Versiones
Utilizamos **Versionado Semántico** (Semantic Versioning):
- **MAJOR** (X.0.0): Cambios incompatibles con versiones anteriores
- **MINOR** (x.Y.0): Nueva funcionalidad compatible con versiones anteriores
- **PATCH** (x.y.Z): Correcciones de bugs compatibles

### Ejemplos
- `1.0.0` → `2.0.0`: Rediseño completo del esquema (breaking change)
- `1.0.0` → `1.1.0`: Agregar nuevas tablas o campos opcionales
- `1.0.0` → `1.0.1`: Corregir un constraint o índice

### Proceso de Actualización
1. **Backup**: Siempre realizar backup completo antes de actualizar
2. **Testing**: Probar scripts de migración en entorno de desarrollo
3. **Validación**: Verificar integridad de datos post-migración
4. **Documentación**: Actualizar este archivo con todos los cambios
5. **Rollback**: Tener plan de rollback en caso de problemas

### Frecuencia de Releases
- **Parches**: Según necesidad (correcciones críticas)
- **Versiones Menores**: Mensual o bimestral
- **Versiones Mayores**: Anual o según rediseño significativo

### Soporte de Versiones
- **Versión Actual**: Soporte completo
- **Versión N-1**: Soporte de seguridad por 6 meses
- **Versiones Anteriores**: No soportadas

---

## Historial de Cambios

### 2025-11-04
- **v1.0.0**: Lanzamiento inicial del sistema de base de datos
- Creación de 8 tablas principales
- Implementación de 3 vistas
- Configuración de triggers y funciones
- Documentación completa del modelo lógico y físico

---

## Contacto y Soporte

Para preguntas sobre versiones o migraciones:
- **Repositorio**: https://github.com/2402015-crypto/Bocaditos
- **Documentación**: /database/modelado-logico/README.md y /database/modelado-fisico/README.md
- **Issues**: Usar el sistema de issues de GitHub para reportar problemas

---

## Referencias
- [Documentación de PostgreSQL](https://www.postgresql.org/docs/)
- [Semantic Versioning](https://semver.org/)
- [Mejores Prácticas de Diseño de BD](https://www.postgresql.org/docs/current/ddl.html)
