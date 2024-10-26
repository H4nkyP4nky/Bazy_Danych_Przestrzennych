-- Zadanie 3
CREATE EXTENSION postgis;

-- Zadanie 4
CREATE TABLE buildings (
    id SERIAL PRIMARY KEY,
    geometry GEOMETRY,
    name VARCHAR(100)
);

CREATE TABLE roads (
    id SERIAL PRIMARY KEY,
    geometry GEOMETRY,
    name VARCHAR(100)
);

CREATE TABLE poi (
    id SERIAL PRIMARY KEY,
    geometry GEOMETRY,
    name VARCHAR(100)
);

-- Zadanie 5
INSERT INTO poi VALUES (1, ST_GeomFromText('POINT(1 3.5)'), 'G');
INSERT INTO poi VALUES (2, ST_GeomFromText('POINT(5.5 1.5)'), 'H');
INSERT INTO poi VALUES (3, ST_GeomFromText('POINT(9.5 6)'), 'I');
INSERT INTO poi VALUES (4, ST_GeomFromText('POINT(6.5 6)'), 'J');
INSERT INTO poi VALUES (5, ST_GeomFromText('POINT(6 9.5)'), 'K');

INSERT INTO roads VALUES (1, ST_GeomFromText('LINESTRING(0 4.5, 12 4.5)'), 'RoadX');
INSERT INTO roads VALUES (2, ST_GeomFromText('LINESTRING(7.5 0, 7.5 10.5)'), 'RoadY');

INSERT INTO buildings VALUES (1, ST_GeomFromText('POLYGON((8 4, 8 1.5, 10.5 1.5, 10.5 4, 8 4))'), 'BuildingA');
INSERT INTO buildings VALUES (2, ST_GeomFromText('POLYGON((4 7, 4 5, 6 5, 6 7, 4 7))'), 'BuildingB');
INSERT INTO buildings VALUES (3, ST_GeomFromText('POLYGON((3 8, 3 6, 5 6, 5 8, 3 8))'), 'BuildingC');
INSERT INTO buildings VALUES (4, ST_GeomFromText('POLYGON((9 9, 9 8, 10 8, 10 9, 9 9))'), 'BuildingD');
INSERT INTO buildings VALUES (5, ST_GeomFromText('POLYGON((1 2, 1 1, 2 1, 2 2, 1 2))'), 'BuildingF');

-- Zadanie 6

-- a
SELECT SUM(ST_Length(geometry)) AS total_length
FROM roads;

-- b
SELECT ST_AsText(geometry) AS wkt, ST_Area(geometry) AS area, ST_Perimeter(geometry) AS perimeter
FROM buildings
WHERE name = 'BuildingA';

-- c
SELECT name, ST_Area(geometry) AS area
FROM buildings
ORDER BY name;

-- d
SELECT name, ST_Perimeter(geometry) AS perimeter
FROM buildings
ORDER BY ST_Area(geometry) DESC
LIMIT 2;

-- e
SELECT ST_Distance(b.geometry, p.geometry)
FROM buildings b 
CROSS JOIN poi p
WHERE b.name='BuildingC' and p.name='K';

-- f
SELECT ST_Area(ST_Difference(bc.geometry, ST_Buffer(bb.geometry, 0.5))) AS area
FROM buildings bc, buildings bb
WHERE bc.name = 'BuildingC' AND bb.name = 'BuildingB';

-- g
SELECT b.*
FROM buildings b
JOIN roads r ON r.name = 'RoadX'
WHERE ST_Y(ST_Centroid(b.geometry)) > ST_Y(ST_Centroid(r.geometry));

-- h
SELECT ST_Area(ST_SymDifference(b.geometry, ST_GeomFromText('POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))'))) AS area
FROM buildings b
WHERE b.name = 'BuildingC';