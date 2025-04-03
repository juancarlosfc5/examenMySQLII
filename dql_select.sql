-- 1. Encuentra el cliente que ha realizado la mayor cantidad de alquileres en los últimos 6 meses.
SELECT cl.nombre, COUNT(a.id) AS Alquileres
FROM cliente cl
JOIN alquiler a ON cl.id = a.id_cliente
WHERE a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY cl.id
ORDER BY Alquileres DESC LIMIT 1;

-- 2. Lista las cinco películas más alquiladas durante el último año.
SELECT p.titulo, COUNT(a.id) AS Alquileres
FROM pelicula p
JOIN inventario i ON p.id = i.id_pelicula
JOIN alquiler a ON i.id = a.id_inventario
WHERE a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY p.id
ORDER BY Alquileres DESC LIMIT 5;

-- 3. Obtén el total de ingresos y la cantidad de alquileres realizados por cada categoría de película.
SELECT c.nombre, SUM(p.rental_rate) AS Ingresos, COUNT(a.id) AS Alquileres
FROM categoria c
JOIN pelicula_categoria pc ON c.id = pc.id_categoria
JOIN pelicula p ON pc.id_pelicula = p.id
JOIN inventario i ON p.id = i.id_pelicula
JOIN alquiler a ON i.id = a.id_inventario
WHERE a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY c.id
ORDER BY Ingresos DESC;

-- 4. Calcula el número total de clientes que han realizado alquileres por cada idioma disponible en un mes específico.
SELECT i.nombre, COUNT(DISTINCT cl.id) AS Clientes
FROM idioma i
JOIN pelicula p ON i.id = p.id_idioma
JOIN inventario inv ON p.id = inv.id_pelicula
JOIN alquiler a ON inv.id = a.id_inventario
JOIN cliente cl ON a.id_cliente = cl.id
WHERE a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
GROUP BY i.id
ORDER BY Clientes DESC;

-- 5. Encuentra a los clientes que han alquilado todas las películas de una misma categoría.
SELECT cl.nombre, c.nombre AS Categoria
FROM cliente cl
JOIN alquiler a ON cl.id = a.id_cliente
JOIN inventario i ON a.id_inventario = i.id
JOIN pelicula p ON i.id_pelicula = p.id
JOIN pelicula_categoria pc ON p.id = pc.id_pelicula
JOIN categoria c ON pc.id_categoria = c.id
GROUP BY cl.id, c.id
HAVING COUNT(DISTINCT p.id) = (SELECT COUNT(*) FROM pelicula p2 
                                 JOIN pelicula_categoria pc2 ON p2.id = pc2.id_pelicula 
                                 WHERE pc2.id_categoria = c.id);

-- 6. Lista las tres ciudades con más clientes activos en el último trimestre.
SELECT ci.nombre, COUNT(cl.id) AS Clientes
FROM ciudad ci
JOIN direccion d ON ci.id = d.id_ciudad
JOIN cliente cl ON d.id = cl.id_direccion
WHERE cl.activo = 1
GROUP BY ci.id
ORDER BY Clientes DESC LIMIT 3;

-- 7. Muestra las cinco categorías con menos alquileres registrados en el último año.
SELECT c.nombre, COUNT(a.id) AS Alquileres
FROM categoria c
JOIN pelicula_categoria pc ON c.id = pc.id_categoria
JOIN pelicula p ON pc.id_pelicula = p.id
JOIN inventario i ON p.id = i.id_pelicula
JOIN alquiler a ON i.id = a.id_inventario
WHERE a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY c.id
ORDER BY Alquileres ASC LIMIT 5;

-- 8. Calcula el promedio de días que un cliente tarda en devolver las películas alquiladas.
SELECT AVG(DATEDIFF(a.fecha_devolucion, a.fecha_alquiler)) AS Promedio_Dias
FROM alquiler a
WHERE a.fecha_devolucion IS NOT NULL;

-- 9. Encuentra los cinco empleados que gestionaron más alquileres en la categoría de Acción.
SELECT e.nombre, COUNT(a.id) AS Alquileres
FROM empleado e
JOIN alquiler a ON e.id = a.id_empleado
JOIN inventario i ON a.id_inventario = i.id
JOIN pelicula p ON i.id_pelicula = p.id
JOIN pelicula_categoria pc ON p.id = pc.id_pelicula
WHERE pc.id_categoria = (SELECT id FROM categoria WHERE nombre = 'Acción')
GROUP BY e.id
ORDER BY Alquileres DESC LIMIT 5;

