----CS1555/2055 - DATABASE MANAGEMENT SYSTEMS (FALL 2021)
----DEPT. OF COMPUTER SCIENCE, UNIVERSITY OF PITTSBURGH
----ASSIGNMENT #4 DB creation


---DROP DATABASE ELEMENTS TO MAKE SURE THE SCHEMA IS CLEAR (E.G., TABLES, DOMAINS, ETC.)
DROP TABLE IF EXISTS FOREST CASCADE;
DROP TABLE IF EXISTS STATE CASCADE;
DROP TABLE IF EXISTS COVERAGE CASCADE;
DROP TABLE IF EXISTS ROAD CASCADE;
DROP TABLE IF EXISTS INTERSECTION CASCADE;
DROP TABLE IF EXISTS WORKER CASCADE;
DROP TABLE IF EXISTS SENSOR CASCADE;
DROP TABLE IF EXISTS REPORT CASCADE;
DROP DOMAIN IF EXISTS energy_dom CASCADE ;

CREATE DOMAIN energy_dom AS integer CHECK (value >= 0 AND value <= 100);

CREATE TABLE FOREST (
    forest_no       varchar(10),
    name            varchar(30) NOT NULL,
    area            real NOT NULL,
    acid_level      real NOT NULL,
    mbr_xmin        real NOT NULL,
    mbr_xmax        real NOT NULL,
    mbr_ymin        real NOT NULL,
    mbr_ymax        real NOT NULL,
    CONSTRAINT FOREST_PK PRIMARY KEY (forest_no),
    CONSTRAINT FOREST_UN1 UNIQUE (name),
    CONSTRAINT FOREST_UN2 UNIQUE (mbr_xmin, mbr_xmax, mbr_ymin, mbr_ymax),
    CONSTRAINT FOREST_CH CHECK (acid_level >= 0 AND acid_level <= 1)
);


CREATE TABLE STATE (
    name            varchar(30) NOT NULL,
    abbreviation    varchar(2),
    area            real NOT NULL,
    population      integer NOT NULL,
    CONSTRAINT STATE_PK PRIMARY KEY (abbreviation),
    CONSTRAINT STATE_UN UNIQUE (name)
);


CREATE TABLE COVERAGE (
    forest_no       varchar(10),
    state           varchar(2),
    percentage      real NOT NULL,
    area            real NOT NULL,
    CONSTRAINT COVERAGE_PK PRIMARY KEY (forest_no, state),
    CONSTRAINT COVERAGE_FK1 FOREIGN KEY (forest_no) REFERENCES FOREST(forest_no),
    CONSTRAINT COVERAGE_FK2 FOREIGN KEY (state) REFERENCES STATE(abbreviation)
);


CREATE TABLE ROAD (
    road_no varchar(10),
    name    varchar(30) NOT NULL,
    length  real NOT NULL,
    CONSTRAINT ROAD_PK PRIMARY KEY (road_no)
);


CREATE TABLE INTERSECTION (
    forest_no varchar(10),
    road_no   varchar(10),
    CONSTRAINT INTERSECTION_PK PRIMARY KEY (forest_no, road_no),
    CONSTRAINT INTERSECTION_FK1 FOREIGN KEY (forest_no) REFERENCES FOREST(forest_no),
    CONSTRAINT INTERSECTION_FK2 FOREIGN KEY (road_no) REFERENCES ROAD(road_no)
  );


CREATE TABLE WORKER (
    ssn  varchar(9) ,
    name varchar(30) NOT NULL,
    rank integer NOT NULL,
    employing_state varchar(2) NOT NULL,
    CONSTRAINT WORKER_PK PRIMARY KEY (ssn),
    CONSTRAINT WORKER_UN UNIQUE (name),
    CONSTRAINT WORKER_FK FOREIGN KEY (employing_state) REFERENCES STATE(abbreviation)
);


CREATE TABLE SENSOR
  (
    sensor_id integer,
    x real NOT NULL,
    y real NOT NULL,
    last_charged timestamp NOT NULL,
    maintainer   varchar(9) DEFAULT NULL,
    last_read    timestamp NOT NULL,
    energy energy_dom NOT NULL,
    CONSTRAINT SENSOR_PK PRIMARY KEY (sensor_id),
    CONSTRAINT SENSOR_FK FOREIGN KEY (maintainer) REFERENCES WORKER(ssn),
    CONSTRAINT SENSOR_UN2 UNIQUE (x, y)
);

