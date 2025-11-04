-- ============================================
-- Consultas Comunes
-- Sistema: Bocaditos - Apoyo Alimentario Escolar UTRM
-- Versión: 1.0.0
-- Descripción: Consultas SQL frecuentes del sistema
-- ============================================

-- ============================================
-- CONSULTAS DE REPORTES
-- ============================================

-- Reporte 1: Menú del día con disponibilidad
SELECT 
    m.fecha,
    b.nombre AS bocadito,
    b.categoria,
    b.precio,
    mb.cantidad_disponible,
    b.calorias
FROM menu_diario m
JOIN menu_bocadito mb ON m.id_menu = mb.id_menu
JOIN bocadito b ON mb.id_bocadito = b.id_bocadito
WHERE m.fecha = CURRENT_DATE
ORDER BY b.categoria, b.nombre;

-- Reporte 2: Pedidos pendientes por entregar
SELECT 
    p.id_pedido,
    e.nombre || ' ' || e.apellido AS estudiante,
    e.grado,
    t.nombre || ' ' || t.apellido AS tutor,
    t.telefono AS telefono_tutor,
    m.fecha AS fecha_menu,
    p.fecha_pedido,
    p.notas
FROM pedido p
JOIN estudiante e ON p.id_estudiante = e.id_estudiante
JOIN tutor t ON e.id_tutor = t.id_tutor
JOIN menu_diario m ON p.id_menu = m.id_menu
WHERE p.estado = 'confirmado'
ORDER BY m.fecha, e.grado, e.nombre;

-- Reporte 3: Estadísticas diarias de pedidos
SELECT 
    m.fecha,
    COUNT(DISTINCT p.id_pedido) AS total_pedidos,
    COUNT(DISTINCT CASE WHEN p.estado = 'confirmado' THEN p.id_pedido END) AS confirmados,
    COUNT(DISTINCT CASE WHEN p.estado = 'entregado' THEN p.id_pedido END) AS entregados,
    COUNT(DISTINCT CASE WHEN p.estado = 'cancelado' THEN p.id_pedido END) AS cancelados,
    COUNT(DISTINCT p.id_estudiante) AS estudiantes_unicos
FROM menu_diario m
LEFT JOIN pedido p ON m.id_menu = p.id_menu
GROUP BY m.fecha
ORDER BY m.fecha DESC;

-- Reporte 4: Estudiantes más activos
SELECT 
    e.id_estudiante,
    e.nombre || ' ' || e.apellido AS estudiante,
    e.grado,
    COUNT(p.id_pedido) AS total_pedidos,
    COUNT(CASE WHEN p.estado = 'entregado' THEN 1 END) AS pedidos_entregados,
    MAX(p.fecha_pedido) AS ultimo_pedido
FROM estudiante e
LEFT JOIN pedido p ON e.id_estudiante = p.id_estudiante
GROUP BY e.id_estudiante, e.nombre, e.apellido, e.grado
HAVING COUNT(p.id_pedido) > 0
ORDER BY total_pedidos DESC
LIMIT 10;

-- Reporte 5: Bocaditos más populares
SELECT 
    b.nombre,
    b.categoria,
    b.precio,
    COUNT(mb.id_menu) AS veces_en_menu,
    SUM(mb.cantidad_disponible) AS total_disponible
FROM bocadito b
LEFT JOIN menu_bocadito mb ON b.id_bocadito = mb.id_bocadito
WHERE b.activo = TRUE
GROUP BY b.id_bocadito, b.nombre, b.categoria, b.precio
ORDER BY veces_en_menu DESC, total_disponible DESC;

-- Reporte 6: Rendimiento de responsables
SELECT 
    r.nombre || ' ' || r.apellido AS responsable,
    r.cargo,
    COUNT(ent.id_entrega) AS total_entregas,
    MIN(ent.fecha_entrega) AS primera_entrega,
    MAX(ent.fecha_entrega) AS ultima_entrega
FROM responsable r
LEFT JOIN entrega ent ON r.id_responsable = ent.id_responsable
GROUP BY r.id_responsable, r.nombre, r.apellido, r.cargo
ORDER BY total_entregas DESC;

-- Reporte 7: Análisis por grado escolar
SELECT 
    e.grado,
    COUNT(DISTINCT e.id_estudiante) AS total_estudiantes,
    COUNT(p.id_pedido) AS total_pedidos,
    ROUND(COUNT(p.id_pedido)::NUMERIC / NULLIF(COUNT(DISTINCT e.id_estudiante), 0), 2) AS promedio_pedidos_estudiante
FROM estudiante e
LEFT JOIN pedido p ON e.id_estudiante = p.id_estudiante
GROUP BY e.grado
ORDER BY e.grado;

-- Reporte 8: Disponibilidad próximos 7 días
SELECT 
    m.fecha,
    m.descripcion,
    COUNT(mb.id_bocadito) AS bocaditos_disponibles,
    SUM(mb.cantidad_disponible) AS total_porciones
