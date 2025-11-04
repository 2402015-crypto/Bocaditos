# Modelado Lógico de Base de Datos - Sistema Bocaditos

## Descripción General
Este documento describe el modelo lógico de la base de datos para el sistema de apoyo alimentario escolar en UTRM.

## Entidades Principales

### 1. Estudiante
- **ID_Estudiante** (PK): Identificador único del estudiante
- Nombre: Nombre completo del estudiante
- Apellido: Apellido del estudiante
- Fecha_Nacimiento: Fecha de nacimiento
- Grado: Grado académico actual
- ID_Tutor: Relación con el tutor (FK)

### 2. Tutor
- **ID_Tutor** (PK): Identificador único del tutor
- Nombre: Nombre completo del tutor
- Apellido: Apellido del tutor
- Telefono: Número de contacto
- Email: Correo electrónico
- Direccion: Dirección de residencia

### 3. Bocadito
- **ID_Bocadito** (PK): Identificador único del bocadito
- Nombre: Nombre del bocadito
- Descripcion: Descripción detallada
- Categoria: Categoría del alimento
- Calorias: Contenido calórico
- Precio: Precio unitario

### 4. Menu_Diario
- **ID_Menu** (PK): Identificador único del menú
- Fecha: Fecha del menú
- Descripcion: Descripción del menú del día

### 5. Menu_Bocadito
- **ID_Menu** (FK): Referencia al menú
- **ID_Bocadito** (FK): Referencia al bocadito
- Cantidad_Disponible: Cantidad disponible para ese día

### 6. Pedido
- **ID_Pedido** (PK): Identificador único del pedido
- ID_Estudiante (FK): Referencia al estudiante
- ID_Menu (FK): Referencia al menú
- Fecha_Pedido: Fecha y hora del pedido
- Estado: Estado del pedido (pendiente, entregado, cancelado)

### 7. Entrega
- **ID_Entrega** (PK): Identificador único de la entrega
- ID_Pedido (FK): Referencia al pedido
- Fecha_Entrega: Fecha y hora de entrega
- ID_Responsable (FK): Responsable de la entrega

### 8. Responsable
- **ID_Responsable** (PK): Identificador único del responsable
- Nombre: Nombre del responsable
- Apellido: Apellido del responsable
- Cargo: Cargo o función
- Telefono: Número de contacto

## Relaciones

1. **Estudiante - Tutor**: Relación 1:N (Un tutor puede tener varios estudiantes)
2. **Menu_Diario - Bocadito**: Relación N:M a través de Menu_Bocadito
3. **Estudiante - Pedido**: Relación 1:N (Un estudiante puede hacer varios pedidos)
4. **Menu_Diario - Pedido**: Relación 1:N (Un menú puede tener varios pedidos)
5. **Pedido - Entrega**: Relación 1:1 (Un pedido tiene una entrega)
6. **Responsable - Entrega**: Relación 1:N (Un responsable puede hacer varias entregas)

## Reglas de Negocio

1. Cada estudiante debe tener un tutor asignado
2. Los pedidos deben realizarse para menús del día o días futuros
3. Un pedido no puede ser entregado sin estar en estado "confirmado"
4. La cantidad disponible de bocaditos debe actualizarse con cada pedido
5. Un estudiante solo puede hacer un pedido por día

## Diagrama Entidad-Relación

```
[Tutor] 1----N [Estudiante] 1----N [Pedido] N----1 [Menu_Diario]
                                      |                    |
                                      1                    N
                                      |                    |
                                  [Entrega]           [Menu_Bocadito]
                                      |                    |
                                      N                    N
                                      |                    |
                                [Responsable]          [Bocadito]
```

## Normalización

El modelo se encuentra en Tercera Forma Normal (3FN):
- Todos los atributos no clave dependen completamente de la clave primaria
- No existen dependencias transitivas
- Todas las relaciones many-to-many se resuelven mediante tablas de unión