CREATE TABLE REPORT (
    sensor_id integer,
    report_time timestamp NOT NULL,
    temperature real NOT NULL,
    CONSTRAINT REPORT_PK PRIMARY KEY (sensor_id, report_time),
    CONSTRAINT REPORT_FK FOREIGN KEY (sensor_id) REFERENCES SENSOR(sensor_id)
);


--PART 1, ALTERING TABLES TO HAVE CONSTRAINTS ON FOREIGN AND PRIMARY KEYS
ALTER TABLE FOREST
    ADD CONSTRAINT FOREST_uq_name
    UNIQUE (name) DEFERRABLE INITIALLY DEFERRED ;
ALTER TABLE FOREST
    ADD CONSTRAINT FOREST_uq_ar
    UNIQUE (mbr_xmin, mbr_xmax, mbr_ymin, mbr_ymax) DEFERRABLE  INITIALLY DEFERRED ;

AlTER TABLE STATE
    ADD constraint STATE_uq_name
    UNIQUE (name) DEFERRABLE INITIALLY DEFERRED ;

ALTER TABLE coverage
    ADD CONSTRAINT COVERAGE_fk_no
    FOREIGN KEY(forest_no) references  FOREST (forest_no) DEFERRABLE INITIALLY IMMEDIATE;
ALTER  TABLE coverage
    ADD CONSTRAINT COVERAGE_fk_state
    FOREIGN KEY (state) references STATE (abbreviation) DEFERRABLE  INITIALLY  IMMEDIATE ;

ALTER TABLE INTERSECTION
    ADD CONSTRAINT INTERSECTION_fk_no
    FOREIGN KEY (forest_no) references FOREST(forest_no) DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE INTERSECTION
    ADD CONSTRAINT INTERSECTION_fk_road
    FOREIGN KEY (road_no) references ROAD(road_no) DEFERRABLE INITIALLY IMMEDIATE ;

ALTER TABLE WORKER
    ADD CONSTRAINT WORKER_uq_name
    UNIQUE (name) DEFERRABLE INITIALLY DEFERRED ;
ALTER  TABLE WORKER
    ADD CONSTRAINT WORKER_fk_state
    FOREIGN KEY (employing_state) references STATE(abbreviation) DEFERRABLE INITIALLY IMMEDIATE ;

ALTER TABLE SENSOR
    ADD CONSTRAINT SENSOR_fk_maintainer
    FOREIGN KEY (maintainer) references WORKER(ssn) DEFERRABLE INITIALLY IMMEDIATE ;
ALTER TABLE SENSOR
    ADD CONSTRAINT SENSOR_uq_xy
    UNIQUE (x,y) DEFERRABLE INITIALLY DEFERRED ;

ALTER TABLE REPORT
    ADD CONSTRAINT REPORT_fk_sensor_id
    FOREIGN KEY (sensor_id) references SENSOR(sensor_id) DEFERRABLE INITIALLY IMMEDIATE ;

--2a add new road, update intersection
INSERT INTO ROAD
    VALUES (105, 'Route Five', 426);
INSERT INTO INTERSECTION
    VALUES (1,105);

--2b switch john and jason's sensors
UPDATE SENSOR
    SET maintainer = (CASE WHEN maintainer = '121212121' THEN '123456789'
        WHEN maintainer = '123456789' THEN '121212121' ELSE maintainer END);

--2c add natalia to worker, update sensor 2 to maintained by natalia
BEGIN;
INSERT INTO WORKER
    VALUES ('105588973', 'Natalia',1,'OH');
UPDATE SENSOR
    SET maintainer = (CASE WHEN sensor_id = 2 THEN '105588973' ELSE maintainer END);
COMMIT ;

--# PART 3
--3a 3 most active sensors (highest number of reports) (7,11,12 answers)
SELECT sensor_id
FROM (SELECT sensor_id, COUNT(*)
    from REPORT
    group by sensor_id
    order by count DESC) as foo
LIMIT 3;

--3b find next 2 most active sensors, after the top 3
--(3,8 is answer)
SELECT sensor_id
FROM (SELECT sensor_id,COUNT(*)
    from REPORT
    group by sensor_id
    order by count DESC) as foo
LIMIT 2 OFFSET 3;

--3c states that have higher area of forests than PA, COVERAGE table,
SELECT state
FROM (SELECT state, SUM(area) as areaSum FROM COVERAGE group by state) as eachArea
where areaSum > (
    SELECT SUM(area) as sumAREA
    FROM coverage
    Where state = 'PA'
    group by state);


--3d names of all roads that cross "Stone Valley" forest
-- Bayard and Carson
SELECT R.name
FROM((FOREST F JOIN INTERSECTION I on F.forest_no = I.forest_no)
    JOIN ROAD R ON R.road_no = I.road_no)
