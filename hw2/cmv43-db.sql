CREATE SCHEMA Homework2;

--BELOW IS PART 1

--Clears the SQL doc
DROP TABLE IF EXISTS Homework2.forest CASCADE;
DROP TABLE IF EXISTS Homework2.COVERAGE CASCADE;
DROP TABLE IF EXISTS Homework2.intersection CASCADE;
DROP TABLE IF EXISTS Homework2.ROAD CASCADE;
DROP TABLE IF EXISTS Homework2.REPORT CASCADE;
DROP TABLE IF EXISTS Homework2.SENSOR CASCADE;
DROP TABLE IF EXISTS Homework2.State CASCADE;
DROP TABLE IF EXISTS Homework2.WORKER CASCADE;
DROP DOMAIN IF EXISTS energy_dom CASCADE;
DROP TABLE IF EXISTS Homework2.unique3;
DROP TABLE IF EXISTS Homework2.Unique2;
DROP TABLE IF EXISTS Homework2.coverage2;
DROP TABLE IF EXISTS Homework2.pairs;
DROP TABLE IF EXISTS Homework2.sensorReport;
DROP TABLE IF EXISTS Homework2.sensorReportForest;
DROP TABLE IF EXISTS Homework2.uniquePairs;

CREATE TABLE homework2.FOREST
(
    forest_no varchar(10) PRIMARY KEY,
    name varchar(30),
    area real,
    acid_level real,
    mbr_xmin real,
    mbr_xmax real,
    mbr_ymin real,
    mbr_ymax real
);

CREATE TABLE homework2.State
(
    name varchar(30),
    abbreviation varchar(2) PRIMARY KEY,
    area real,
    population integer
);

CREATE TABLE homework2.COVERAGE
(
    forest_no varchar(10),
    state varchar(2),
    percentage real,
    area real,
    PRIMARY KEY (forest_no, state),
    CONSTRAINT FK_forestNo FOREIGN KEY (forest_no) REFERENCES Homework2.FOREST(forest_no),
    CONSTRAINT FK_State FOREIGN KEY (state) REFERENCES Homework2.STATE(abbreviation)
    --CONSTRAINT --has 2 foreign keys
);


CREATE TABLE Homework2.ROAD
(
    road_no varchar(10) PRIMARY KEY,
    name varchar(30),
    length real
);

CREATE TABLE Homework2.INTERSECTION
(
    forest_no varchar(10),
    road_no varchar(10),
    CONSTRAINT FK_forestNo FOREIGN KEY (forest_no) REFERENCES Homework2.FOREST (forest_no),
    CONSTRAINT FK_roadNo FOREIGN KEY (road_no) REFERENCES Homework2.ROAD(road_no)
    --two primary keys are listed which is the super key. The table will default to using the super key so do not
    --need to declare two primary keys
);

CREATE TABLE Homework2.WORKER
(
    ssn varchar(9) PRIMARY KEY,
    name varchar(30),
    rank integer
);

CREATE TABLE Homework2.SENSOR
(
    sensor_id INTEGER PRIMARY KEY,
    x real,
    y real,
    last_charged timestamp,
    maintainer varchar(9),
    last_read timestamp,
    CONSTRAINT FK_maint FOREIGN KEY (maintainer) REFERENCES Homework2.WORKER(ssn)
);

CREATE TABLE Homework2.REPORT
(
    sensor_id integer,
    report_time timestamp,
    temperature real,
    CONSTRAINT FK_sensorID FOREIGN KEY (sensor_id) REFERENCES Homework2.SENSOR(sensor_id),
    PRIMARY KEY(sensor_id, report_time)
);

--BELOW IS PART 2

---- 2A ----------------------------------------------------------------------------------------------------------------
-- A) IN EACH TABLE IDENTIFY THE ALTERNATE KEYS AND ADD UNIQUE CONSTRAINTS TO THEM

--FOREST TABLE: name is an alternate key
ALTER TABLE Homework2.FOREST
ADD UNIQUE (name);

--STATE TABLE: name is an alternate key
ALTER TABLE Homework2.State
ADD UNIQUE (name);

--COVERAGE: forest_no and state together is an alternate key
--UPDATE: this was added as the primary key in the homework doc
--ALTER TABLE Homework2.COVERAGE
--ADD UNIQUE (forest_no, state);

--ROAD: name is an alternate key
ALTER TABLE Homework2.ROAD
ADD UNIQUE (name);