FROM menu_diario m
LEFT JOIN menu_bocadito mb ON m.id_menu = mb.id_menu
WHERE m.fecha BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '7 days'
GROUP BY m.id_menu, m.fecha, m.descripcion
ORDER BY m.fecha;

-- ============================================
-- CONSULTAS ADMINISTRATIVAS
-- ============================================

-- Consulta 1: Tutores con múltiples estudiantes
SELECT 
    t.nombre || ' ' || t.apellido AS tutor,
    t.email,
    t.telefono,
    COUNT(e.id_estudiante) AS cantidad_estudiantes,
    STRING_AGG(e.nombre || ' ' || e.apellido, ', ') AS estudiantes
FROM tutor t
JOIN estudiante e ON t.id_tutor = e.id_tutor
GROUP BY t.id_tutor, t.nombre, t.apellido, t.email, t.telefono
HAVING COUNT(e.id_estudiante) > 1
ORDER BY cantidad_estudiantes DESC;

-- Consulta 2: Pedidos sin entregar (más de 1 día)
SELECT 
    p.id_pedido,
    e.nombre || ' ' || e.apellido AS estudiante,
    m.fecha AS fecha_menu,
    p.fecha_pedido,
    p.estado,
    CURRENT_DATE - m.fecha AS dias_retraso
FROM pedido p
JOIN estudiante e ON p.id_estudiante = e.id_estudiante
JOIN menu_diario m ON p.id_menu = m.id_menu
WHERE p.estado IN ('confirmado', 'pendiente')
  AND m.fecha < CURRENT_DATE
ORDER BY dias_retraso DESC;

-- Consulta 3: Bocaditos nunca incluidos en menús
SELECT 
    b.nombre,
    b.categoria,
    b.precio,
    b.fecha_creacion
FROM bocadito b
LEFT JOIN menu_bocadito mb ON b.id_bocadito = mb.id_bocadito
WHERE mb.id_bocadito IS NULL
  AND b.activo = TRUE
ORDER BY b.fecha_creacion;

-- Consulta 4: Estudiantes sin pedidos recientes (últimos 30 días)
SELECT 
    e.id_estudiante,
    e.nombre || ' ' || e.apellido AS estudiante,
    e.grado,
    t.nombre || ' ' || t.apellido AS tutor,
    t.telefono,
    MAX(p.fecha_pedido) AS ultimo_pedido
FROM estudiante e
JOIN tutor t ON e.id_tutor = t.id_tutor
LEFT JOIN pedido p ON e.id_estudiante = p.id_estudiante
WHERE e.activo = TRUE
GROUP BY e.id_estudiante, e.nombre, e.apellido, e.grado, t.nombre, t.apellido, t.telefono
HAVING MAX(p.fecha_pedido) IS NULL 
   OR MAX(p.fecha_pedido) < CURRENT_DATE - INTERVAL '30 days'
ORDER BY e.grado, e.nombre;

-- ============================================
-- CONSULTAS DE ANÁLISIS
-- ============================================

-- Análisis 1: Preferencias por categoría
SELECT 
    b.categoria,
    COUNT(DISTINCT mb.id_menu) AS menus_incluido,
    AVG(mb.cantidad_disponible) AS promedio_cantidad,
    AVG(b.precio) AS precio_promedio
FROM bocadito b
JOIN menu_bocadito mb ON b.id_bocadito = mb.id_bocadito
GROUP BY b.categoria
ORDER BY menus_incluido DESC;

-- Análisis 2: Tendencia de pedidos por mes
SELECT 
    DATE_TRUNC('month', p.fecha_pedido) AS mes,
    COUNT(p.id_pedido) AS total_pedidos,
    COUNT(DISTINCT p.id_estudiante) AS estudiantes_activos,
    COUNT(CASE WHEN p.estado = 'entregado' THEN 1 END) AS entregados
FROM pedido p
GROUP BY DATE_TRUNC('month', p.fecha_pedido)
ORDER BY mes DESC;

-- Análisis 3: Eficiencia de entregas por día de la semana
SELECT 
    TO_CHAR(m.fecha, 'Day') AS dia_semana,
    COUNT(p.id_pedido) AS total_pedidos,
    COUNT(ent.id_entrega) AS total_entregas,
    ROUND(COUNT(ent.id_entrega)::NUMERIC / NULLIF(COUNT(p.id_pedido), 0) * 100, 2) AS porcentaje_entrega
FROM menu_diario m
JOIN pedido p ON m.id_menu = p.id_menu
LEFT JOIN entrega ent ON p.id_pedido = ent.id_pedido
GROUP BY TO_CHAR(m.fecha, 'Day'), EXTRACT(DOW FROM m.fecha)
ORDER BY EXTRACT(DOW FROM m.fecha);

-- Script completado
SELECT 'Consultas comunes cargadas exitosamente' AS mensaje;