WHERE F.name = 'Stone Valley';

--3e ssn,name,rank of workers who must replace a sensor battery
--Mike, Jason, Tim
SELECT DISTINCT ssn,name,rank
FROM WORKER as W
    JOIN SENSOR S on W.ssn = S.maintainer
WHERE S.energy <= 2;

--3f "endangered" forests in PA, acid > 60
SELECT DISTINCT name
FROM FOREST as F
    join COVERAGE C on F.forest_no = C.forest_no
WHERE C.state = 'PA' AND f.acid_level > 0.6;

--3g names of all forests that share forest "Big Woods" all its roads, wtf
--grant carson, Greatview, GET PENNFOREST
SELECT name
FROM FOREST JOIN INTERSECTION I2 on FOREST.forest_no = I2.forest_no
WHERE I2.road_no = all (
    SELECT I.road_no
    FROM FORESt JOIN INTERSECTION I on FOREST.forest_no = I.forest_no
    Where name = 'Big Woods'
    );


SELECT DISTINCT i.forest_no, i.road_no
FROM INTERSECTION as i
    JOIN
    (SELECT name, road_no
    FROM FOREST JOIN INTERSECTION I on FOREST.forest_no = I.forest_no
    WHERE name = 'Big Woods') bs
ON  i.road_no = bs.road_no;


SELECT DISTINCT fs.name , fs.sensor_id
FROM FOREST_SENSOR as fs
    JOIN
    (SELECT sensor_id
    FROM FOREST_SENSOR
    WHERE name = 'Big Woods') bs
ON fs.sensor_id = bs.sensor_id
Where fs.name <> 'Big Woods';


select DISTINCT  name, sensor_id
from FOREST_SENSOR
Where name <> 'Big Woods'
INTERSECT
    SELECT  name, sensor_id
    FROM FOREST_SENSOR
    WHERE sensor_id in(
    SELECT sensor_id
    FROM FOREST_SENSOR
    WHERE name = 'Big Woods'
    );


--3h display week number (1,2,3...13) from sep 1 to nov 30, and average temp reported by all sensors that week.
--sort in desc order
SELECT AVG(temperature)
from report
where report_time between '2020-09-01'  and '2020-09-07 23:59';





--# PART 4
-- 4a create view DUTIES, that counts number of sensors that maintained by each worker.
--DROP VIEW DUTIES;
CREATE VIEW DUTIES AS
    SELECT maintainer, count(*)
    FROM SENSOR
    group by maintainer
    order by count DESC;

--4b create materialized view from DUTIES
CREATE MATERIALIZED VIEW DUTIES_MV AS
    SELECT * FROM DUTIES;

--4c create view with all forests and each of their sensors, not completely done
CREATE VIEW FOREST_SENSOR AS
    SELECT DISTINCT forest_no, name, sensor_id
    FROM FOREST f
        JOIN SENSOR S on S.x BETWEEN F.mbr_xmin AND F.mbr_xmax AND S.y BETWEEN F.mbr_ymin AND F.mbr_ymax
    GROUP BY forest_no, name, sensor_id;

--4d create view that lists number of roads intersecting each forest
CREATE VIEW FOREST_ROAD AS
    SELECT name, count(*)
        FROM (FOREST f JOIN INTERSECTION I on f.forest_no = I.forest_no)
        group by name;


--# PART 5
REFRESH MATERIALIZED VIEW DUTIES_MV;


SELECT DISTINCT name
FROM FOREST_SENSOR
WHere name NOT IN (
SELECT name
FROM forest_sensor JOIN report r on FOREST_SENSOR.sensor_id = r.sensor_id
Where report_time >= '2020-10-10' AND report_time <= '2020-10-11');

SELECT DISTINCT name, sensor_id
FROM FOREST_SENSOR
WHERE sensor_id in(
    SELECT sensor_id
    FROM FOREST_SENSOR
    WHERE name = 'Big Woods'
    )
AND name <> 'Big Woods';

select DISTINCT  name, sensor_id
from FOREST_SENSOR
Where name <> 'Big Woods'
INTERSECT
    SELECT  name, sensor_id
    FROM FOREST_SENSOR
    WHERE sensor_id in(
    SELECT sensor_id
    FROM FOREST_SENSOR
    WHERE name = 'Big Woods'
    );

SELECT DISTINCT fs.name , fs.sensor_id
FROM FOREST_SENSOR as fs
    JOIN
    (SELECT sensor_id
    FROM FOREST_SENSOR
    WHERE name = 'Big Woods') bs
ON fs.sensor_id = bs.sensor_id
Where fs.name <> 'Big Woods';

