# Modelado Lógico de Base de Datos - Sistema Bocaditos

## Descripción General
Este documento describe el modelo lógico actualizado de la base de datos para el sistema de donaciones alimentarias "Bocaditos" en UTRM. Está alineado con el script DDL principal `database/sql/ddl/01_create_schema.sql` (v2.0.1).

## Entidades Principales (resumen lógico)

- `tipo_producto`: Catálogo de tipos de producto (Frutas, Verduras, Enlatados, Pan, Lacteos, Cereales, Bebidas).
- `producto`: Productos donados; atributos principales: `id_producto`, `nombre`, `fecha_caducidad`, `id_tipo_producto`.
- `donador`: Personas o instituciones donantes; `id_donador`, `nombre` (o razon_social), `rfc`, `telefono`, `correo`, `id_ubicacion`.
- `donacion`: Cabecera de donación; `id_donacion`, `id_donador`, `id_escuela`, `fecha_donacion`, `id_estado_donacion`.
- `detalle_donacion`: Líneas de donación que relacionan `donacion` con `producto` y `cantidad`.
- `estado_donacion`: Catálogo de estados de donación (`pendiente`, `entregada`, `cancelada`).
- `escuela`: Instituciones beneficiarias; `id_escuela`, `nombre`, `id_ubicacion`.
- `ubicacion / ciudad / estado`: Jerarquía para la localización geográfica.
- `rol` y `usuario`: Usuarios del sistema; `usuario` contiene alumnos y administradores, `rol` define el tipo.
- `administrador`: Tabla que vincula un `usuario` con rol de administrador y fecha de asignación.
- `stock`: Inventario por `producto` y `escuela` (cantidad_disponible, entradas/salidas, fechas).
- `paquete` y `paquete_stock`: Paquetes predefinidos y su relación con `stock` (tabla pivote con cantidad por item).
- `entrega`: Registro de entregas de paquetes a alumnos (`id_entrega`, `fecha`, `id_paquete`, `id_alumno`).
- `alergia` y `usuario_alergia`: Catálogo de alergias y relación muchos-a-muchos con usuarios.
- `comentario_alumno`: Comentarios/sugerencias enviados por alumnos.
- Mensajería: `conversacion`, `conversacion_participante`, `mensaje` — permite comunicación entre administradores (`usuario`) y donadores.

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

