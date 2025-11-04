# Modelado Físico de Base de Datos - Sistema Bocaditos

## Descripción General
Este documento describe el modelo físico de la base de datos para el sistema de apoyo alimentario escolar en UTRM, implementado para PostgreSQL.

## Especificaciones Técnicas

- **Motor de Base de Datos**: PostgreSQL 14+
- **Charset**: UTF-8
- **Collation**: es_ES.UTF-8
- **Zona Horaria**: America/Guayaquil

## Tablas

### 1. tutor
```sql
Nombre de tabla: tutor
Columnas:
- id_tutor: SERIAL PRIMARY KEY
- nombre: VARCHAR(100) NOT NULL
- apellido: VARCHAR(100) NOT NULL
- telefono: VARCHAR(20) NOT NULL
- email: VARCHAR(150) UNIQUE NOT NULL
- direccion: TEXT

Índices:
- PK_tutor: PRIMARY KEY (id_tutor)
- UK_email: UNIQUE (email)
- IDX_tutor_nombre: INDEX (nombre, apellido)
```

### 2. estudiante
```sql
Nombre de tabla: estudiante
Columnas:
- id_estudiante: SERIAL PRIMARY KEY
- nombre: VARCHAR(100) NOT NULL
- apellido: VARCHAR(100) NOT NULL
- fecha_nacimiento: DATE NOT NULL
- grado: VARCHAR(20) NOT NULL
- id_tutor: INTEGER NOT NULL

Índices:
- PK_estudiante: PRIMARY KEY (id_estudiante)
- FK_estudiante_tutor: FOREIGN KEY (id_tutor) REFERENCES tutor(id_tutor)
- IDX_estudiante_grado: INDEX (grado)
- IDX_estudiante_tutor: INDEX (id_tutor)

Constraints:
- CHECK (fecha_nacimiento < CURRENT_DATE)
```

### 3. bocadito
```sql
Nombre de tabla: bocadito
Columnas:
- id_bocadito: SERIAL PRIMARY KEY
- nombre: VARCHAR(100) NOT NULL
- descripcion: TEXT
- categoria: VARCHAR(50) NOT NULL
- calorias: INTEGER
- precio: DECIMAL(10,2) NOT NULL

Índices:
- PK_bocadito: PRIMARY KEY (id_bocadito)
- IDX_bocadito_categoria: INDEX (categoria)
- IDX_bocadito_nombre: INDEX (nombre)

Constraints:
- CHECK (calorias >= 0)
- CHECK (precio > 0)
```

### 4. menu_diario
```sql
Nombre de tabla: menu_diario
Columnas:
- id_menu: SERIAL PRIMARY KEY
- fecha: DATE NOT NULL UNIQUE
- descripcion: TEXT

Índices:
- PK_menu_diario: PRIMARY KEY (id_menu)
- UK_menu_fecha: UNIQUE (fecha)
- IDX_menu_fecha: INDEX (fecha)
```

### 5. menu_bocadito
```sql
Nombre de tabla: menu_bocadito
Columnas:
- id_menu: INTEGER NOT NULL
- id_bocadito: INTEGER NOT NULL
- cantidad_disponible: INTEGER NOT NULL DEFAULT 0

Índices:
- PK_menu_bocadito: PRIMARY KEY (id_menu, id_bocadito)
- FK_menu_bocadito_menu: FOREIGN KEY (id_menu) REFERENCES menu_diario(id_menu)
- FK_menu_bocadito_bocadito: FOREIGN KEY (id_bocadito) REFERENCES bocadito(id_bocadito)

Constraints:
- CHECK (cantidad_disponible >= 0)
```

### 6. responsable
```sql
Nombre de tabla: responsable
Columnas:
- id_responsable: SERIAL PRIMARY KEY
- nombre: VARCHAR(100) NOT NULL
- apellido: VARCHAR(100) NOT NULL
- cargo: VARCHAR(100) NOT NULL
- telefono: VARCHAR(20) NOT NULL

Índices:
- PK_responsable: PRIMARY KEY (id_responsable)
- IDX_responsable_cargo: INDEX (cargo)
```

### 7. pedido
```sql
Nombre de tabla: pedido
Columnas:
- id_pedido: SERIAL PRIMARY KEY
- id_estudiante: INTEGER NOT NULL
- id_menu: INTEGER NOT NULL
- fecha_pedido: TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
- estado: VARCHAR(20) NOT NULL DEFAULT 'pendiente'

Índices:
- PK_pedido: PRIMARY KEY (id_pedido)
- FK_pedido_estudiante: FOREIGN KEY (id_estudiante) REFERENCES estudiante(id_estudiante)
- FK_pedido_menu: FOREIGN KEY (id_menu) REFERENCES menu_diario(id_menu)
- IDX_pedido_estudiante: INDEX (id_estudiante)
- IDX_pedido_menu: INDEX (id_menu)
- IDX_pedido_fecha: INDEX (fecha_pedido)
- UK_pedido_estudiante_menu: UNIQUE (id_estudiante, id_menu)

Constraints:
- CHECK (estado IN ('pendiente', 'confirmado', 'entregado', 'cancelado'))
```

### 8. entrega
```sql
Nombre de tabla: entrega
Columnas:
- id_entrega: SERIAL PRIMARY KEY
- id_pedido: INTEGER NOT NULL UNIQUE
- fecha_entrega: TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
- id_responsable: INTEGER NOT NULL

Índices:
- PK_entrega: PRIMARY KEY (id_entrega)
- FK_entrega_pedido: FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido)
- FK_entrega_responsable: FOREIGN KEY (id_responsable) REFERENCES responsable(id_responsable)
- UK_entrega_pedido: UNIQUE (id_pedido)
- IDX_entrega_fecha: INDEX (fecha_entrega)
- IDX_entrega_responsable: INDEX (id_responsable)
```

## Estrategias de Almacenamiento

### Particionamiento
- La tabla `pedido` puede particionarse por fecha para optimizar consultas históricas
- La tabla `entrega` puede particionarse por mes

### Índices
- Se crean índices en todas las claves foráneas para optimizar JOINs
- Índices compuestos para consultas frecuentes (estudiante-menú)
- Índices en columnas de búsqueda frecuente (fecha, estado, grado)

### Restricciones de Integridad
- Todas las relaciones tienen claves foráneas con ON DELETE RESTRICT
- Constraints CHECK para validar datos (fechas, estados, cantidades)
- Valores por defecto para campos de auditoría (fecha_pedido, fecha_entrega)

## Consideraciones de Performance

1. **Cache de Consultas**: Configurar shared_buffers adecuadamente
2. **Connection Pooling**: Implementar pgBouncer para gestionar conexiones
3. **Mantenimiento**: VACUUM y ANALYZE programados semanalmente
4. **Backup**: Respaldos diarios incrementales y semanales completos

## Estimación de Volumen de Datos

- Estudiantes: ~1,000 registros
- Tutores: ~800 registros
- Bocaditos: ~50 registros
- Menús Diarios: ~250 registros/año
- Pedidos: ~250,000 registros/año
- Entregas: ~250,000 registros/año

## Requerimientos de Hardware

### Desarrollo
- CPU: 2 cores
- RAM: 4 GB
- Disco: 20 GB SSD

### Producción
- CPU: 4+ cores
- RAM: 16 GB
- Disco: 100 GB SSD con RAID 10
