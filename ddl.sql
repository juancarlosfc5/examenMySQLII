-- DATABASE Sakila Campus

DROP DATABASE IF EXISTS sakilacampus;

CREATE DATABASE sakilacampus;
USE sakilacampus;

-- 1
CREATE TABLE IF NOT EXISTS film_text (
    id SMALLINT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255),
    description TEXT
);

-- 2
CREATE TABLE IF NOT EXISTS idioma (
    id TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    nombre CHAR(20),
    ultima_actualizacion TIMESTAMP
);

-- 3
CREATE TABLE IF NOT EXISTS categoria (
    id TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(25),
    ultima_actualizacion TIMESTAMP
);

-- 4
CREATE TABLE IF NOT EXISTS actor (
    id SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(45),
    apellidos VARCHAR(45),
    ultima_actualizacion TIMESTAMP
);

-- 5
CREATE TABLE IF NOT EXISTS pais (
    id SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50),
    ultima_actualizacion TIMESTAMP
);

-- 6
CREATE TABLE IF NOT EXISTS ciudad (
    id SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50),
    id_pais SMALLINT UNSIGNED,
    ultima_actualizacion TIMESTAMP,
    FOREIGN KEY (id_pais) REFERENCES pais(id)ON DELETE CASCADE
);

-- 7
CREATE TABLE IF NOT EXISTS direccion (
    id SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    direccion VARCHAR(50),
    direccion2 VARCHAR(50),
    distrito VARCHAR(20),
    id_ciudad SMALLINT UNSIGNED,
    codigo_postal VARCHAR(10),
    telefono VARCHAR(20),
    ultima_actualizacion TIMESTAMP,
    FOREIGN KEY (id_ciudad) REFERENCES ciudad(id)ON DELETE CASCADE
);

-- 8
CREATE TABLE IF NOT EXISTS pelicula (
    id SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(255),
    description TEXT,
    anyo_lanzamiento YEAR,
    id_idioma TINYINT UNSIGNED,
    id_idioma_original TINYINT UNSIGNED,
    duracion_alquiler TINYINT UNSIGNED,
    rental_rate DECIMAL(4,2),
    duracion SMALLINT UNSIGNED,
    replacement_cost DECIMAL(5,2),
    clasificacion ENUM('G','PG','PG-13','R','NC-17'),
    caracteristicas_especiales SET('Trailers','Commentaries','Deleted Scenes','Behind the Scenes'),
    ultima_actualizacion TIMESTAMP,
    FOREIGN KEY (id_idioma) REFERENCES idioma(id)ON DELETE CASCADE,
    FOREIGN KEY (id_idioma_original) REFERENCES idioma(id)ON DELETE CASCADE
);

-- 9
CREATE TABLE IF NOT EXISTS pelicula_categoria (
    id_pelicula SMALLINT UNSIGNED,
    id_categoria TINYINT UNSIGNED,
    ultima_actualizacion TIMESTAMP,
    FOREIGN KEY (id_pelicula) REFERENCES pelicula(id)ON DELETE CASCADE,
    FOREIGN KEY (id_categoria) REFERENCES categoria(id)ON DELETE CASCADE
);

-- 10
CREATE TABLE IF NOT EXISTS pelicula_actor (
    id_actor SMALLINT UNSIGNED,
    id_pelicula SMALLINT UNSIGNED,
    ultima_actualizacion TIMESTAMP,
    FOREIGN KEY (id_actor) REFERENCES actor(id)ON DELETE CASCADE,
    FOREIGN KEY (id_pelicula) REFERENCES pelicula(id)ON DELETE CASCADE
);

-- 11
CREATE TABLE IF NOT EXISTS almacen (
    id TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    id_direccion SMALLINT UNSIGNED,
    ultima_actualizacion TIMESTAMP,
    id_empleado_jefe TINYINT UNSIGNED,
    FOREIGN KEY (id_direccion) REFERENCES direccion(id)ON DELETE CASCADE
);

-- 12
CREATE TABLE IF NOT EXISTS cliente (
    id SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    id_almacen TINYINT UNSIGNED,
    nombre VARCHAR(45),
    apellidos VARCHAR(45),
    email VARCHAR(50),
    id_direccion SMALLINT UNSIGNED,
    activo TINYINT(1),
    fecha_creacion DATETIME,
    ultima_actualizacion TIMESTAMP,
    FOREIGN KEY (id_almacen) REFERENCES almacen(id)ON DELETE CASCADE,
    FOREIGN KEY (id_direccion) REFERENCES direccion(id)ON DELETE CASCADE
);

-- 13
CREATE TABLE IF NOT EXISTS inventario (
    id MEDIUMINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    id_pelicula SMALLINT UNSIGNED,
    id_almacen TINYINT UNSIGNED,
    ultima_actualizacion TIMESTAMP,
    FOREIGN KEY (id_pelicula) REFERENCES pelicula(id)ON DELETE CASCADE,
    FOREIGN KEY (id_almacen) REFERENCES almacen(id)ON DELETE CASCADE
);

-- 14
CREATE TABLE IF NOT EXISTS empleado (
    id TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(45),
    apellidos VARCHAR(45),
    id_direccion SMALLINT UNSIGNED,
    imagen blob,
    email VARCHAR(50),
    id_almacen TINYINT UNSIGNED,
    activo TINYINT(1),
    username VARCHAR(16),
    password VARCHAR(40),
    ultima_actualizacion TIMESTAMP,
    FOREIGN KEY (id_direccion) REFERENCES direccion(id)ON DELETE CASCADE,
    FOREIGN KEY (id_almacen) REFERENCES almacen(id)ON DELETE CASCADE
);

-- ALTER TABLE incluyendo id de empleado en almacen como llave foranea
DESC almacen;
ALTER TABLE almacen ADD CONSTRAINT FOREIGN KEY (id_empleado_jefe) REFERENCES empleado(id) ON DELETE CASCADE;

-- 15
CREATE TABLE IF NOT EXISTS alquiler (
    id INT PRIMARY KEY AUTO_INCREMENT,
    fecha_alquiler DATETIME,
    id_inventario MEDIUMINT UNSIGNED,
    id_cliente SMALLINT UNSIGNED,
    fecha_devolucion DATETIME,
    id_empleado TINYINT UNSIGNED,
    ultima_actualizacion TIMESTAMP,
    FOREIGN KEY (id_inventario) REFERENCES inventario(id)ON DELETE CASCADE,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id)ON DELETE CASCADE,
    FOREIGN KEY (id_empleado) REFERENCES empleado(id)ON DELETE CASCADE
);

-- 16
CREATE TABLE IF NOT EXISTS pago (
    id SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    id_cliente SMALLINT UNSIGNED,
    id_empleado TINYINT UNSIGNED,
    id_alquiler INT,
    total DECIMAL(5,2),
    fecha_pago DATETIME,
    ultima_actualizacion TIMESTAMP,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id)ON DELETE CASCADE,
    FOREIGN KEY (id_empleado) REFERENCES empleado(id)ON DELETE CASCADE,
    FOREIGN KEY (id_alquiler) REFERENCES alquiler(id)ON DELETE CASCADE
);

SHOW TABLES;
DESC almacen;
