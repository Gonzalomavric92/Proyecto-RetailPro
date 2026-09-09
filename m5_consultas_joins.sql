CREATE DATABASE Ventas_Tech_DB;

USE Ventas_Tech_DB;

DROP TABLE IF EXISTS ventas;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS categorias;

CREATE TABLE categorias (
id_categoria INT PRIMARY KEY,
nombre_categoria VARCHAR(50) NOT NULL,
descripcion VARCHAR(200)
);

CREATE TABLE clientes (
id_cliente INT PRIMARY KEY,
nombre VARCHAR(100) NOT NULL,
email VARCHAR(100) UNIQUE,
ciudad VARCHAR(50),
fecha_registro DATE NOT NULL
);

CREATE TABLE productos (
id_producto INT PRIMARY KEY,
nombre_producto VARCHAR(100) NOT NULL,
id_categoria INT,
FOREIGN KEY (id_categoria) REFERENCES categorias (id_categoria),
precio DECIMAL (10,2) NOT NULL,
stock INT DEFAULT 0,
activo TINYINT DEFAULT 1
);

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

INSERT INTO categorias VALUES (1, 'Computación', 'Laptops, PCs y monitores');
INSERT INTO categorias VALUES (2, 'Accesorios', 'Periféricos y complementos');
INSERT INTO categorias VALUES (3, 'Audio', 'Auriculares y parlantes');
INSERT INTO categorias VALUES (4, 'Almacenamiento', 'Discos y memorias');

INSERT INTO clientes VALUES (1, 'María López',   'maria@mail.com',   'Buenos Aires', '2024-01-05');
INSERT INTO clientes VALUES (2, 'Carlos Ruiz',   'carlos@mail.com',  'Córdoba',      '2024-01-10');
INSERT INTO clientes VALUES (3, 'Ana Gómez',     'ana@mail.com',     'Rosario',      '2024-02-01');
INSERT INTO clientes VALUES (4, 'Pedro Sanz',    'pedro@mail.com',   'Mendoza',      '2024-02-15');
INSERT INTO clientes VALUES (5, 'Laura Torres',  'laura@mail.com',   'Tucumán',      '2024-03-01');

INSERT INTO productos VALUES (1, 'Laptop Pro 15',       1, 1200.00, 15, 1);
INSERT INTO productos VALUES (2, 'Mouse Inalámbrico',   2,   28.00, 80, 1);
INSERT INTO productos VALUES (3, 'Monitor 4K 27"',      1,  450.00, 12, 1);
INSERT INTO productos VALUES (4, 'Auriculares BT Pro',  3,  120.00, 35, 1);
INSERT INTO productos VALUES (5, 'SSD Externo 1TB',     4,  130.00, 18, 1);
INSERT INTO productos VALUES (6, 'Teclado Mecánico',    2,   95.00, 40, 1);

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

SELECT * FROM categorias;
SELECT * FROM clientes;
SELECT * FROM productos;
SELECT * FROM ventas;

-- Consulta 1 — Vista base del proyecto (INNER JOIN)
-- obtener en una sola fila, como mínimo: fecha, identificación del cliente, descripción del producto, cantidad, 
-- precio unitario y total de venta.

SELECT v.fecha_venta, v.id_cliente, cl.ciudad, p.nombre_producto, c.descripcion, v.cantidad, v.precio_unitario, 
(v.cantidad * v.precio_unitario) AS 'Total de Venta'
FROM ventas v
JOIN productos p
ON v.id_producto = p.id_producto
JOIN categorias c
ON p.id_categoria = c.id_categoria
JOIN clientes cl
ON v.id_cliente = cl.id_cliente;

-- Consulta 2 — Clientes sin ventas (LEFT JOIN) Identificá clientes registrados que aún no han realizado ninguna compra. 
-- Mostrá su nombre, email y fecha de registro. Usá WHERE ... IS NULL para aislar los casos.

-- Agrego un cliente nuevo que no tenga ventas realizadas

INSERT INTO clientes VALUES (6, 'Gonzalo Mavric',  'gonzalo@mail.com',   'Buenos Aires',      '2024-03-01');

SELECT c.id_cliente, c.nombre, c.email, c.ciudad, c.fecha_registro, v.id_venta
FROM clientes c
LEFT JOIN ventas v
ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;

-- Consulta 3 — Productos sin ventas (LEFT JOIN) Identificá productos del catálogo que no tienen ninguna venta registrada. 
-- Mostrá nombre del producto, categoría y precio. Usá WHERE ... IS NULL.

-- Agrego un producto nuevo que no tenga ventas realizadas

INSERT INTO productos VALUES (7, 'Parlante Bluetooth',    2,   200.00, 10, 1);

SELECT p.id_producto, p.nombre_producto, p.id_categoria, p.precio, p.stock, p.activo, v.id_venta
FROM productos p
LEFT JOIN ventas v
ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL;

-- Consulta 4 — Consolidado por canal (UNION ALL)

SELECT canal, COUNT(*) AS cantidad_ventas, SUM(total) AS total_vendido
FROM (
    SELECT fecha_venta AS fecha, cantidad * precio_unitario AS total, 'Primera quincena' AS canal
    FROM ventas
    WHERE fecha_venta <= '2024-03-09'
    UNION ALL
    SELECT fecha_venta AS fecha, cantidad * precio_unitario AS total, 'Segunda quincena' AS canal
    FROM ventas
    WHERE fecha_venta > '2024-03-09'
     ) AS consolidado
GROUP BY canal;