-- 10. Genera un informe de los clientes con alquileres más recurrentes.
SELECT cl.nombre, COUNT(a.id) AS Alquileres
FROM cliente cl
JOIN alquiler a ON cl.id = a.id_cliente
GROUP BY cl.id
ORDER BY Alquileres DESC;

-- 11. Calcula el costo promedio de alquiler por idioma de las películas.
SELECT i.nombre, AVG(p.rental_rate) AS Costo_Promedio
FROM idioma i
JOIN pelicula p ON i.id = p.id_idioma
GROUP BY i.id
ORDER BY Costo_Promedio DESC;

-- 12. Lista las cinco películas con mayor duración alquiladas en el último año.
SELECT p.titulo, p.duracion
FROM pelicula p
JOIN inventario i ON p.id = i.id_pelicula
JOIN alquiler a ON i.id = a.id_inventario
WHERE a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
ORDER BY p.duracion DESC LIMIT 5;

-- 13. Muestra los clientes que más alquilaron películas de Comedia.
SELECT cl.nombre, COUNT(a.id) AS Alquileres
FROM cliente cl
JOIN alquiler a ON cl.id = a.id_cliente
JOIN inventario i ON a.id_inventario = i.id
JOIN pelicula p ON i.id_pelicula = p.id
JOIN pelicula_categoria pc ON p.id = pc.id_pelicula
WHERE pc.id_categoria = (SELECT id FROM categoria WHERE nombre = 'Comedia')
GROUP BY cl.id
ORDER BY Alquileres DESC;

-- 14. Encuentra la cantidad total de días alquilados por cada cliente en el último mes.
SELECT cl.nombre, SUM(DATEDIFF(a.fecha_devolucion, a.fecha_alquiler)) AS Dias_Alquilados
FROM cliente cl
JOIN alquiler a ON cl.id = a.id_cliente
WHERE a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
GROUP BY cl.id
ORDER BY Dias_Alquilados DESC;

-- 15. Muestra el número de alquileres diarios en cada almacén durante el último trimestre.
SELECT DATE(a.fecha_alquiler) AS Fecha, COUNT(a.id) AS Alquileres
FROM alquiler a
JOIN inventario i ON a.id_inventario = i.id
GROUP BY Fecha
HAVING a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
ORDER BY Fecha;

-- 16. Calcula los ingresos totales generados por cada almacén en el último semestre.
SELECT a.id_almacen, SUM(p.rental_rate) AS Ingresos
FROM alquiler a
JOIN inventario i ON a.id_inventario = i.id
JOIN pelicula p ON i.id_pelicula = p.id
WHERE a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY a.id_almacen
ORDER BY Ingresos DESC;

-- 17. Encuentra el cliente que ha realizado el alquiler más caro en el último año.
SELECT cl.nombre, MAX(p.rental_rate) AS Alquiler_Caro
FROM cliente cl
JOIN alquiler a ON cl.id = a.id_cliente
JOIN inventario i ON a.id_inventario = i.id
JOIN pelicula p ON i.id_pelicula = p.id
WHERE a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY cl.id
ORDER BY Alquiler_Caro DESC LIMIT 1;

-- 18. Lista las cinco categorías con más ingresos generados durante los últimos tres meses.
SELECT c.nombre, SUM(p.rental_rate) AS Ingresos
FROM categoria c
JOIN pelicula_categoria pc ON c.id = pc.id_categoria
JOIN pelicula p ON pc.id_pelicula = p.id
JOIN inventario i ON p.id = i.id_pelicula
JOIN alquiler a ON i.id = a.id_inventario
WHERE a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
GROUP BY c.id
ORDER BY Ingresos DESC LIMIT 5;

-- 19. Obtén la cantidad de películas alquiladas por cada idioma en el último mes.
SELECT i.nombre, COUNT(a.id) AS Alquileres
FROM idioma i
JOIN pelicula p ON i.id = p.id_idioma
JOIN inventario inv ON p.id = inv.id_pelicula
JOIN alquiler a ON inv.id = a.id_inventario
WHERE a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
GROUP BY i.id
ORDER BY Alquileres DESC;

-- 20. Lista los clientes que no han realizado ningún alquiler en el último año.
SELECT cl.nombre
FROM cliente cl
LEFT JOIN alquiler a ON cl.id = a.id_cliente
GROUP BY cl.id
HAVING COUNT(a.id) = 0 OR MAX(a.fecha_alquiler) < DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
ORDER BY cl.nombre;
