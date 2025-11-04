# Modelado Lógico de Base de Datos - Sistema Bocaditos

## Descripción General
Este documento describe el modelo lógico de la base de datos para el sistema de donaciones alimentarias "Bocaditos" en UTRM, basado en el esquema MySQL/MariaDB existente.

## Entidades Principales

### 1. Donador
- **id_donador** (PK): Identificador único del donador
- nombre: Nombre completo del donador o institución
- correo: Correo electrónico de contacto
- celular: Número de teléfono celular
- direccion: Dirección física del donador

### 2. Donacion
- **id_donacion** (PK): Identificador único de la donación
- cantidad: Cantidad de alimentos donados
- destino: Destino de la donación
- fecha_donacion: Fecha en que se realizó la donación
- id_donador (FK): Referencia al donador

### 3. Escuela
- **id_escuela** (PK): Identificador único de la escuela
- nombre: Nombre de la institución educativa
- ubicacion: Dirección física de la escuela
- id_donacion (FK): Referencia a la donación recibida

### 4. Administrador
- **id_admi** (PK): Identificador único del administrador
- nombre: Nombre completo del administrador
- numero: Número de teléfono
- correo: Correo electrónico
- id_escuela (FK): Referencia a la escuela donde trabaja

### 5. Alumno
- **id_alumno** (PK): Identificador único del alumno
- nombre: Nombre del alumno
- apellido: Apellido del alumno
- grupo: Grupo al que pertenece
- cuatrimestre: Cuatrimestre actual
- matricula: Matrícula única del alumno
- id_escuela: Referencia a la escuela (sin FK definida)

### 6. Comida
- **id_comida** (PK): Identificador único del alimento
- nombre: Nombre del producto alimenticio
- tipo_comida: Tipo o categoría del alimento
- fecha_caducidad: Fecha de caducidad del producto
- id_donacion: Referencia a la donación (sin FK definida)

### 7. Entrega
- **id_entrega** (PK): Identificador único de la entrega
- estado: Estado actual de la entrega
- fecha_entrega: Fecha programada o realizada de entrega
- id_admin (FK): Referencia al administrador responsable
- id_donacion (FK): Referencia a la donación entregada

## Relaciones

1. **Donador - Donacion**: Relación 1:N (Un donador puede realizar múltiples donaciones)
2. **Donacion - Escuela**: Relación 1:N (Una donación puede ir a múltiples escuelas)
3. **Escuela - Administrador**: Relación 1:N (Una escuela tiene varios administradores)
4. **Administrador - Entrega**: Relación 1:N (Un administrador gestiona varias entregas)
5. **Donacion - Entrega**: Relación 1:N (Una donación puede tener múltiples entregas)
6. **Donacion - Comida**: Relación 1:N (Una donación contiene múltiples alimentos)
7. **Escuela - Alumno**: Relación 1:N (Una escuela tiene múltiples alumnos)

## Reglas de Negocio

1. Cada donación debe estar asociada a un donador
2. Las escuelas reciben donaciones de alimentos
3. Los administradores gestionan las entregas en sus escuelas
4. Las entregas tienen estados: pendiente, en_proceso, completada, cancelada
5. Los alimentos tienen fecha de caducidad que debe ser monitoreada
6. Cada alumno tiene una matrícula única
7. Los alumnos están organizados por grupos y cuatrimestres

## Diagrama Entidad-Relación

```
[Donador] 1----N [Donacion] 1----N [Escuela]
                     |                  |
                     |                  |
                     |                  1
                     |                  |
                     |             [Administrador]
                     |                  |
                     |                  |
                     |                  1
                     |                  |
                     N                  N
                     |                  |
                [Entrega]----------[Entrega]
                
[Donacion] 1----N [Comida]

[Escuela] 1----N [Alumno]
```

## Normalización

El modelo se encuentra parcialmente normalizado:
- **Primera Forma Normal (1FN)**: ✓ Todos los atributos contienen valores atómicos
- **Segunda Forma Normal (2FN)**: ✓ Todos los atributos no clave dependen de la clave primaria completa
- **Tercera Forma Normal (3FN)**: ⚠️ Puede haber dependencias transitivas que requieren revisión

### Observaciones de Normalización

1. La relación entre `escuela` y `donacion` puede crear dependencias circulares
2. Considerar si `id_donacion` en `escuela` debe ser una relación separada
3. Las tablas `alumno` y `comida` no tienen claves foráneas explícitas definidas

## Mejoras Sugeridas

### 1. Integridad Referencial
- Agregar FK de `alumno.id_escuela` → `escuela.id_escuela`
- Agregar FK de `comida.id_donacion` → `donacion.id_donacion`

### 2. Relación Escuela-Donación
- Considerar crear una tabla intermedia `escuela_donacion` para manejar la relación N:M
- Esto permitiría que una escuela reciba múltiples donaciones y una donación beneficie a múltiples escuelas

### 3. Campos Adicionales Recomendados
- Timestamps de auditoría (created_at, updated_at)
- Campos de estado activo/inactivo
- Campos de notas o comentarios en entregas

### 4. Restricciones
- Valores únicos donde corresponda (correos, matrículas)
- Validaciones de fechas (fecha_caducidad >= fecha_donacion)
- Estados permitidos para entregas

## Tipos de Datos Sugeridos (PostgreSQL)

| Campo | Tipo MySQL | Tipo PostgreSQL Sugerido |
|-------|-----------|-------------------------|
| id_* | INT | INTEGER o SERIAL |
| nombre | VARCHAR(60) | VARCHAR(60) |
| correo | VARCHAR(150) | VARCHAR(150) |
| celular/numero | VARCHAR(10) | VARCHAR(10) |
| direccion/ubicacion | VARCHAR(255) | VARCHAR(255) |
| tipo_comida | VARCHAR(50) | VARCHAR(50) |
| estado | VARCHAR(20) | VARCHAR(20) con CHECK constraint |
| fecha_* | DATE | DATE |
| grupo | VARCHAR(10) | VARCHAR(10) |
| cuatrimestre | VARCHAR(10) | VARCHAR(10) |
| matricula | VARCHAR(7) | VARCHAR(7) UNIQUE |
| cantidad | INT | INTEGER |

## Consideraciones de Migración MySQL → PostgreSQL

1. **AUTO_INCREMENT** → **SERIAL** o **IDENTITY**
2. **ENGINE = InnoDB** → No aplicable en PostgreSQL
3. **CHARACTER SET** → Definir en nivel de base de datos
4. **COLLATE** → Usar collations de PostgreSQL
5. **FOREIGN_KEY_CHECKS** → No necesario en PostgreSQL
6. Índices se crean explícitamente después de las tablas
