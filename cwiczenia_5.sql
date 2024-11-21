-- zad 1

CREATE TABLE objects (
	id SERIAL PRIMARY KEY,
	geometry GEOMETRY,
	name text
);

INSERT INTO objects(name, geometry) 
VALUES
('obiekt1', ST_Collect(ARRAY[
				ST_GeomFromText('LINESTRING(0 1, 1 1)'),
				ST_GeomFromText('CIRCULARSTRING(1 1, 2 0, 3 1)'),
				ST_GeomFromText('CIRCULARSTRING(3 1, 4  2, 5 1)'),
				ST_GeomFromText('LINESTRING(5 1, 6 1)')]
		         )
), 

('obiekt2', ST_Collect(ARRAY[
				ST_GeomFromText('LINESTRING(10 6, 14 6)'),
				ST_GeomFromText('CIRCULARSTRING(14 6, 16 4, 14 2, 12 0, 10 2)'),
				ST_GeomFromText('LINESTRING(10 2, 10 6)'),
				ST_GeomFromText('CIRCULARSTRING(11 2, 13 2, 11 2)')]
		        )
),

('obiekt3', ST_GeomFromText('POLYGON((10 17, 12 13, 7 15, 10 17))')
),

('obiekt4', ST_GeomFromText('LINESTRING(20 20, 25 25, 27 24, 25 22, 26 21, 22 19, 20.5 19.5)')
),

('obiekt5', ST_Collect(ARRAY[
				ST_GeomFromText('POINT(30 30 59)'),
				ST_GeomFromText('POINT(38 32 234)')]
				)
),
('obiekt6', ST_Collect(ARRAY[
				ST_GeomFromText('LINESTRING(1 1, 3 2)'),
				ST_GeomFromText('POINT(4 2)')]
				)
);

-- zad 2

SELECT ST_Area(ST_Buffer(ST_ShortestLine(x.geometry,y.geometry),5))
FROM objects as x
CROSS JOIN objects as y 
WHERE x.name = 'obiekt3' AND y.name = 'obiekt4';

-- zad 3

-- Warunek: Należy domknąć obszar

SELECT ST_MakePolygon(ST_AddPoint(geometry, 'POINT(20 20)'))
FROM objects
WHERE name = 'obiekt4'

-- zad 4

INSERT INTO objects(name, geometry)
SELECT 'obiekt7', ST_Collect(x.geometry, y.geometry)
FROM objects as x
INNER JOIN objects as y ON  x.name = 'obiekt3' AND y.name = 'obiekt4'

-- zad 5

WITH areas_no_arcs as (SELECT ST_Area(ST_Buffer(geometry,5)) as area FROM objects
WHERE NOT ST_HasArc(geometry))

SELECT SUM(area) FROM areas_no_arcs;