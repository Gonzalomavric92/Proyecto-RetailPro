-- ══════════════════════════════════════════
-- BodegaTech — Script de Inventario
-- Autor: Gonzalo Mavric
-- Fecha: 25-8-26
-- ══════════════════════════════════════════
-- ── SECCIÓN DDL ──────────────────────────
DROP TABLE IF EXISTS inventario;
CREATE TABLE inventario (
  id_producto INT NOT NULL IDENTITY (1,1) PRIMARY KEY, -- INT permite almacenar números enteros para identificar cada producto
  nombre_producto VARCHAR(100) NOT NULL, -- VARCHAR permite almacenar nombres de texto de longitud variable
  categoria VARCHAR(50) NOT NULL,
  precio_unitario DECIMAL(10,2) NOT NULL, -- DECIMAL permite almacenar precios con precisión de dos decimales
  stock_actual INT NOT NULL,
  stock_minimo INT NOT NULL,
  fecha_ingreso DATE NOT NULL, -- DATE permite almacenar únicamente la fecha de ingreso del producto
  activo TINYINT NOT NULL
);
-- ── SECCIÓN DML ──────────────────────────
INSERT INTO inventario (nombre_producto, categoria, precio_unitario, stock_actual, stock_minimo, fecha_ingreso, activo)
VALUES ('Laptop Pro 15', 'Computación', 1200.00, 15, 3, '2024-01-10', 1);
INSERT INTO inventario (nombre_producto, categoria, precio_unitario, stock_actual, stock_minimo, fecha_ingreso, activo)
VALUES ('Mouse Inalámbrico', 'Accesorios', 28.00, 80, 10, '2024-01-10', 1);
INSERT INTO inventario (nombre_producto, categoria, precio_unitario, stock_actual, stock_minimo, fecha_ingreso, activo)
VALUES ('Monitor 4K 27"', 'Computación', 450.00, 12, 2, '2024-01-15', 1);
INSERT INTO inventario (nombre_producto, categoria, precio_unitario, stock_actual, stock_minimo, fecha_ingreso, activo)
VALUES ('Teclado Mecánico', 'Accesorios', 95.00, 40, 5, '2024-01-15', 1);
INSERT INTO inventario (nombre_producto, categoria, precio_unitario, stock_actual, stock_minimo, fecha_ingreso, activo)
VALUES ('Laptop Basic 14', 'Computación', 650.00, 20, 3, '2024-02-01', 1);
INSERT INTO inventario (nombre_producto, categoria, precio_unitario, stock_actual, stock_minimo, fecha_ingreso, activo)
VALUES ('Auriculares BT Pro', 'Audio', 120.00, 35, 5, '2024-02-01', 1);
INSERT INTO inventario (nombre_producto, categoria, precio_unitario, stock_actual, stock_minimo, fecha_ingreso, activo)
VALUES ('Hub USB-C 7 puertos', 'Accesorios', 45.00, 60, 10, '2024-02-10', 1);
INSERT INTO inventario (nombre_producto, categoria, precio_unitario, stock_actual, stock_minimo, fecha_ingreso, activo)
VALUES ('Webcam HD 1080p', 'Accesorios', 85.00, 25, 5, '2024-02-10', 1);
INSERT INTO inventario (nombre_producto, categoria, precio_unitario, stock_actual, stock_minimo, fecha_ingreso, activo)
VALUES ('SSD Externo 1TB', 'Almacenamiento', 130.00, 18, 3, '2024-03-01', 1);
INSERT INTO inventario (nombre_producto, categoria, precio_unitario, stock_actual, stock_minimo, fecha_ingreso, activo)
VALUES ('Parlante Bluetooth', 'Audio', 60.00, 45, 8, '2024-03-01', 1);
UPDATE inventario SET stock_actual = 12 WHERE id_producto = 1;
UPDATE inventario SET stock_actual = 68 WHERE id_producto = 2;
UPDATE inventario SET stock_actual = 30 WHERE id_producto = 6;
UPDATE inventario SET activo = 0 WHERE id_producto = 8;
SELECT * FROM inventario;
