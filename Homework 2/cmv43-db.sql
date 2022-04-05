
-- Chris Votilla CMV43 and Shishir Timsina SHT99 --
-- Homework 2 --

--Clears the SQL doc
DROP TABLE IF EXISTS forest CASCADE;
DROP TABLE IF EXISTS COVERAGE CASCADE;
DROP TABLE IF EXISTS intersection CASCADE;
DROP TABLE IF EXISTS ROAD CASCADE;
DROP TABLE IF EXISTS REPORT CASCADE;
DROP TABLE IF EXISTS SENSOR CASCADE;
DROP TABLE IF EXISTS State CASCADE;
DROP TABLE IF EXISTS WORKER CASCADE;
DROP DOMAIN IF EXISTS energy_dom CASCADE;

CREATE TABLE FOREST
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

CREATE TABLE State
(
    name varchar(30),
    abbreviation varchar(2) PRIMARY KEY,
    area real,
    population integer
);

CREATE TABLE COVERAGE
(
    forest_no varchar(10),
    state varchar(2),
    percentage real,
    area real,
    PRIMARY KEY (forest_no, state),
    CONSTRAINT FK_forestNo FOREIGN KEY (forest_no) REFERENCES FOREST(forest_no),
    CONSTRAINT FK_State FOREIGN KEY (state) REFERENCES STATE(abbreviation)
    --CONSTRAINT --has 2 foreign keys
);


CREATE TABLE ROAD
(
    road_no varchar(10) PRIMARY KEY,
    name varchar(30),
    length real
);

CREATE TABLE INTERSECTION
(
    forest_no varchar(10),
    road_no varchar(10),
    CONSTRAINT FK_forestNo FOREIGN KEY (forest_no) REFERENCES FOREST (forest_no),
    CONSTRAINT FK_roadNo FOREIGN KEY (road_no) REFERENCES ROAD(road_no)
    --two primary keys are listed which is the super key. The table will default to using the super key so do not
    --need to declare two primary keys
);

CREATE TABLE WORKER
(
    ssn varchar(9) PRIMARY KEY,
    name varchar(30),
    rank integer
);

CREATE TABLE SENSOR
(
    sensor_id INTEGER PRIMARY KEY,
    x real,
    y real,
    last_charged timestamp,
    maintainer varchar(9),
    last_read timestamp,
    CONSTRAINT FK_maint FOREIGN KEY (maintainer) REFERENCES WORKER(ssn)
);

CREATE TABLE REPORT
(
    sensor_id integer,
    report_time timestamp,
    temperature real,
    CONSTRAINT FK_sensorID FOREIGN KEY (sensor_id) REFERENCES SENSOR(sensor_id),
    PRIMARY KEY(sensor_id, report_time)
);

--BELOW IS PART 2

---- 2A ----------------------------------------------------------------------------------------------------------------
-- A) IN EACH TABLE IDENTIFY THE ALTERNATE KEYS AND ADD UNIQUE CONSTRAINTS TO THEM

--FOREST TABLE: name is an alternate key
ALTER TABLE FOREST
ADD UNIQUE (name);

--STATE TABLE: name is an alternate key
ALTER TABLE State
ADD UNIQUE (name);

--COVERAGE: forest_no and state together is an alternate key
--UPDATE: this was added as the primary key in the homework doc
--ALTER TABLE COVERAGE
--ADD UNIQUE (forest_no, state);

--ROAD: name is an alternate key
ALTER TABLE ROAD
ADD UNIQUE (name);

--INTERSECTION: forest_no and road_no together is an alternate key
ALTER TABLE INTERSECTION
ADD UNIQUE(forest_no,road_no);
--ADD UNIQUE (forest_no), --not using
--ADD UNIQUE (road_no); --not using


--SENSOR: (x,y) together is an alternate key
ALTER TABLE SENSOR
ADD UNIQUE (x,y);

--REPORT: no alternate keys?

--WORKER: no alternate keys? multiple workers could have the same name
------------------------------------------------------------------------------------------------------------------------

---- 2B ----------------------------------------------------------------------------------------------------------------
-- B) add new attribute to SENSOR called energy. Energy is
--      an energy_dom that is an integer from 0-100 (representing a percentage of charge)

CREATE DOMAIN energy_dom AS INTEGER CHECK (value >= 0  AND value <= 100);

ALTER TABLE SENSOR ADD energy energy_dom;
------------------------------------------------------------------------------------------------------------------------

---- 2C ----------------------------------------------------------------------------------------------------------------
-- C) In table forest, the acid_level should not be less than 0 and not greater 1
--      specify this constraint without using a domain

ALTER TABLE forest ADD CONSTRAINT acid_level_constraint CHECK(acid_level >= 0 AND acid_level <= 1);
------------------------------------------------------------------------------------------------------------------------

---- 2D ----------------------------------------------------------------------------------------------------------------
-- D) add a new attribute, employing_state to Table Worker (varchar(2))
--      each worker should be employed in one state
--ADDING THE NEW ATTRIBUTE
ALTER TABLE WORKER ADD employing_state varchar(2);
------------------------------------------------------------------------------------------------------------------------

--adding the constraint (making the employee ssn and the state unique)
ALTER TABLE WORKER
ADD UNIQUE(ssn, employing_state);

-- BELOW IS PART 3 (adding the information)
-- A) populate the database with the information from the insert-statements provided

---- 3B ----------------------------------------------------------------------------------------------------------------
-- B) insert a record into WORKER for Maria who is employed by ohio state
-- SSN is 123321456 rank is 3
INSERT INTO WORKER (ssn, name,  rank, employing_state) VALUES ('123321456','Maria',3,'OH');
------------------------------------------------------------------------------------------------------------------------

---- 3C ----------------------------------------------------------------------------------------------------------------
-- C) INSERTING 3 TUPLES THAT WILL VIOLATE CONSTRAINTS (types of violated constraints are given in the hw file)

--ONE TUPLE THAT VIOLATES PRIMARY KEY OR UNIQUE
--will attempt to add a worker with the same ssn as Maria (added above)
--INSERT INTO WORKER (ssn, name, rank, employing_state) VALUES ('123321456','Christine', 2, 'NY');
--VIOLATES worker_pkey, which is good

--ONE TUPLE THAT VIOLATES A FOREIGN KEY
--will attempt to add to INTERSECTION a forest_no that doesnt exist in the FOREST table
--the inserted road_no will exist in the ROAD TABLE
--INSERT INTO INTERSECTION (forest_no, road_no) VALUES(6, 1);
--VIOLATES fk_forestno, DETAIL: Key (forest_no)=(6) is not present in table "forest" (from error message I received)

--ONE TUPLE THAT VIOLATES A NOT NULL CONSTRAINT
--will attempt to add a worker with a null ssn
--INSERT INTO WORKER (ssn, name,  rank, employing_state) VALUES (null,'Damien',3,'NJ');
--ERROR: null value in column "ssn" of relation "worker" violates not-null constraint (error message I received)
------------------------------------------------------------------------------------------------------------------------