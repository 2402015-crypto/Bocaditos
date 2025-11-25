# Modelado Lógico de Base de Datos - Sistema Bocaditos

## Descripción General
Este documento describe el modelo lógico actualizado de la base de datos para el sistema de donaciones alimentarias "Bocaditos" en UTRM. Está alineado con el script DDL principal `database/sql/ddl/01_create_schema.sql` (v2.0.1).

## Entidades Principales (resumen lógico)

- `tipos_productos`: Catálogo de tipos de producto (Frutas, Verduras, Enlatados, Pan, Lacteos, Cereales, Bebidas).
- `productos`: Productos donados; atributos principales: `id_producto`, `nombre`, `fecha_caducidad`, `id_tipo_producto`.
- `donadores`: Personas o instituciones donantes; `id_donador`, `nombre` (o razon_social), `rfc`, `telefono`, `correo`, `id_ubicacion`.
- `donaciones`: Cabecera de donación; `id_donacion`, `id_donador`, `id_escuela`, `fecha_donacion`, `id_estado_donacion`.
- `detalle_donaciones`: Líneas de donación que relacionan `donaciones` con `productos` y `cantidad`.
- `estados_donaciones`: Catálogo de estados de donación (`pendiente`, `entregada`, `cancelada`).
- `escuelas`: Instituciones beneficiarias; `id_escuela`, `nombre`, `id_ubicacion`.
- `ubicacion / ciudad / estado`: Jerarquía para la localización geográfica.
- `roles` y `usuarios`: Usuarios del sistema; `usuarios` contiene alumnos y administradores, `roles` define el tipo.
- `administradores`: Tabla que vincula un `usuario` con rol de administrador y fecha de asignación.
 - `stocks`: Inventario por `productos` y `escuelas` (entradas/salidas y fechas). La cantidad disponible se calcula mediante la vista `vw_stock_disponible` como `cantidad_entrada - cantidad_salida`.
- `paquetes` y `paquetes_stock`: Paquetes predefinidos y su relación con `stocks` (tabla pivote con cantidad por item).
- `entregas`: Registro de entregas de paquetes a alumnos (`id_entrega`, `fecha`, `id_paquete`, `id_alumno`).
- `alergias` y `usuarios_alergias`: Catálogo de alergias y relación muchos-a-muchos con usuarios.
- `comentarios_alumnos`: Comentarios/sugerencias enviados por alumnos.
- Mensajería: `conversaciones`, `conversacion_participantes`, `mensajes` — permite comunicación entre administradores (`usuarios`) y donadores.

## Relaciones (principales)

- Donador 1:N Donacion
- Donacion 1:N Detalle_donacion
- Donacion N:1 Escuela (cada donación tiene una escuela destino)
- Escuela 1:N Usuario (alumnos y administradores)
- Usuario (administrador) 1:1 Administrador (tabla administrativa con fecha de asignación)
- Producto 1:N Detalle_donacion
- Producto N:1 Stock (por escuela)
- Paquete N:M Stock (a través de `paquete_stock`)
- Conversacion 1:N Mensaje
- Conversacion 1:N Conversacion_participante (participantes pueden ser `usuario` o `donador`)

## Reglas de Negocio (actualizadas)

1. Cada donación debe estar asociada a un `donador` y a una `escuela` destino.
2. `detalle_donacion.cantidad` debe ser mayor que 0 (CHECK).
3. `producto.fecha_caducidad` no puede ser anterior a la fecha actual (validado por trigger).
4. `stock` se actualiza cuando se registran donaciones y entregas (procedimientos `registrar_donacion` y `registrar_entrega`).
5. Las conversaciones solo permiten participantes válidos: o un `usuario` o un `donador` (CHECK en `conversacion_participante`).
6. Los mensajes deben tener un emisor válido (usuario o donador) y actualizan la fecha del último mensaje en la conversación mediante trigger.

## Normalización

El modelo lógico está en Tercera Forma Normal (3FN):
- 1FN: Atributos atómicos.
- 2FN: No hay dependencias parciales respecto a claves compuestas (PKs son simples donde corresponde).
- 3FN: No hay dependencias transitivas; entidades lookup se han separado (estado, tipo_producto, alergia, etc.).

## Tipos de Datos y convenciones

- Identificadores: INT AUTO_INCREMENT
- Textos cortos: VARCHAR (longitudes según campo)
- Fechas: DATE / DATETIME
- Booleanos: BOOLEAN / TINYINT(1)
- Uso de ENUM para catálogos cerrados (`estado_donacion`, `rol`, `tipo_producto`)
- Nombres de columnas: snake_case en minúsculas

## Consideraciones de implementación

- Gestionar borrados con `ON DELETE` coherente según reglas (p.ej. `ON DELETE CASCADE` en `conversacion_participante` para borrar participantes al eliminar conversación).


## Diagramas y artefactos relacionados

- Ver `database/modelado-logico/` para diagramas ER y documentación detallada por entidad.
- Ver `database/sql/ddl/01_create_schema.sql` para la definición física y constraints.

