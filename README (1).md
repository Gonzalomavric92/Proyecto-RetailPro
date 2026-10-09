# RetailPro | Proyecto de Data Analytics

## Descripción

RetailPro es un proyecto académico de Data Analytics orientado a transformar datos transaccionales de ventas en información útil para la toma de decisiones comerciales. Integra consultas SQL, preparación de datos, modelado y visualización para analizar el desempeño por período, territorio, producto y segmento de cliente.

**Pregunta central:** ¿Qué territorios, productos y segmentos de clientes explican el desempeño comercial de RetailPro y dónde existen oportunidades de mejora?

## Objetivos

- Comparar el desempeño comercial entre territorios.
- Identificar productos y categorías con mayor facturación.
- Reconocer los clientes que más aportan a las ventas.
- Analizar la evolución temporal de las ventas.
- Detectar desvíos y oportunidades al cruzar territorio, producto y segmento de cliente.

## Modelo de datos

El modelo utiliza `ventas` como tabla central y dimensiones relacionadas.

| Tabla | Función | Campos representativos |
|---|---|---|
| `ventas` | Hechos transaccionales | `id_venta`, `fecha_venta`, `id_cliente`, `id_producto`, `cantidad`, `precio_unitario`, `total_venta`, `canal`, `id_territorio` |
| `clientes` | Clientes | `id_cliente`, `nombre`, `ciudad`, `segmento` |
| `productos` | Productos | `id_producto`, `nombre_producto`, `id_categoria`, `subcategoria`, `precio`, `costo` |
| `categorias` | Clasificación de productos | `id_categoria`, `descripcion` |
| `territorios` | Dimensión geográfica | `id_territorio`, `region`, `pais`, `zona` |

Las ventas se relacionan con clientes, productos y territorios; los productos se relacionan con categorías. Los nombres exactos pueden variar según la versión de los scripts del repositorio.

## Herramientas utilizadas

- **SQL Server:** almacenamiento y consulta de datos.
- **SQL Server Management Studio (SSMS):** conexión a la base y ejecución de scripts.
- **Excel:** revisión y preparación inicial de datos.
- **Power Query:** limpieza y transformación reproducible de datos.
- **Power BI:** modelado y dashboard ejecutivo.
- **DAX:** medidas explícitas e indicadores.
- **Git y GitHub:** versionado y documentación.

## Análisis y métricas

El proyecto explora facturación, cantidad de pedidos, ticket promedio, unidades vendidas, rankings de productos y clientes, comparaciones territoriales y evolución temporal.

Es importante distinguir entre **filas de venta**, **pedidos**, **unidades** y **facturación**. `COUNT(*)` cuenta filas; solo equivale a cantidad de pedidos si cada fila representa un pedido individual.

## Cómo ejecutar los scripts SQL

### Requisitos

1. SQL Server instalado o acceso a una instancia.
2. SQL Server Management Studio (SSMS) u otro cliente compatible.
3. Permisos suficientes para crear tablas y bases de datos.
4. Archivos de datos necesarios para cargar las tablas.

### 1. Clonar el repositorio

```bash
git clone <URL_DEL_REPOSITORIO>
cd <CARPETA_DEL_REPOSITORIO>
```

Reemplazá los valores entre `< >` por la URL y el nombre reales.

### 2. Conectarse a SQL Server

Abrí SSMS y conectate a tu instancia. El servidor y el método de autenticación dependen de tu instalación local.

### 3. Ejecutar los scripts en orden

Si el repositorio contiene scripts separados, el orden recomendado es:

1. Crear la base de datos.
2. Crear las tablas y claves.
3. Cargar los datos.
4. Ejecutar consultas de validación.
5. Ejecutar las consultas analíticas.

Revisá la carpeta `sql/` y utilizá los nombres de archivo reales del repositorio. No vuelvas a ejecutar scripts destructivos o de carga sin comprobar sus efectos.

### 4. Seleccionar la base

Si la base se llama `RetailPro_DB`, podés seleccionar el contexto así:

```sql
USE RetailPro_DB;
GO
```

Adaptá el nombre si tus scripts utilizan otro.

### 5. Validar la carga

```sql
SELECT COUNT(*) AS cantidad_registros
FROM ventas;

SELECT COUNT(*) AS cantidad_clientes FROM clientes;
SELECT COUNT(*) AS cantidad_productos FROM productos;
SELECT COUNT(*) AS cantidad_categorias FROM categorias;
SELECT COUNT(*) AS cantidad_territorios FROM territorios;
```

