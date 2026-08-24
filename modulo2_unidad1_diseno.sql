CREATE TABLE clientes (
    id_cliente INT NOT NULL, -- INT porque el identificador del cliente es un número entero
    nombre VARCHAR(100) NOT NULL, -- VARCHAR porque almacena texto de hasta 100 caracteres
    perfil_bio TEXT, -- TEXT porque permite almacenar textos largos
    fecha_registro DATE NOT NULL -- DATE porque necesitamos almacenar únicamente la fecha 
);

CREATE TABLE productos (
    id_producto INT NOT NULL, -- INT porque el identificador del producto es un número entero
    descripcion VARCHAR(255) NOT NULL, -- VARCHAR porque almacena texto de hasta 255 caracteres
    precio DECIMAL (10,2) NOT NULL, -- DECIMAL porque permite almacenar valores monetarios con precisión exacta 
    esta_activo SMALLINT NOT NULL -- SMALLINT porque permite representar el estado: 0 = inactivo, 1 = activo
);
