CREATE DATABASE Ventas_Tech_DB;

USE Ventas_Tech_DB;

DROP TABLE IF EXISTS ventas;

CREATE TABLE ventas (
id_venta INT PRIMARY KEY,
id_cliente INT,
FOREIGN KEY (id_cliente) REFERENCES clientes (id_cliente),
id_producto INT,
FOREIGN KEY (id_producto) REFERENCES productos (id_producto),
cantidad INT NOT NULL,
precio_unitario DECIMAL (10,2) NOT NULL,
fecha_venta DATE NOT NULL
);

INSERT INTO ventas VALUES (1,  1, 1, 2, 1200.00, '2024-03-05');
INSERT INTO ventas VALUES (2,  2, 2, 5,   28.00, '2024-03-06');
INSERT INTO ventas VALUES (3,  3, 3, 1,  450.00, '2024-03-07');
INSERT INTO ventas VALUES (4,  1, 4, 2,  120.00, '2024-03-08');
INSERT INTO ventas VALUES (5,  4, 5, 3,  130.00, '2024-03-10');
INSERT INTO ventas VALUES (6,  2, 6, 4,   95.00, '2024-03-11');
INSERT INTO ventas VALUES (7,  5, 1, 1, 1200.00, '2024-03-12');
INSERT INTO ventas VALUES (8,  3, 2, 8,   28.00, '2024-03-13');
INSERT INTO ventas VALUES (9,  4, 4, 1,  120.00, '2024-03-14');
INSERT INTO ventas VALUES (10, 5, 3, 2,  450.00, '2024-03-15');

SELECT 
    MONTH(fecha_venta) AS mes_venta,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(id_venta) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY MONTH(fecha_venta);

SELECT TOP (5) id_producto,
    SUM(cantidad * precio_unitario) AS total_facturado,
    SUM(cantidad) AS unidades_vendidas
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;

SELECT id_cliente,
    SUM(cantidad * precio_unitario) AS total_gastado,
    COUNT(id_venta) AS pedidos_realizados
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1;

WITH totales_mes AS (
    SELECT
        MONTH(fecha_venta) AS mes_venta,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY MONTH(fecha_venta)
)
SELECT
    mes_venta,
    total_facturado,
    CASE
        WHEN total_facturado > (SELECT AVG(total_facturado) FROM totales_mes)
            THEN 'Por encima'
        WHEN total_facturado < (SELECT AVG(total_facturado) FROM totales_mes)
            THEN 'Por debajo'
        ELSE 'Igual al promedio'
    END AS Performance
FROM totales_mes
ORDER BY mes_venta;

-- ============================================
-- Como la tabla de ventas del módulo 3 sólo tiene 10 ventas, es complejo obtener insights.
--
-- 1) El producto 1 es el que realmente domina la facturacion: concentra el 55,9% del total($3.600 de $6.444), aportado por solo 3 unidades vendidas entre
--    dos ventas (id 1 y 7). Es un peso alto en pocas unidades, no en volumen.
--
-- 2) El cliente1 es el de mayor gasto real ($2.640 en 2 pedidos), superando a cliente5 ($2.100).
--
-- 3) El producto 2 concentra el 44,8% de las unidades vendidas (13 de 29) pero apenas el 5,6% de la facturacion ($364 de $6.444)
--    Es el opuesto exacto del producto 1: mucho volumen, poco valor unitario ($28 c/u vs los $1.200 del producto 1).
-- ============================================