--INTERSECTION: forest_no and road_no together is an alternate key
ALTER TABLE Homework2.INTERSECTION
ADD UNIQUE(forest_no,road_no);
--ADD UNIQUE (forest_no), --not using
--ADD UNIQUE (road_no); --not using
--ALTER TABLE Homework2.INTERSECTION DROP CONSTRAINT intersection_forest_no_key; used to correct mistakes
--ALTER TABLE Homework2.INTERSECTION DROP CONSTRAINT intersection_road_no_key; used to correct mistakes

--SENSOR: (x,y) together is an alternate key
ALTER TABLE Homework2.SENSOR
ADD UNIQUE (x,y);

--REPORT: no alternate keys?

--WORKER: no alternate keys? multiple workers could have the same name
------------------------------------------------------------------------------------------------------------------------

---- 2B ----------------------------------------------------------------------------------------------------------------
-- B) add new attribute to SENSOR called energy. Energy is
--      an energy_dom that is an integer from 0-100 (representing a percentage of charge)

CREATE DOMAIN energy_dom AS INTEGER CHECK (value >= 0  AND value <= 100);

ALTER TABLE Homework2.SENSOR ADD energy energy_dom;
------------------------------------------------------------------------------------------------------------------------

---- 2C ----------------------------------------------------------------------------------------------------------------
-- C) In table forest, the acid_level should not be less than 0 and not greater 1
--      specify this constraint without using a domain

ALTER TABLE Homework2.forest ADD CONSTRAINT acid_level_constraint CHECK(acid_level >= 0 AND acid_level <= 1);
------------------------------------------------------------------------------------------------------------------------

---- 2D ----------------------------------------------------------------------------------------------------------------
-- D) add a new attribute, employing_state to Table Worker (varchar(2))
--      each worker should be employed in one state
--ADDING THE NEW ATTRIBUTE
ALTER TABLE Homework2.WORKER ADD employing_state varchar(2);
------------------------------------------------------------------------------------------------------------------------

--adding the constraint (making the employee ssn and the state unique)
ALTER TABLE Homework2.WORKER
ADD UNIQUE(ssn, employing_state);

-- BELOW IS PART 3 (adding the information)
-- A) populate the database with the information from the insert-statements provided
--SUCCESSFULLY INSERTED ALL DATA, HAD TO MODIFY THE DATA SLIGHTLY TO MAKE ACID_LEVEL THE LAST ATTRIBUTE LISTED
--ALSO HAD TO MODIFY A FEW OF THE UNIQUE CONSTRAINTS


---- 3B ----------------------------------------------------------------------------------------------------------------
-- B) insert a record into WORKER for Maria who is employed by ohio state
-- SSN is 123321456 rank is 3
INSERT INTO homework2.WORKER (ssn, name,  rank, employing_state) VALUES ('123321456','Maria',3,'OH');
------------------------------------------------------------------------------------------------------------------------

---- 3C ----------------------------------------------------------------------------------------------------------------
-- C) INSERTING 3 TUPLES THAT WILL VIOLATE CONSTRAINTS (types of violated constraints are given in the hw file)

--ONE TUPLE THAT VIOLATES PRIMARY KEY OR UNIQUE
--will attempt to add a worker with the same ssn as Maria (added above)
--INSERT INTO Homework2.WORKER (ssn, name, rank, employing_state) VALUES ('123321456','Christine', 2, 'NY');
--VIOLATES worker_pkey, which is good

--ONE TUPLE THAT VIOLATES A FOREIGN KEY
--will attempt to add to INTERSECTION a forest_no that doesnt exist in the FOREST table
--the inserted road_no will exist in the ROAD TABLE
--INSERT INTO Homework2.INTERSECTION (forest_no, road_no) VALUES(6, 1);
--VIOLATES fk_forestno, DETAIL: Key (forest_no)=(6) is not present in table "forest" (from error message I received)

--ONE TUPLE THAT VIOLATES A NOT NULL CONSTRAINT
--will attempt to add a worker with a null ssn
--INSERT INTO homework2.WORKER (ssn, name,  rank, employing_state) VALUES (null,'Damien',3,'NJ');
--ERROR: null value in column "ssn" of relation "worker" violates not-null constraint (error message I received)
------------------------------------------------------------------------------------------------------------------------


--PART 4 is below: EXPRESS THE FOLLOWING QUERIES IN SQL

