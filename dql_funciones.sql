-- 1. TotalIngresosCliente(ClienteID, Año): Calcula los ingresos generados por un cliente en un año específico.
DELIMITER //
CREATE FUNCTION TotalIngresosCliente(ClienteID SMALLINT UNSIGNED, Año INT)
RETURNS DECIMAL(10,2)
BEGIN
    DECLARE TotalIngresos DECIMAL(10,2);
    
    SELECT SUM(p.precio) INTO TotalIngresos
    FROM alquiler a
    JOIN inventario i ON a.id_inventario = i.id
    JOIN pelicula p ON i.id_pelicula = p.id
    WHERE a.id_cliente = ClienteID AND YEAR(a.fecha_alquiler) = Año;
    
    RETURN TotalIngresos;
END //
DELIMITER ;

-- 2. PromedioDuracionAlquiler(PeliculaID): Retorna la duración promedio de alquiler de una película específica.
DELIMITER //
CREATE FUNCTION PromedioDuracionAlquiler(PeliculaID SMALLINT UNSIGNED)
RETURNS DECIMAL(10,2)
BEGIN
    DECLARE PromedioDuracion DECIMAL(10,2);
    
    SELECT AVG(TIMESTAMPDIFF(HOUR, a.fecha_alquiler, a.fecha_devolucion)) INTO PromedioDuracion
    FROM alquiler a
    JOIN inventario i ON a.id_inventario = i.id
    WHERE i.id_pelicula = PeliculaID;
    
    RETURN PromedioDuracion;
END //
deLIMITER ;

-- 3. IngresosPorCategoria(CategoriaID): Calcula los ingresos totales generados por una categoría específica de películas.
deLIMITER //
CREATE FUNCTION IngresosPorCategoria(CategoriaID SMALLINT UNSIGNED)
RETURNS DECIMAL(10,2)
BEGIN
    DECLARE TotalIngresos DECIMAL(10,2);
    
    SELECT SUM(p.precio) INTO TotalIngresos
    FROM pelicula_categoria pc
    JOIN pelicula p ON pc.id_pelicula = p.id
    WHERE pc.id_categoria = CategoriaID;
    
    RETURN TotalIngresos;
END //
DELIMITER ;

-- 4. DescuentoFrecuenciaCliente(ClienteID): Calcula un descuento basado en la frecuencia de alquiler del cliente.
deLIMITER //
CREATE FUNCTION DescuentoFrecuenciaCliente(ClienteID SMALLINT UNSIGNED)
RETURNS DECIMAL(5,2)
BEGIN
    DECLARE Descuento DECIMAL(5,2);
    
    SELECT CASE 
        WHEN COUNT(a.id_alquiler) > 10 THEN 0.20
        WHEN COUNT(a.id_alquiler) BETWEEN 5 AND 10 THEN 0.10
        ELSE 0.05
    END INTO Descuento
    FROM alquiler a
    WHERE a.id_cliente = ClienteID;
    
    RETURN Descuento;
END //
DELIMITER ;

-- 5. EsClienteVIP(ClienteID): Verifica si un cliente es "VIP" basándose en la cantidad de alquileres realizados y los ingresos generados.
DELIMITER //
CREATE FUNCTION EsClienteVIP(ClienteID SMALLINT UNSIGNED)
RETURNS TINYINT(1)
BEGIN
    DECLARE EsVIP TINYINT(1);
    
    SELECT CASE 
        WHEN COUNT(a.id_alquiler) > 20 AND SUM(p.precio) > 1000 THEN 1
        ELSE 0
    END INTO EsVIP
    FROM alquiler a
    JOIN inventario i ON a.id_inventario = i.id
    JOIN pelicula p ON i.id_pelicula = p.id
    WHERE a.id_cliente = ClienteID;
    
    RETURN EsVIP;
END //
DELIMITER ;