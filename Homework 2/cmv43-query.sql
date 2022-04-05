-- Chris Votilla CMV43 and Shishir Timsina SHT99 --

-- Queries to display contents of each of the tables --
SELECT * FROM coverage;
SELECT * FROM forest;
SELECT * FROM intersection;
SELECT * FROM report;
SELECT * FROM road;
SELECT * FROM sensor;
SELECT * FROM state;
SELECT * FROM worker;

-- Question 4A --
SELECT name FROM FOREST where (acid_level >= 0.65 AND acid_level <= 0.85);

-- Question 4B --
SELECT road.name
FROM road
    JOIN INTERSECTION ON road.road_no = INTERSECTION.road_no
    JOIN FOREST ON INTERSECTION.forest_no = FOREST.forest_no
WHERE FOREST.name = 'Allegheny National Forest';

-- Question 4C --
SELECT sensor.sensor_id, WORKER.name
FROM sensor left join worker ON sensor.maintainer = WORKER.ssn;

-- Question 4D --
SELECT DISTINCT
CASE when Coverage1.state > Coverage2.state then Coverage1.state else Coverage2.state end as state1,
CASE when Coverage1.state > Coverage2.state then Coverage2.state else Coverage1.state end as state2
FROM COVERAGE Coverage1 join COVERAGE Coverage2 ON Coverage1.forest_no = Coverage2.forest_no
where Coverage2.state <> Coverage1.state;

-- Question 4E --
SELECT forest.name, AVG(report.temperature), COUNT(DISTINCT sensor.sensor_id)
FROM forest JOIN sensor ON Sensor.x <= forest.mbr_xmax AND Sensor.x >= forest.mbr_xmin AND Sensor.y <= forest.mbr_ymax AND Sensor.y >= forest.mbr_ymin
    JOIN report ON sensor.sensor_id = REPORT.sensor_id
GROUP BY forest.name;

-- Question 4F --
SELECT COUNT(*) as Sensor_count,
CASE
    when sensor.maintainer IS NOT NULL THEN worker.name
    WHEN name IS NULL THEN '-NO MAINTAINER-'
END as worker
FROM sensor LEFT JOIN worker ON sensor.maintainer = WORKER.ssn
GROUP BY sensor.maintainer, WORKER.name;