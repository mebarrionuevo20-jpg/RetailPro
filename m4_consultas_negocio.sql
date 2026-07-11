SELECT
    EXTRACT(MONTH FROM fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    ROUND(SUM(cantidad * precio_unitario) / COUNT(*), 2) AS ticket_promedio
FROM ventas
GROUP BY EXTRACT(MONTH FROM fecha_venta)
ORDER BY mes;

SELECT
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC
LIMIT 5;

SELECT
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY total_gastado DESC;

WITH facturacion_mensual AS (
    SELECT
        EXTRACT(MONTH FROM fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY EXTRACT(MONTH FROM fecha_venta)
)

SELECT
    mes,
    total_facturado,
    ROUND(AVG(total_facturado) OVER (), 2) AS promedio_mensual_general,
    CASE
        WHEN total_facturado > AVG(total_facturado) OVER () THEN 'Por encima'
        ELSE 'Por debajo'
    END AS comparacion_con_promedio
FROM facturacion_mensual
ORDER BY mes;

-- 1) El total facturado en el mes 3 fue de $6.444,00, con 10 pedidos registrados y un ticket promedio de $644,40 por pedido. 
-- 2) El producto 1 fue el que más facturación generó: $3.600,00. Esto representa aproximadamente el 55,87% del total facturado.
-- 3) Todos los clientes registrados realizaron más de un pedido.Los clientes 1 y 5 fueron los que más gastaron, con $2.640,00 y $2.100,00 respectivamente.
