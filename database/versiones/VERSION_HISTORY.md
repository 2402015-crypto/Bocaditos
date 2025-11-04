# Control de Versiones - Base de Datos Bocaditos

## Información General
Este documento mantiene el registro de todas las versiones de la base de datos del sistema Bocaditos, incluyendo cambios realizados, fecha de implementación y responsable.

---

## Versión 1.0.0
**Fecha de Lanzamiento**: 2025-11-04  
**Estado**: Actual  
**Tipo de Versión**: Inicial  

### Descripción
Primera versión del esquema de base de datos para el sistema de donaciones alimentarias UTRM "Bocaditos". Implementado en **MySQL/MariaDB** según esquema original del cliente. Sistema diseñado para operar en **una sola escuela (UTRM)**.

### Componentes Incluidos

#### Tablas Principales (6 tablas)
1. **donador** - Información de donadores (personas o instituciones)
2. **donacion** - Registro de donaciones con cantidad y destino
3. **administrador** - Personal que gestiona entregas en la escuela
4. **alumno** - Estudiantes beneficiarios del programa
5. **comida** - Catálogo de alimentos donados con fechas de caducidad
6. **entrega** - Registro de entregas de donaciones

**Nota**: Simplificado para una sola escuela - eliminada tabla `escuela` y relaciones asociadas.

#### Vistas
1. **v_donaciones_completas** - Donaciones con información completa del donador
2. **v_entregas_detalladas** - Detalles completos de entregas con administrador y donación
3. **v_alumnos** - Lista completa de alumnos
4. **v_comidas_proximas_caducar** - Alimentos que caducarán en los próximos 30 días

#### Triggers
1. **trg_validar_fecha_caducidad_insert** - Validación de fechas al insertar alimentos
2. **trg_validar_fecha_caducidad_update** - Validación de fechas al actualizar alimentos

#### Índices Implementados
- AUTO_INCREMENT en claves primarias
- Índices en claves foráneas para optimizar JOINs
- Índices en campos de búsqueda frecuente (nombres, correos, fechas, estados)
- Índice UNIQUE en matrícula de alumnos

#### Restricciones
- Claves primarias en todas las tablas con AUTO_INCREMENT
- Claves foráneas con integridad referencial (ON DELETE RESTRICT, ON UPDATE RESTRICT)
- Constraints CHECK para validación de datos (cantidades positivas, estados válidos)
- Valores únicos donde corresponde (matrícula de alumnos)

### Motor de Base de Datos
- **MySQL 8.0+ / MariaDB 10.4+**
- **Storage Engine**: InnoDB
- **Charset**: utf8mb4
- **Collation**: utf8mb4_general_ci

### Archivos de la Versión
- `/database/sql/ddl/01_create_schema.sql` - Definición completa del esquema
- `/database/sql/dml/01_insert_data.sql` - Datos iniciales de prueba
- `/database/sql/dml/02_queries.sql` - Consultas comunes del sistema

### Scripts de Migración
No aplica (versión inicial).

### Datos de Prueba
- 5 donadores (fundaciones, comercios, asociaciones)
- 5 donaciones a UTRM
- 5 administradores de la escuela
- 12 alumnos de UTRM
- 15 alimentos con fechas de caducidad
- 5 entregas (completadas, en_proceso, pendientes)

### Esquema Base
- **Motor**: MySQL/MariaDB (según esquema original del cliente)
- **Simplificación**: Para una sola escuela (UTRM)
- **Características**:
  - Validación automática de fechas de caducidad con triggers
  - Vistas optimizadas para reportes de donaciones y entregas
  - Integridad referencial completa con InnoDB

### Requisitos del Sistema
- MySQL 8.0+ o MariaDB 10.4+
- Storage Engine: InnoDB
- Charset: utf8mb4
- Mínimo 2GB RAM para desarrollo
- Mínimo 8GB RAM para producción

### Notas de Instalación
1. Ejecutar `01_create_schema.sql` para crear la estructura
2. Ejecutar `01_insert_data.sql` para cargar datos de prueba
3. Las consultas en `02_queries.sql` son opcionales y sirven como referencia

### Compatibilidad
- MySQL 8.0.x ✓
- MySQL 8.1.x ✓
- MariaDB 10.4.x ✓
- MariaDB 10.5.x+ ✓

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
