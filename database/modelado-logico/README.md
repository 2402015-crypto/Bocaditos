# Modelado Lógico de Base de Datos — Bocaditos

Última revisión: 2025-11-25 (basado en `database/sql/ddl/01_create_schema.sql` v2.0.2)

Este documento resume el modelo lógico actual y las decisiones importantes tomadas en el DDL. Está pensado para desarrolladores, responsables de migraciones y operadores.

## Resumen ejecutivo

- Propósito: soportar donaciones, control de inventario por escuela, empaquetado de entregas y comunicación entre administradores y donadores.
- Cambios principales (v2.0.2): pluralización de objetos, creación de `estados_entregas`, adición de `ubicaciones.id_estado`, refactor de `stocks` a entradas/salidas, incorporación de `paquetes` y sistema de mensajería.

## Entidades clave (resumen)

- `tipos_productos`: catálogo de categorías.
- `productos`: catálogo de productos con `fecha_caducidad` y FK a `tipos_productos`.
- `estados_entregas`: catálogo para estados de donaciones/entregas (`pendiente`, `entregada`, `cancelada`).
- `estados`, `ciudades`, `ubicaciones`: jerarquía de localización; `ubicaciones` incluye `id_estado` (NOT NULL) y `id_ciudad` (nullable) para soportar distintos flujos UX.
- `escuelas`: beneficiarias con FK a `ubicaciones`.
- `usuarios`, `roles`, `administradores`: gestión de usuarios y permisos.
- `donadores`: soporta donantes institucionales y representante/contacto.
- `donaciones`, `detalle_donaciones`: cabecera y líneas de donación.
- `stocks`: inventario por `id_producto` y `id_escuela` con `cantidad_entrada` y `cantidad_salida`; `UNIQUE(id_producto,id_escuela)`.
- `vw_stock_disponible`: vista que calcula `cantidad_disponible = cantidad_entrada - cantidad_salida`.
- `paquetes`, `paquetes_stock`: definición de paquetes y relación pivot para cantidad por stock.
- `entregas`: registro de entregas a alumnos, con FK a `paquetes` y `estados_entregas`.
- Mensajería: `conversaciones`, `registro_conversaciones` (participantes polimórficos), `mensajes`.

## Reglas de negocio y comportamientos

1. Las donaciones y entregas usan `estados_entregas` para seguimiento.
2. `detalle_donacion.cantidad` > 0 (CHECK).
3. `producto.fecha_caducidad` es validada por triggers (no acepta fechas < CURDATE()).
4. Las actualizaciones de inventario se manejan en `stocks`; procedimientos usan `ON DUPLICATE KEY UPDATE` para upserts.
5. `vw_stock_disponible` es la fuente recomendada para consultas sobre disponibilidad.

## Objetos operativos

- Triggers:
  - `trg_validar_fecha_caducidad_insert` / `trg_validar_fecha_caducidad_update` (valida caducidad de productos).
  - `trg_update_fecha_ultimo_mensaje` (sincroniza `conversaciones.fecha_ultimo_mensaje`).
- Vista: `vw_stock_disponible`.
- Procedimientos: `registrar_donacion`, `registrar_entrega`, `crear_paquete`, `agregar_producto_a_paquete`, `entregar_paquete`.

## Integridad y performance

- FK definidas de manera amplia; índices en FKs. Índice único en `stocks` para soportar upserts y mejorar integridad de inventario.
- Uso de ENUM y CHECK para valores cerrados y validaciones simples.


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


## Normalización

El modelo lógico está en Tercera Forma Normal (3FN):
- 1FN: Atributos atómicos.
- 2FN: No hay dependencias parciales respecto a claves compuestas (PKs son simples donde corresponde).
- 3FN: No hay dependencias transitivas; entidades lookup se han separado (estado, tipo_producto, alergia, etc.).