---- 4A ----------------------------------------------------------------------------------------------------------------
-- A) list the names of all forests that have acid_level between 0.65 and 0.85 inclusive
SELECT name FROM Homework2.FOREST where (acid_level >= 0.65 AND acid_level <= 0.85);
--RETURNS PENNSYLVANIA FOREST, which is correct
------------------------------------------------------------------------------------------------------------------------

---- 4B ----------------------------------------------------------------------------------------------------------------
-- B) find the names of all roads in the forest whose name is "Allegheny National Forest"
--need to get the forest number from the FOREST table, plug that into the ROAD table to get the corresponding road_no
--  then plug that road_no into the ROAD table to get name
--SELECT forest_no INTO Homework2.FORESTNOTABLE from Homework2.FOREST where (name = 'Allegheny National Forest');
--creates a new table that just has the forest_no of Allegheny National Forest (which is just a table with the value 1)
--SELECT road_no INTO Homework2.ROADNOTABLE from Homework2.INTERSECTION join Homework2.FORESTNOTABLE ON Homework2.FORESTNOTABLE.forest_no = Homework2.INTERSECTION.forest_no;
--creates new table with 1,2,4,7 which is correct
--SELECT name FROM Homework2.ROAD join Homework2.ROADNOTABLE ON Homework2.ROAD.road_no = Homework2.ROADNOTABLE.road_no;
--Reurns Forbes, Bigelow, Grant, Beacon which is correct

--doing it with just a select statement
SELECT Homework2.road.name
FROM Homework2.road
    JOIN Homework2.INTERSECTION ON Homework2.road.road_no = Homework2.INTERSECTION.road_no
    JOIN Homework2.FOREST ON Homework2.INTERSECTION.forest_no = Homework2.FOREST.forest_no
WHERE Homework2.FOREST.name = 'Allegheny National Forest';

--THE BELOW COMMANDS CLEAR THE TABLES CREATED BY 4b
--DROP TABLE IF EXISTS Homework2.FORESTNOTABLE;
--DROP TABLE IF EXISTS Homework2.ROADNOTABLE;
------------------------------------------------------------------------------------------------------------------------

---- 4C -------------------------------------------------------------------------------------------------------
-- C) List all the sensors along with the name of the workers who maintain them.
-- The sensors without maintainers should also be listed.

--SELECT * INTO Homework2.SENSORANDWORKER from Homework2.SENSOR left join Homework2.WORKER ON Homework2.SENSOR.maintainer = Homework2.WORKER.ssn;
--this creates a table with the sensor corresponding to the name of the maintainer, it includes the sensor without a worker
--SELECT sensor_id, name FROM Homework2.SENSORANDWORKER;
--this returns the sensor_id and name of the worker from the SENSORANDWORKER TABLE, which is correct

--THE BELOW COMMAND CLEARS THE TABLE CREATED BY 4c
--Doing it with just a select statement

SELECT Homework2.sensor.sensor_id, Homework2.WORKER.name
FROM Homework2.sensor left join Homework2.worker ON Homework2.sensor.maintainer = Homework2.WORKER.ssn;
------------------------------------------------------------------------------------------------------------------------

-- CANT DO D-F YET
-- D)List the pairs of states that share at least one forest (i.e., cover parts of the same
-- forests). Each pair should be listed only once, e.g., if the tuple (PA, OH) is already
-- listed, then the tuple (OH, PA) should not be listed.
-- ideas on how to solve:
    -- use the coverage table
    -- states that share the same number in the forest_no column should be listed together
--making a copy of the coverage table

--SELECT Coverage1.state AS state1, Coverage2.state as state2,

SELECT DISTINCT
CASE when Coverage1.state > Coverage2.state then Coverage1.state else Coverage2.state end as state1,
CASE when Coverage1.state > Coverage2.state then Coverage2.state else Coverage1.state end as state2
FROM Homework2.COVERAGE Coverage1 join Homework2.COVERAGE Coverage2 ON Coverage1.forest_no = Coverage2.forest_no
where Coverage2.state <> Coverage1.state;




--wrong way is below
--SELECT * INTO Homework2.Coverage2 from Homework2.COVERAGE;

--below creates a table called pairs that share a forest (includes stuff like (pa, pa))
--SELECT Homework2.COVERAGE.state AS state1, Homework2.Coverage2.state AS state2 INTO Homework2.pairs from Homework2.coverage, Homework2.Coverage2 where Homework2.Coverage2.forest_no = Homework2.COVERAGE.forest_no;

