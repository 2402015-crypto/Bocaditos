-- ============================================
-- Consultas Comunes
-- Sistema: Bocaditos - Sistema de Donaciones Alimentarias
-- Versión: 1.0.0
-- Descripción: Consultas SQL frecuentes del sistema
-- ============================================

-- ============================================
-- CONSULTAS DE REPORTES
-- ============================================

-- Reporte 1: Donaciones con información completa del donador
SELECT 
    d.id_donacion,
    d.cantidad,
    d.destino,
    d.fecha_donacion,
    don.nombre AS donador,
    don.correo AS correo_donador,
    don.celular AS telefono_donador,
    don.direccion AS direccion_donador
FROM donacion d
JOIN donador don ON d.id_donador = don.id_donador
ORDER BY d.fecha_donacion DESC;

-- Reporte 2: Entregas pendientes
SELECT 
    e.id_entrega,
    e.estado,
    e.fecha_entrega,
    a.nombre AS administrador,
    a.correo AS correo_admin,
    a.numero AS telefono_admin,
    esc.nombre AS escuela,
    esc.ubicacion,
    d.cantidad,
    d.destino
FROM entrega e
JOIN administrador a ON e.id_admin = a.id_admi
JOIN escuela esc ON a.id_escuela = esc.id_escuela
JOIN donacion d ON e.id_donacion = d.id_donacion
WHERE e.estado IN ('pendiente', 'en_proceso')
ORDER BY e.fecha_entrega ASC;

-- Reporte 3: Estadísticas de donaciones por donador
SELECT 
    don.nombre AS donador,
    don.correo,
    COUNT(d.id_donacion) AS total_donaciones,
    SUM(d.cantidad) AS cantidad_total,
    MIN(d.fecha_donacion) AS primera_donacion,
    MAX(d.fecha_donacion) AS ultima_donacion
FROM donador don
LEFT JOIN donacion d ON don.id_donador = d.id_donador
GROUP BY don.id_donador, don.nombre, don.correo
ORDER BY total_donaciones DESC, cantidad_total DESC;

-- Reporte 4: Alumnos por escuela
SELECT 
    esc.nombre AS escuela,
    esc.ubicacion,
    COUNT(al.id_alumno) AS total_alumnos,
    COUNT(DISTINCT al.grupo) AS grupos_diferentes,
    COUNT(DISTINCT al.cuatrimestre) AS cuatrimestres_diferentes
FROM escuela esc
LEFT JOIN alumno al ON esc.id_escuela = al.id_escuela
GROUP BY esc.id_escuela, esc.nombre, esc.ubicacion
ORDER BY total_alumnos DESC;

-- Reporte 5: Inventario de comidas por tipo
SELECT 
    c.tipo_comida,
    COUNT(c.id_comida) AS cantidad_productos,
    COUNT(CASE WHEN c.fecha_caducidad > CURRENT_DATE + INTERVAL '30 days' THEN 1 END) AS productos_buena_fecha,
    COUNT(CASE WHEN c.fecha_caducidad BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '30 days' THEN 1 END) AS productos_proximo_vencer,
    COUNT(CASE WHEN c.fecha_caducidad < CURRENT_DATE THEN 1 END) AS productos_vencidos
FROM comida c
GROUP BY c.tipo_comida
ORDER BY cantidad_productos DESC;

-- Reporte 6: Alimentos próximos a caducar (30 días)
SELECT 
    c.id_comida,
    c.nombre,
    c.tipo_comida,
    c.fecha_caducidad,
    CURRENT_DATE + INTERVAL '1 day' - c.fecha_caducidad AS dias_restantes,
    d.destino,
    d.cantidad AS cantidad_donacion,
    don.nombre AS donador
FROM comida c
JOIN donacion d ON c.id_donacion = d.id_donacion
JOIN donador don ON d.id_donador = don.id_donador
WHERE c.fecha_caducidad BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '30 days'
ORDER BY c.fecha_caducidad ASC;

-- Reporte 7: Rendimiento de administradores
SELECT 
    a.nombre AS administrador,
    a.correo,
    esc.nombre AS escuela,
    COUNT(e.id_entrega) AS total_entregas,
    COUNT(CASE WHEN e.estado = 'completada' THEN 1 END) AS entregas_completadas,
    COUNT(CASE WHEN e.estado = 'en_proceso' THEN 1 END) AS entregas_en_proceso,
    COUNT(CASE WHEN e.estado = 'pendiente' THEN 1 END) AS entregas_pendientes
FROM administrador a
LEFT JOIN entrega e ON a.id_admi = e.id_admin
LEFT JOIN escuela esc ON a.id_escuela = esc.id_escuela
GROUP BY a.id_admi, a.nombre, a.correo, esc.nombre
ORDER BY total_entregas DESC;

-- Reporte 8: Donaciones por mes
SELECT 
    DATE_TRUNC('month', d.fecha_donacion) AS mes,
    COUNT(d.id_donacion) AS total_donaciones,
    SUM(d.cantidad) AS cantidad_total,
    COUNT(DISTINCT d.id_donador) AS donadores_unicos
FROM donacion d
GROUP BY DATE_TRUNC('month', d.fecha_donacion)
ORDER BY mes DESC;

-- ============================================
-- CONSULTAS ADMINISTRATIVAS
-- ============================================

-- Consulta 1: Escuelas sin alumnos registrados
SELECT 
    e.id_escuela,
    e.nombre,
    e.ubicacion
