# Modelado Lógico de Base de Datos - Sistema Bocaditos

## Descripción General
Este documento describe el modelo lógico de la base de datos para el sistema de donaciones alimentarias "Bocaditos" en UTRM, basado en el esquema MySQL/MariaDB.

## Entidades Principales

### 1. Donador
- **id_donador** (PK): Identificador único del donador (AUTO_INCREMENT)
- nombre: Nombre completo del donador o institución
- correo: Correo electrónico de contacto
- celular: Número de teléfono celular
- direccion: Dirección física del donador

### 2. Donacion
- **id_donacion** (PK): Identificador único de la donación (AUTO_INCREMENT)
- cantidad: Cantidad de alimentos donados
- destino: Destino de la donación (nombre de la escuela)
- fecha_donacion: Fecha en que se realizó la donación
- id_donador (FK): Referencia al donador

### 3. Escuela
- **id_escuela** (PK): Identificador único de la escuela (AUTO_INCREMENT)
- nombre: Nombre de la institución educativa (UTRM)
- ubicacion: Dirección física de la escuela
- id_donacion (FK): Referencia a la donación recibida

### 4. Administrador
- **id_admi** (PK): Identificador único del administrador (AUTO_INCREMENT)
- nombre: Nombre completo del administrador
- numero: Número de teléfono
- correo: Correo electrónico
- id_escuela (FK): Referencia a la escuela donde trabaja

### 5. Alumno
- **id_alumno** (PK): Identificador único del alumno (AUTO_INCREMENT)
- nombre: Nombre del alumno
- apellido: Apellido del alumno
- grupo: Grupo al que pertenece
- cuatrimestre: Cuatrimestre actual
- matricula: Matrícula única del alumno
- id_escuela (FK): Referencia a la escuela

### 6. Comida
- **id_comida** (PK): Identificador único del alimento (AUTO_INCREMENT)
- nombre: Nombre del producto alimenticio
- tipo_comida: Tipo o categoría del alimento
- fecha_caducidad: Fecha de caducidad del producto
- id_donacion (FK): Referencia a la donación

### 7. Entrega
- **id_entrega** (PK): Identificador único de la entrega (AUTO_INCREMENT)
- estado: Estado actual de la entrega
- fecha_entrega: Fecha programada o realizada de entrega
- id_admin (FK): Referencia al administrador responsable
- id_donacion (FK): Referencia a la donación entregada

## Relaciones

1. **Donador - Donacion**: Relación 1:N (Un donador puede realizar múltiples donaciones)
2. **Donacion - Escuela**: Relación 1:N (Una donación puede ir a múltiples escuelas)
3. **Escuela - Administrador**: Relación 1:N (Una escuela tiene varios administradores)
4. **Escuela - Alumno**: Relación 1:N (Una escuela tiene múltiples alumnos)
5. **Administrador - Entrega**: Relación 1:N (Un administrador gestiona varias entregas)
6. **Donacion - Entrega**: Relación 1:N (Una donación puede tener múltiples entregas)
7. **Donacion - Comida**: Relación 1:N (Una donación contiene múltiples alimentos)

## Reglas de Negocio

1. Cada donación debe estar asociada a un donador
2. El sistema gestiona donaciones para la escuela UTRM
3. Los administradores gestionan las entregas de la escuela
4. Las entregas tienen estados: pendiente, en_proceso, completada, cancelada
5. Los alimentos tienen fecha de caducidad que debe ser validada
6. Cada alumno tiene una matrícula única
7. Los alumnos están organizados por grupos y cuatrimestres
8. La tabla escuela almacena la información de UTRM

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
```

## Normalización

El modelo se encuentra en Tercera Forma Normal (3FN):
- **Primera Forma Normal (1FN)**: ✓ Todos los atributos contienen valores atómicos
- **Segunda Forma Normal (2FN)**: ✓ Todos los atributos no clave dependen de la clave primaria completa
- **Tercera Forma Normal (3FN)**: ✓ No existen dependencias transitivas

## Tipos de Datos (MySQL/MariaDB)

| Campo | Tipo MySQL |
|-------|-----------|
| id_* | INT AUTO_INCREMENT |
| nombre | VARCHAR(60) |
| correo | VARCHAR(150) o VARCHAR(100) |
| celular/numero | VARCHAR(10) |
| direccion | VARCHAR(255) |
| tipo_comida | VARCHAR(50) |
| estado | VARCHAR(20) |
| fecha_* | DATE |
| grupo | VARCHAR(10) |
| cuatrimestre | VARCHAR(10) |
| matricula | VARCHAR(7) UNIQUE |
| cantidad | INT |
| destino | VARCHAR(255) |