--trim the above table to only include unique pairs
--SELECT Homework2.pairs.state1, Homework2.pairs.state2 into Homework2.uniquePairs from Homework2.pairs where Homework2.pairs.state1 != Homework2.pairs.state2;
--the above table doesn't include stuff like (pa, pa) but still includes stuff like (pa, oh) along with (oh, pa), and tuples can be repeated - (oh, pa) can exist more than once

--remove the repeat pairs
--SELECT DISTINCT * into Homework2.Unique2 from Homework2.uniquePairs;

--SELECT DISTINCT
              --  CASE when state1 > state2 then state1 else state2 end as state1,
                --case when state1 > state2 then state2 else state1 end as state2
--from Homework2.unique2;
--this returns 3 unique pairs

--clear the tables used for this question
DROP TABLE IF EXISTS Homework2.Unique3;
DROP TABLE IF EXISTS Homework2.pairs;
DROP TABLE IF EXISTS Homework2.unique2;
DROP TABLE IF EXISTS Homework2.uniquePairs;
DROP TABLE IF EXISTS Homework2.coverage2;

-- gonna come back to D

-------------------------------PART E --------------------------------------------------------------------------------
--For each forest, find its average temperature and number of sensors. Display the result
--in descending order of the average temperatures.
--start by combining the report and sensor tables
--SELECT * into Homework2.sensorReport from Homework2.SENSOR NATURAL JOIN Homework2.report WHERE Homework2.REPORT.sensor_id = Homework2.SENSOR.sensor_id;

--next combine the forest table with sensorReport based on the sensor locations being within the bounds of the forest
--SELECT * into Homework2.sensorReportForest from Homework2.sensorReport JOIN Homework2.FOREST ON Homework2.sensorReport.x > Homework2.FOREST.mbr_xmin AND Homework2.sensorReport.x < Homework2.FOREST.mbr_xmax AND Homework2.sensorReport.y > Homework2.FOREST.mbr_ymin AND Homework2.sensorReport.y < Homework2.FOREST.mbr_ymax;

--SELECT Homework2.sensorReportForest.name, Homework2.sensorReportForest.temperature, COUNT(*) noSensors from Homework2.sensorReportForest where Homework2.sensorReportForest.forest_no = '1' GROUP BY Homework2.sensorReportForest.name, Homework2.sensorReportForest.temperature;
--remove unnecessary info from that table

--SELECT Homework2.sensorReportForest.name as name, AVG(Homework2.sensorReportForest.temperature) AS AVG_Temp, COUNT(DISTINCT Homework2.sensorreportforest.sensor_id) as noSensors from Homework2.sensorReportForest GROUP BY Homework2.sensorReportForest.name;
--the above statement gives the answer

--below drops the extra tables made for this question
--DROP TABLE IF EXISTS Homework2.sensorreportforest;
--DROP TABLE IF EXISTS Homework2.sensorreport;

--Using just a select statement
SELECT Homework2.forest.name, AVG(Homework2.report.temperature), COUNT(DISTINCT Homework2.sensor.sensor_id)
FROM Homework2.forest JOIN Homework2.sensor ON Homework2.Sensor.x <= Homework2.forest.mbr_xmax AND Homework2.Sensor.x >= Homework2.forest.mbr_xmin AND Homework2.Sensor.y <= Homework2.forest.mbr_ymax AND Homework2.Sensor.y >= Homework2.forest.mbr_ymin
    JOIN Homework2.report ON Homework2.sensor.sensor_id = Homework2.REPORT.sensor_id
GROUP BY Homework2.forest.name;
--QUESTION 4 PART F --------------------------------------------------------------------------------------------
--List all the workers in the database along with the number of sensors they maintain.
--For sensors with no maintainers, find how many they are and associate them with ‘-NO
--MAINTAINER-’. The schema of the resulting table should be (sensor count, worker).

--this lists the sensor_count and the name
SELECT COUNT(*) as Sensor_count,
CASE
    when Homework2.sensor.maintainer IS NOT NULL THEN Homework2.worker.name
    WHEN name IS NULL THEN '-NO MAINTAINER-'
END as worker
FROM Homework2.sensor LEFT JOIN Homework2.worker ON Homework2.sensor.maintainer = Homework2.WORKER.ssn
GROUP BY Homework2.sensor.maintainer, Homework2.WORKER.name;