Estos ejemplos presuponen que las tablas tienen esos nombres y están en el esquema predeterminado.

### 6. Ejecutar una consulta de detalle

La siguiente consulta combina ventas con productos, categorías y clientes:

```sql
SELECT
    v.fecha_venta,
    v.id_cliente,
    cl.ciudad,
    p.nombre_producto,
    c.descripcion AS categoria,
    v.cantidad,
    v.precio_unitario,
    (v.cantidad * v.precio_unitario) AS total_venta
FROM ventas AS v
INNER JOIN productos AS p
    ON v.id_producto = p.id_producto
INNER JOIN categorias AS c
    ON p.id_categoria = c.id_categoria
INNER JOIN clientes AS cl
    ON v.id_cliente = cl.id_cliente;
```

El resultado es un conjunto de datos a nivel de detalle, no un resumen agregado. `INNER JOIN` conserva únicamente las filas con coincidencias en las tablas relacionadas.

### Ejemplos de consultas agregadas

**Facturación mensual**

```sql
SELECT
    MONTH(fecha_venta) AS mes_venta,
    SUM(total_venta) AS total_facturado,
    COUNT(*) AS cantidad_registros,
    AVG(total_venta) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes_venta;
```

`COUNT(*)` cuenta registros. Si un pedido puede ocupar varias filas, calculá pedidos con `COUNT(DISTINCT id_pedido)` usando el campo real de pedido, si existe.

**Facturación y unidades por producto**

```sql
SELECT
    id_producto,
    SUM(total_venta) AS total_facturado,
    SUM(cantidad) AS unidades_vendidas
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;
```

**Ranking de clientes**

```sql
SELECT
    id_cliente,
    SUM(total_venta) AS total_gastado,
    COUNT(*) AS cantidad_registros
FROM ventas
GROUP BY id_cliente
ORDER BY total_gastado DESC;
```

## Flujo de trabajo

```text
Fuentes de datos
    ↓
Limpieza y transformación (Excel / Power Query)
    ↓
Base relacional y consultas SQL
    ↓
Modelo analítico (Power BI / DAX)
    ↓
Dashboard ejecutivo
    ↓
Hallazgos y recomendaciones comerciales
```

## Dashboard

El dashboard se organiza con una lógica ejecutiva y de storytelling:

1. **KPIs:** visión general del resultado.
2. **Tendencias:** evolución de las ventas.
3. **Diagnóstico:** comparación por territorio y producto.
4. **Detalle:** ranking de clientes y transacciones.

El objetivo es facilitar el paso de una visión general a una investigación más específica.

## Líneas de análisis comercial

- **Concentración por cliente:** evaluar fidelización y posible dependencia de cuentas importantes.
- **Productos relevantes:** detectar productos con elevada facturación o volumen y estudiar oportunidades de venta cruzada.
- **Facturación frente a volumen:** distinguir meses con muchos pedidos de aquellos cuyo resultado depende de pocas operaciones de alto valor.

Estos puntos son líneas de investigación, no conclusiones universales. Conviene validarlos con el período completo, los márgenes, descuentos y otras variables relevantes.

## Buenas prácticas

- Mantener los scripts ordenados y con nombres descriptivos.
- Utilizar alias claros y formato consistente en SQL.
- Validar calidad de datos y relaciones antes de analizar.
- Diferenciar facturación, pedidos, unidades y ticket promedio.
- Utilizar medidas DAX explícitas.
- Documentar supuestos y limitaciones.
- Evitar afirmaciones causales cuando los datos solo muestran asociaciones.
- No subir credenciales ni información confidencial al repositorio.

## Estructura sugerida del repositorio

Esta estructura es una propuesta: adaptala a los archivos que efectivamente estén versionados.

```text
RetailPro/
├── README.md
├── data/
│   ├── raw/
│   └── processed/
├── sql/
│   ├── 01_create_database.sql
│   ├── 02_create_tables.sql
│   ├── 03_load_data.sql
│   ├── 04_validate_data.sql
│   └── 05_analytical_queries.sql
├── power_query/
├── power_bi/
├── excel/
└── docs/
```

## Resultado esperado

RetailPro combina SQL, preparación de datos y visualización para convertir registros de ventas en indicadores e insights comerciales. El resultado esperado es un proceso de análisis reproducible y un dashboard que ayude a identificar tendencias, desvíos y oportunidades de crecimiento.

## Autoría

**Proyecto académico de Data Analytics — RetailPro**

Herramientas: SQL Server · SSMS · Excel · Power Query · Power BI · DAX · GitHub