FROM escuela e
LEFT JOIN alumno al ON e.id_escuela = al.id_escuela
WHERE al.id_alumno IS NULL
ORDER BY e.nombre;

-- Consulta 2: Donadores más activos (últimos 6 meses)
SELECT 
    don.nombre AS donador,
    don.correo,
    don.celular,
    COUNT(d.id_donacion) AS donaciones_recientes,
    SUM(d.cantidad) AS cantidad_total
FROM donador don
JOIN donacion d ON don.id_donador = d.id_donador
WHERE d.fecha_donacion >= CURRENT_DATE - INTERVAL '6 months'
GROUP BY don.id_donador, don.nombre, don.correo, don.celular
HAVING COUNT(d.id_donacion) > 0
ORDER BY donaciones_recientes DESC, cantidad_total DESC;

-- Consulta 3: Entregas completadas por escuela
SELECT 
    esc.nombre AS escuela,
    esc.ubicacion,
    COUNT(e.id_entrega) AS entregas_completadas,
    SUM(d.cantidad) AS total_alimentos_recibidos
FROM escuela esc
JOIN administrador a ON esc.id_escuela = a.id_escuela
JOIN entrega e ON a.id_admi = e.id_admin
JOIN donacion d ON e.id_donacion = d.id_donacion
WHERE e.estado = 'completada'
GROUP BY esc.id_escuela, esc.nombre, esc.ubicacion
ORDER BY entregas_completadas DESC;

-- Consulta 4: Alumnos por grupo y cuatrimestre
SELECT 
    al.cuatrimestre,
    al.grupo,
    COUNT(al.id_alumno) AS total_alumnos,
    esc.nombre AS escuela
FROM alumno al
JOIN escuela esc ON al.id_escuela = esc.id_escuela
GROUP BY al.cuatrimestre, al.grupo, esc.nombre
ORDER BY al.cuatrimestre, al.grupo;

-- ============================================
-- CONSULTAS DE ANÁLISIS
-- ============================================

-- Análisis 1: Distribución de alimentos por tipo
SELECT 
    c.tipo_comida,
    COUNT(c.id_comida) AS total_productos,
    ROUND(COUNT(c.id_comida) * 100.0 / (SELECT COUNT(*) FROM comida), 2) AS porcentaje
FROM comida c
GROUP BY c.tipo_comida
ORDER BY total_productos DESC;

-- Análisis 2: Eficiencia de entregas
SELECT 
    e.estado,
    COUNT(e.id_entrega) AS total,
    ROUND(COUNT(e.id_entrega) * 100.0 / (SELECT COUNT(*) FROM entrega), 2) AS porcentaje
FROM entrega e
GROUP BY e.estado
ORDER BY total DESC;

-- Análisis 3: Tiempo promedio entre donación y entrega
SELECT 
    AVG(e.fecha_entrega - d.fecha_donacion) AS dias_promedio_entrega,
    MIN(e.fecha_entrega - d.fecha_donacion) AS dias_minimos,
    MAX(e.fecha_entrega - d.fecha_donacion) AS dias_maximos
FROM entrega e
JOIN donacion d ON e.id_donacion = d.id_donacion
WHERE e.estado = 'completada';

-- Análisis 4: Cobertura por escuela (alumnos vs capacidad)
SELECT 
    esc.nombre AS escuela,
    COUNT(al.id_alumno) AS alumnos_registrados,
    COUNT(DISTINCT al.grupo) AS grupos_activos,
    ROUND(COUNT(al.id_alumno)::NUMERIC / NULLIF(COUNT(DISTINCT al.grupo), 0), 2) AS promedio_alumnos_por_grupo
FROM escuela esc
LEFT JOIN alumno al ON esc.id_escuela = al.id_escuela
GROUP BY esc.id_escuela, esc.nombre
ORDER BY alumnos_registrados DESC;

-- ============================================
-- CONSULTAS ÚTILES PARA OPERACIONES
-- ============================================

-- Obtener próximas entregas programadas
SELECT 
    e.fecha_entrega,
    e.estado,
    esc.nombre AS escuela,
    esc.ubicacion,
    a.nombre AS administrador_responsable,
    a.numero AS telefono_contacto,
    d.cantidad,
    don.nombre AS donador
FROM entrega e
JOIN administrador a ON e.id_admin = a.id_admi
JOIN escuela esc ON a.id_escuela = esc.id_escuela
JOIN donacion d ON e.id_donacion = d.id_donacion
JOIN donador don ON d.id_donador = don.id_donador
WHERE e.fecha_entrega >= CURRENT_DATE
  AND e.estado != 'cancelada'
ORDER BY e.fecha_entrega ASC;

-- Listar alimentos disponibles por donación
SELECT 
    d.id_donacion,
    d.destino,
    d.fecha_donacion,
    c.nombre AS alimento,
    c.tipo_comida,
    c.fecha_caducidad,
    CASE 
        WHEN c.fecha_caducidad < CURRENT_DATE THEN 'VENCIDO'
        WHEN c.fecha_caducidad <= CURRENT_DATE + INTERVAL '7 days' THEN 'URGENTE'
        WHEN c.fecha_caducidad <= CURRENT_DATE + INTERVAL '30 days' THEN 'PRONTO'
        ELSE 'BUENO'
    END AS urgencia
FROM donacion d
JOIN comida c ON d.id_donacion = c.id_donacion
ORDER BY d.fecha_donacion DESC, c.fecha_caducidad ASC;

-- Script completado
SELECT 'Consultas comunes cargadas exitosamente' AS mensaje;
