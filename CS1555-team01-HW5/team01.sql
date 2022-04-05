-- CS1555 Homework 5
-- Timsina Shishir SHT99
-- Chris Votilla CMV43
DROP TABLE IF EXISTS FOREST CASCADE;
DROP TABLE IF EXISTS STATE CASCADE;
DROP TABLE IF EXISTS COVERAGE CASCADE;
DROP TABLE IF EXISTS ROAD CASCADE;
DROP TABLE IF EXISTS INTERSECTION CASCADE;
DROP TABLE IF EXISTS WORKER CASCADE;
DROP TABLE IF EXISTS SENSOR CASCADE;
DROP TABLE IF EXISTS REPORT CASCADE;
DROP TABLE IF EXISTS EMERGENCY CASCADE;
DROP DOMAIN IF EXISTS energy_dom CASCADE ;
DROP PROCEDURE IF EXISTS incrementSensorCount_proc CASCADE;
DROP FUNCTION IF EXISTS computePercentage CASCADE;
DROP TRIGGER IF EXISTS sensorCount_tri ON SENSOR CASCADE;
DROP FUNCTION IF EXISTS sensorCount_func CASCADE;
DROP FUNCTION IF EXISTS percentage_func CASCADE;
DROP FUNCTION IF EXISTS emergency_func CASCADE;
DROP TRIGGER IF EXISTS emergency_tri ON REPORT CASCADE;
DROP FUNCTION IF EXISTS enforceMaintainer_func CASCADE;
DROP TRIGGER IF EXISTS enforceMaintainer_tri on SENSOR CASCADE;

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
    sensor_count    integer DEFAULT 0,
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

CREATE TABLE EMERGENCY (
    sensor_id integer,
    report_time timestamp NOT NULL,
    CONSTRAINT EMERGENCY_PK PRIMARY KEY (sensor_id, report_time) NOT DEFERRABLE,
    CONSTRAINT EMERGENCY_FK FOREIGN KEY (sensor_id, report_time) REFERENCES REPORT(SENSOR_ID, REPORT_TIME) DEFERRABLE INITIALLY IMMEDIATE
);

-- drop the original constraints and replace them with the new ones

--FOREST----------------------------------------------------------------------------------------------------------------
ALTER TABLE FOREST
    DROP CONSTRAINT IF EXISTS FOREST_PK CASCADE;
ALTER TABLE FOREST
    ADD CONSTRAINT FOREST_PK PRIMARY KEY (forest_no) NOT DEFERRABLE;

ALTER TABLE FOREST
    DROP CONSTRAINT IF EXISTS FOREST_UN1;
ALTER TABLE FOREST
    ADD CONSTRAINT FOREST_UN1
    UNIQUE (name) DEFERRABLE INITIALLY DEFERRED ;

ALTER TABLE FOREST
    DROP CONSTRAINT IF EXISTS FOREST_UN2;
ALTER TABLE FOREST
    ADD CONSTRAINT FOREST_UN2
    UNIQUE (mbr_xmin, mbr_xmax, mbr_ymin, mbr_ymax) DEFERRABLE  INITIALLY DEFERRED ;
------------------------------------------------------------------------------------------------------------------------

--STATE-----------------------------------------------------------------------------------------------------------------
ALTER TABLE STATE
    DROP CONSTRAINT IF EXISTS STATE_PK CASCADE;
ALTER TABLE STATE
    ADD CONSTRAINT STATE_PK
    PRIMARY KEY(abbreviation) NOT DEFERRABLE;

ALTER TABLE STATE
    DROP CONSTRAINT IF EXISTS STATE_UN;
AlTER TABLE STATE
    ADD constraint STATE_UN
    UNIQUE (name) DEFERRABLE INITIALLY DEFERRED ;
------------------------------------------------------------------------------------------------------------------------

--COVERAGE--------------------------------------------------------------------------------------------------------------
ALTER TABLE COVERAGE
    DROP CONSTRAINT IF EXISTS COVERAGE_PK CASCADE;
ALTER TABLE COVERAGE
    ADD CONSTRAINT COVERAGE_PK
    PRIMARY KEY(forest_no, state) NOT DEFERRABLE;

ALTER TABLE COVERAGE
    DROP CONSTRAINT IF EXISTS COVERAGE_FK1;
ALTER TABLE coverage
    ADD CONSTRAINT COVERAGE_FK1
    FOREIGN KEY(forest_no) references  FOREST (forest_no) DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE COVERAGE
    DROP CONSTRAINT IF EXISTS COVERAGE_FK2;
ALTER  TABLE coverage
    ADD CONSTRAINT COVERAGE_FK2
    FOREIGN KEY (state) references STATE (abbreviation) DEFERRABLE  INITIALLY  IMMEDIATE;
------------------------------------------------------------------------------------------------------------------------

--ROAD------------------------------------------------------------------------------------------------------------------
ALTER TABLE ROAD
    DROP CONSTRAINT IF EXISTS ROAD_PK CASCADE;
ALTER TABLE ROAD
    ADD CONSTRAINT ROAD_PK PRIMARY KEY(road_no) NOT DEFERRABLE;
------------------------------------------------------------------------------------------------------------------------

--INTERSECTION----------------------------------------------------------------------------------------------------------
ALTER TABLE INTERSECTION
    DROP CONSTRAINT IF EXISTS INTERSECTION_PK CASCADE;
ALTER TABLE INTERSECTION
    ADD CONSTRAINT INTERSECTION_PK
    PRIMARY KEY(forest_no, road_no) NOT DEFERRABLE ;

ALTER TABLE INTERSECTION
    DROP CONSTRAINT IF EXISTS INTERSECTION_FK1;
ALTER TABLE INTERSECTION
    ADD CONSTRAINT INTERSECTION_FK1
    FOREIGN KEY (forest_no) references FOREST(forest_no) DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE INTERSECTION
    DROP CONSTRAINT IF EXISTS INTERSECTION_FK2;
ALTER TABLE INTERSECTION
    ADD CONSTRAINT INTERSECTION_FK2
    FOREIGN KEY (road_no) references ROAD(road_no) DEFERRABLE INITIALLY IMMEDIATE ;
------------------------------------------------------------------------------------------------------------------------

--WORKER----------------------------------------------------------------------------------------------------------------
ALTER TABLE WORKER
    DROP CONSTRAINT IF EXISTS WORKER_PK CASCADE;
ALTER TABLE WORKER
    ADD CONSTRAINT WORKER_PK
    PRIMARY KEY(ssn) NOT DEFERRABLE;

ALTER TABLE WORKER
    DROP CONSTRAINT IF EXISTS WORKER_UN;
ALTER TABLE WORKER
    ADD CONSTRAINT WORKER_UN
    UNIQUE (name) DEFERRABLE INITIALLY DEFERRED ;

ALTER TABLE WORKER
    DROP CONSTRAINT IF EXISTS WORKER_FK;
ALTER  TABLE WORKER
    ADD CONSTRAINT WORKER_FK
    FOREIGN KEY (employing_state) references STATE(abbreviation) DEFERRABLE INITIALLY IMMEDIATE ;
------------------------------------------------------------------------------------------------------------------------

--SENSOR----------------------------------------------------------------------------------------------------------------
ALTER TABLE SENSOR
    DROP CONSTRAINT IF EXISTS SENSOR_PK CASCADE;
ALTER TABLE SENSOR
    ADD CONSTRAINT SENSOR_PK
    PRIMARY KEY(sensor_id) NOT DEFERRABLE;

ALTER TABLE SENSOR
    DROP CONSTRAINT IF EXISTS SENSOR_FK;
ALTER TABLE SENSOR
    ADD CONSTRAINT SENSOR_FK
    FOREIGN KEY (maintainer) references WORKER(ssn) DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE SENSOR
    DROP CONSTRAINT IF EXISTS SENSOR_UN2;
ALTER TABLE SENSOR
    ADD CONSTRAINT SENSOR_UN2
    UNIQUE (x,y) DEFERRABLE INITIALLY DEFERRED ;
------------------------------------------------------------------------------------------------------------------------

--REPORT----------------------------------------------------------------------------------------------------------------
ALTER TABLE REPORT
    DROP CONSTRAINT IF EXISTS REPORT_PK CASCADE;
ALTER TABLE REPORT
    ADD CONSTRAINT REPORT_PK
    PRIMARY KEY (sensor_id, report_time) NOT DEFERRABLE;

ALTER TABLE REPORT
    DROP CONSTRAINT IF EXISTS REPORT_FK;
ALTER TABLE REPORT
    ADD CONSTRAINT REPORT_FK
    FOREIGN KEY (sensor_id) references SENSOR(sensor_id) DEFERRABLE INITIALLY IMMEDIATE ;

-- START OF NEW FUNCTIONS/TRIGGERS FOR HW5 -----------------------------------------------------------------------------

-- Increment sensor count proc -----------------------------------------------------------------------------------------
--check which sensors have the specified coordinates in them, increment sensor_count for all these forests
CREATE OR REPLACE PROCEDURE incrementSensorCount_proc(sensor_x real, sensor_y real)
language plpgsql
AS $$
BEGIN
    UPDATE FOREST
    SET sensor_count = sensor_count+1
    WHERE sensor_x >= mbr_xmin AND sensor_x <= mbr_xmax AND sensor_y >= mbr_ymin AND sensor_y <= mbr_ymax;
end;
$$
------------------------------------------------------------------------------------------------------------------------

-- Compute Percentage Function -----------------------------------------------------------------------------------------
-- given an area and a forest id, returns percent of the forest that area represents
CREATE OR REPLACE FUNCTION computePercentage(forest_no varchar(10), area_covered real)
RETURNS real
as
    $$
    DECLARE
        result real;
    BEGIN
        SELECT area_covered / area into result
        FROM FOREST
        WHERE FOREST.forest_no = $1; --since forest_no is ambiguous, use the position

        RETURN result;
    end;
    $$ language plpgsql;
------------------------------------------------------------------------------------------------------------------------

-- Triggers ------------------------------------------------------------------------------------------------------------
-- sensorCount_tri -----------------------------------------------------------------------------------------------------
-- when a new sensor is added, increment the value of sensor_count in all Forests where the sensor is placed
CREATE OR REPLACE FUNCTION sensorCount_func()
returns trigger as
    $$
    begin
        call incrementSensorCount_proc(NEW.x, NEW.y);
        return NEW;
    end;
    $$ language plpgsql;

CREATE TRIGGER sensorCount_tri
    AFTER INSERT
    ON SENSOR
    for each row
    EXECUTE PROCEDURE sensorCount_func();

SELECT * FROM FOREST;

------------------------------------------------------------------------------------------------------------------------
-- percentage_tri-------------------------------------------------------------------------------------------------------
-- when the area of a forest covered by some state is updated, trigger automatically updates
    -- value of percentage using computePercentage

--COME BACK TO THIS
CREATE OR REPLACE FUNCTION percentage_func()
returns trigger as
    $$
    DECLARE
        new_percentage real;
    BEGIN
        raise notice 'begin';
        SELECT computePercentage(NEW.forest_no, NEW.area) into new_percentage;
        raise notice 'new_percentage: %', new_percentage;
        update COVERAGE
        set percentage = new_percentage
        WHERE STATE = NEW.STATE AND forest_no = NEW.forest_no;
        raise notice 'about to end';
        return NEW;
        raise notice 'end';
    END;
    $$ language plpgsql;


CREATE TRIGGER percentage_tri
    AFTER UPDATE of area
    ON COVERAGE
    for each row
    EXECUTE PROCEDURE percentage_func();
------------------------------------------------------------------------------------------------------------------------
-- emergency_tri--------------------------------------------------------------------------------------------------------
-- when a new report is inserted with temp > 100, insert tuple into Emergency
CREATE OR REPLACE FUNCTION emergency_func()
returns trigger as
    $$

    BEGIN
    INSERT INTO EMERGENCY VALUES (new.sensor_id, NEW.report_time);
    return new;
    end;

    $$ language plpgsql;

CREATE TRIGGER emergency_tri
    AFTER INSERT
    ON REPORT
    for each row
    WHEN ( NEW.temperature > 100 )
    EXECUTE FUNCTION emergency_func();
------------------------------------------------------------------------------------------------------------------------
-- enforceMaintainer_tri -----------------------------------------------------------------------------------------------
-- when a new sensor is added, ensure that the maintainer is employed in same state as sensor, if not prevent add
    -- get x/y coords from sensor, plug into forest to get forest_no, plug that into coverage, ensure that state matches employing state
CREATE OR REPLACE FUNCTION enforceMaintainer_func()
returns trigger as
    $$
    DECLARE
        estate varchar(2);
    begin
    -- get the employee's state
    SELECT employing_state into estate
    FROM worker
    WHERE new.maintainer = ssn;

    -- make sure that the states match
    -- since we're allowing nulls for maintainer, allow the insert if the maintainer is null
    IF(new.maintainer is not null AND estate NOT IN(
        SELECT STATE
        FROM COVERAGE JOIN FOREST on COVERAGE.forest_no = FOREST.forest_no
        WHERE new.x >= FOREST.mbr_xmin AND new.x <= FOREST.mbr_xmax AND new.y >= FOREST.mbr_ymin AND new.y <= FOREST.mbr_ymax
        ))
    THEN
        RAISE EXCEPTION 'Sensor location is outside the employees state';
    end if;
    return new;
    end;
    $$ language plpgsql;

CREATE TRIGGER enforceMaintainer_tri
    BEFORE INSERT
    ON SENSOR
    for each row
    EXECUTE FUNCTION enforceMaintainer_func();
------------------------------------------------------------------------------------------------------------------------
--END OF TRIGGERS AND FUNCTIONS ----------------------------------------------------------------------------------------

-- TASK 1: Add Forest --------------------------------------------------------------------------------------------------
-- Get forest name, area, acid level, and the minimum boundary rectangle coordinates (xmin, xmax, ymin, ymax) from user
-- forest_id should be autogenerated
    -- maybe use a get max function on the forest table before updating?
-- if there is already a forest with the given name, should return an exception
-- display forest number as confirmation of success
DROP FUNCTION IF EXISTS addForest CASCADE;
CREATE OR REPLACE FUNCTION addForest(newName varchar(30), newArea real, newAcidLevel real, newXmin real, newXmax real, newYmin real, newYmax real)
RETURNS varchar(10)
AS $$
    DECLARE
        nextKeyInt int;
        nextKey varchar(10);
BEGIN

    --check if there is already a forest with the passed in name
    IF( newName IN(SELECT name FROM FOREST))
    THEN
        RAISE EXCEPTION 'Forest with that name already exists';
    end if;

    IF(EXISTS(SELECT name FROM FOREST where mbr_xmin = newXmin AND mbr_xmax = newXmax AND mbr_ymin = newYmin AND mbr_ymax = newYmax))
    THEN
        RAISE EXCEPTION 'There is already a forest at that location';
    end if;

    IF(newXmin > newXmax)
    THEN
        RAISE EXCEPTION 'Xmin must be less than Xmax';
    end if;

    IF(newYmin > newYmax)
    THEN
        RAISE EXCEPTION 'Ymin must be less than Ymax';
    end if;

    IF(newXmin < 0 OR newXmax < 0 OR newYmin < 0 OR newYmax < 0)
    THEN
        RAISE EXCEPTION 'Locations cannot be negative';
    end if;

    IF(newArea < 0)
    THEN
        RAISE EXCEPTION 'Area cannot be negative';
    end if;

    IF( newAcidLevel > 1 OR newAcidLevel < 0)
    THEN
        RAISE EXCEPTION 'Acid Level must be less than 1 and greater than 0';
    end if;

    -- Generate the next forest id and insert into the table
    SELECT MAX(cast(forest_no as int))+1 into nextKeyInt
    FROM Forest;
    IF(nextKeyInt IS NULL)
    THEN
        nextKeyInt = 0;
    end if;

    SELECT CAST(nextKeyInt AS varchar(10)) into nextKey;

    INSERT INTO FOREST (forest_no, name, area, acid_level, mbr_xmin, mbr_xmax, mbr_ymin, mbr_ymax)
        VALUES(nextKey, newName, newArea, newAcidLevel,
               newXmin, newXmax , newYmin , newYmax);

    --commit;
    return nextKey; --return true to let user know success
end;
$$ language plpgsql;

--SELECT addForest('THE Dope Forest', 1000, 0.8, 30, 90, 900, 80);
--SELECT * FROM FOREST;

--Creating a trigger that updates sensor count when a new forest is inserted
DROP FUNCTION IF EXISTS forest_sensorCount_func() CASCADE;
DROP TRIGGER IF EXISTS forest_sensorCount_tri ON FOREST;
CREATE OR REPLACE FUNCTION forest_sensorCount_func()
returns trigger as
    $$
    DECLARE
        newSC integer;
    begin
        SELECT count into newSC
            FROM(
                SELECT count(*) as count
                FROM SENSOR
                WHERE x >= new.mbr_xmin AND x <= new.mbr_xmax AND y >= new.mbr_ymin AND y <= new.mbr_ymax
                    ) as sel;
        UPDATE FOREST
            set sensor_count = newSC
            where name = new.name;
        return NEW;
    end;
    $$ language plpgsql;

CREATE TRIGGER forest_sensorCount_tri
    AFTER INSERT
    ON FOREST
    for each row
    EXECUTE PROCEDURE forest_sensorCount_func();
------------------------------------------------------------------------------------------------------------------------

-- TASK 2 - ADD WORKER -------------------------------------------------------------------------------------------------
-- Take in: worker SSN, worker, name, worker rank, and worker’s employing state abbreviation.
-- Exception if there is already name or ssn
-- Display worker name as confirmation of success
DROP FUNCTION IF EXISTS addWorker CASCADE;
CREATE OR REPLACE FUNCTION addWorker(newSSN varchar(9), newName varchar(30), newRank integer, newState varchar(2))
RETURNS varchar(30)
AS
$$
    DECLARE

    BEGIN
        IF(EXISTS(SELECT name FROM WORKER WHERE name = newName))
        THEN
            RAISE EXCEPTION 'There is already a worker with that name in the database';
        end if;
        IF(EXISTS(SELECT name FROM WORKER WHERE ssn = newSSN))
        THEN
            RAISE EXCEPTION 'There is already a worker with that SSN in the database';
        end if;
        IF(newRank < 0)
        THEN
            RAISE EXCEPTION 'Rank cannot be negative';
        end if;
        IF(newState not in (SELECT abbreviation FROM state))
        THEN
            RAISE EXCEPTION 'Cannot insert workers from that state into the DB';
        end if;
        --Insert into the worker table
        INSERT INTO WORKER VALUES(newSSN, newName, newRank, newState);
        RETURN newName;

    end;
$$ language plpgsql;

--SELECT addWorker(CAST('999999999' as varchar(9)), CAST('Chris' as varchar(30)), 5, CAST('PA' as varchar(2)))
------------------------------------------------------------------------------------------------------------------------

-- TASK 3 - ADD SENSOR -------------------------------------------------------------------------------------------------
-- take in: X coordinate, Y coordinate, last time it was charged, maintainer, last time it generated a report, and energy level
-- Display the sensor ID and its coordinates as a confirmation of successfully adding the new
    -- sensor to the database.
-- for timestamps, only do year month day hours mins
-- Produce an error message if a sensor with the same coordinates already exists

DROP FUNCTION IF EXISTS addSensor CASCADE;
CREATE OR REPLACE FUNCTION addSensor(newX real, newY real, newLastCharged varchar(30), newMaintainer varchar(9), newLastReport varchar(30), newEnergy integer)
RETURNS integer
AS
$$
    DECLARE
        nextKey integer;
    BEGIN
        --check if there is already a sensor at the location
        IF(EXISTS(SELECT sensor_id FROM sensor WHERE x = newX AND y = newY))
        THEN
            RAISE EXCEPTION 'There is already a sensor at that location';
        end if;
        IF(CAST(newX as integer) < 0 OR CAST(newY as integer) < 0)
        THEN
            RAISE EXCEPTION 'Location cannot be negative';
        end if;
        IF(newEnergy < 0)
        THEN
            RAISE EXCEPTION 'Energy cannot be negative';
        end if;
        IF(newMaintainer not in( SELECT ssn FROM WORKER))
        THEN
            RAISE EXCEPTION 'Maintainer is not valid';
        end if;

        --get the next key
        SELECT MAX(sensor_id)+1 FROM sensor into nextKey;
        IF(nextKey IS NULL)
        THEN
            nextKey = 0;
        end if;
        INSERT INTO SENSOR VALUES(nextKey, newX, newy, TO_TIMESTAMP(newLastCharged, 'mm/dd/yyyy hh24:mi'), newMaintainer, TO_TIMESTAMP(newLastReport, 'mm/dd/yyyy hh24:mi'), newEnergy);
        RETURN nextKey;

    end;
$$ language plpgsql;
------------------------------------------------------------------------------------------------------------------------

-- TASK 4 - switch worker duties ---------------------------------------------------------------------------------------
-- take in names of two workers, swap their sensor duties
-- make sure that the workers are employed in the state
DROP FUNCTION IF EXISTS swapDuties CASCADE;
CREATE OR REPLACE FUNCTION swapDuties(workerA varchar(30), workerB varchar(30))
RETURNS bool
AS
$$
    DECLARE
        workerASSN varchar(9);
        workerBSSN varchar(9);
    BEGIN
        -- make sure that the workers exist
        IF(NOT EXISTS(SELECT name FROM WORKER where name = workerA))
        THEN
            RAISE EXCEPTION 'The first worker is not in the database';
        end if;
        IF(NOT EXISTS(SELECT name FROM WORKER WHERE name = workerB))
        THEN
            RAISE EXCEPTION 'The second worker is not in the database';
        end if;
        IF(workerA = workerB)
        THEN
            RAISE EXCEPTION 'Cannot swap the duties of the same worker';
        end if;
        -- make sure that the workers are employed in the same state
        IF(
            (SELECT employing_state FROM WORKER where name = workerA)
            !=
            (SELECT employing_state FROM WORKER where name = workerB)
            )
        THEN
            RAISE NOTICE 'Cannot complete operation because workers do not work in the same state';
        end if;

        --get the ssns of the workers
        SELECT ssn FROM WORKER WHERE name = workerA into workerASSN;
        SELECT ssn FROM WORKER where name = workerB into workerBSSN;

        -- adjust the sensor table
        UPDATE sensor
        set maintainer =
        (
            CASE
                WHEN (maintainer = workerASSN) THEN workerBSSN
                WHEN (maintainer = workerBSSN) THEN workerASSN
                ELSE maintainer
            end
        );



        return true;

    end;
$$ language plpgsql;

--SELECT swapDuties('John', 'Mike');
--SELECT * FROM SENSOR ORDER BY sensor_id ASC;
------------------------------------------------------------------------------------------------------------------------

-- TASK 5 - Update sensor status ---------------------------------------------------------------------------------------
-- take in: coordinates of the sensor, energy level, when it was last charged, and the temperature
    -- in sensor table: update last charged and energy level
    -- in reports table: put in a new record with the temperature and the current time
-- exceptions:
    -- if coords arent found
    -- IC violation
-- return saying where or not a new emergency was issued (have to check if new record in emergency table)
DROP FUNCTION IF EXISTS updateSensor CASCADE;
CREATE OR REPLACE FUNCTION updateSensor(xCoord real, yCoord real, energyLevel integer, lastCharged varchar(30), repTemp real, curTime varchar(30))
RETURNS bool
AS
$$
    DECLARE
        EBeforeUpdate integer;
        EAfterUpdate integer;
        sensorID integer;
    BEGIN
        --start by making sure we can find the sensor
        IF(NOT EXISTS(SELECT sensor_id FROM sensor where x = xCoord AND y = yCoord))
        Then
            RAISE EXCEPTION 'Cannot find sensor';
        end if;

        --check for energy level errors
        IF(energyLevel < 0 OR energyLevel > 100)
        THEN
            RAISE EXCEPTION 'Invalid energy level';
        end if;

        --get the sensor id for updating report
        SELECT sensor_id FROM sensor WHERE x = xCoord AND y = yCoord into sensorID;

        -- get the count of the emergency table before updating report
        SELECT count(*) FROM EMERGENCY into EBeforeUpdate;

        --update sensor table
        UPDATE SENSOR
            set last_charged = TO_TIMESTAMP(lastCharged, 'mm/dd/yyyy hh24:mi'),
                energy = energyLevel,
                last_read = TO_TIMESTAMP(curTime, 'mm/dd/yyyy hh24:mi') --update last read to be the most recent time as well
            WHERE sensor_id = sensorID;

        --insert the new report into the reports table
        INSERT INTO REPORT VALUES(sensorID, TO_TIMESTAMP(curTime, 'mm/dd/yyyy hh24:mi'), repTemp);

        --count emergency table rows again
        SELECT count(*) FROM EMERGENCY into EAfterUpdate;

        --return true if there was an insert into emergency
        IF(EAfterUpdate > EBeforeUpdate)
        THEN
            return true;
        end if;
        --otherwise return false
        return false;

    end;
$$ language plpgsql;

--SELECT updateSensor(CAST(78 as real), CAST(24 as real), 100, '11/11/2020 22:00', 90, '11/11/2020 22:00');
------------------------------------------------------------------------------------------------------------------------

-- TASK 6 - UPDATE FOREST COVERED AREA ---------------------------------------------------------------------------------
-- Ask the user to supply the forest name, the new area to be updated, and the state abbreviation that the forest spans
    -- updating the area portion of the coverage table

DROP FUNCTION IF EXISTS updateCovered CASCADE;
CREATE OR REPLACE FUNCTION updateCovered(forestName varchar(30), stateName varchar(2), newArea real)
RETURNS bool --return true if successful
AS
$$
    DECLARE
        forestNo varchar(10);
    BEGIN
        --start by making sure that the forestname and state exist
        IF(forestName NOT IN (SELECT name from FOREST))
        THEN
            RAISE EXCEPTION 'Forest is not in the database';
        end if;
        IF(stateName NOT IN (SELECT abbreviation FROM STATE))
        THEN
            RAISE EXCEPTION 'State is not in the database';
        end if;
        --check for various errors
        IF(newArea > (SELECT area FROM STATE WHERE abbreviation = stateName))
        THEN
            RAISE EXCEPTION 'Passed in area is greater than the size of the state';
        end if;
        IF(newArea > (SELECT area FROM FOREST WHERE name=forestName))
        THEN
            RAISE EXCEPTION 'Passed in area is greater than the size of the forest';
        end if;
        IF(newArea < 0)
        THEN
            RAISE EXCEPTION 'Cannot have negative area';
        end if;
        --get the forest no
        SELECT forest_no FROM FOREST WHERE name = forestName into forestNo;
        --make sure that the forest and state are associated with eachother
        IF(NOT EXISTS(SELECT area FROM COVERAGE WHERE forest_no = forestNo and state=stateName))
        THEN
            RAISE EXCEPTION 'Forest is not in the state';
        end if;

        --now update the coverage table
        UPDATE COVERAGE
        set area = newArea
        WHERE forest_no=forestNo AND state=stateName;

        return true;
    end;
$$ language plpgsql;

--SELECT updateCovered('Big Woods', 'PA', CAST(2000 as real));
------------------------------------------------------------------------------------------------------------------------

-- TASK 7 - FIND TOP-K BUSY WORKERS ------------------------------------------------------------------------------------
--User passes in k, we provide the top k busy workers
    -- 'busy' means how many of their maintained sensors need to be charged (energy less than 2)
-- approach to this (using k = 3 as example): loop and do k many selects
    -- SQL: string with rank,name,numSensors for each worker below the passed in rank
    -- JAVA: get the string from SQL, chop off last comma, then break it apart
DROP FUNCTION IF EXISTS busyWorkers CASCADE;
CREATE OR REPLACE FUNCTION busyWorkers(num integer)
RETURNS varchar(100)
AS
$$
    DECLARE
        result varchar(40);
        wRank varchar(10);
        wName varchar(30);
        wCount varchar(10);
        rec RECORD;
    BEGIN
        result = '';
        --start by making sure that the current num is not greater than the num workers
        IF(num > (SELECT count(name) FROM WORKER))
        THEN
            RAISE EXCEPTION 'Passed in number is greater than the number of workers in the database';
        end if;
        --make sure num isnt negative
        IF(num < 0)
        THEN
            RAISE EXCEPTION 'Cannot have a negative ranking';
        end if;

        --create a view to help
        DROP VIEW IF EXISTS DUTIES CASCADE;
        CREATE VIEW DUTIES AS
        SELECT worker.name, count(*) as count
        FROM SENSOR JOIN worker on worker.ssn = sensor.maintainer
        WHERE SENSOR.energy <= 2
        group by worker.name
        order by count DESC;

        FOR rec in (SELECT rank as rank, name as name, count --into wRank, wName, wCount
                     FROM(
                    SELECT DISTINCT duties.name as name, count, DENSE_RANK() over(
                        ORDER BY count DESC) as rank
                    FROM duties JOIN worker ON worker.name = duties.name JOIN COVERAGE on worker.employing_state = Coverage.state
                GROUP BY coverage.state, duties.name, worker.employing_state, duties.count ORDER BY rank ASC) as sub) LOOP

            IF(rec.rank <= num AND rec.name IS NULL)
            THEN
                result = result || rec.rank || ',' || 'null' || ',' || rec.count || ',';
            ELSIF(rec.rank <= num)
            THEN
                result = result || rec.rank || ',' || rec.name || ',' || rec.count || ',';
            end if;
        end loop;

        DROP VIEW IF EXISTS DUTIES CASCADE;

        --result = wRank || ',' || wName || ',' || wCount || ','; --concat the return string together
        return result;
    end;
$$ language plpgsql;
-- SELECT busyWorkers(6)
------------------------------------------------------------------------------------------------------------------------

-- TASK 8 - Sensor Ranking ---------------------------------------------------------------------------------------------
--  system should display the most active sensors. We define most
-- active sensor as the sensor that generate the highest number of reports.
DROP FUNCTION IF EXISTS sensorRanking CASCADE;
CREATE OR REPLACE FUNCTION sensorRanking()
RETURNS varchar(100)
AS
$$
    DECLARE
        result varchar(100);
        rec RECORD;
    BEGIN

        DROP VIEW IF EXISTS SR CASCADE;
        CREATE VIEW SR AS
        SELECT SENSOR.sensor_id, count(*) as numReports
        FROM sensor JOIN report on SENSOR.sensor_id = REPORT.sensor_id
        GROUP BY SENSOR.sensor_id
        ORDER BY numReports DESC;

        result = '';
        FOR rec in
            (
                SELECT  dense_rank()over(order by numReports DESC) as rank,sensor_id, numReports
                FROM SR
            )
        LOOP
            result = result || rec.rank || ',' || rec.sensor_id || ',' || rec.numReports || ',';
        end loop;

        RETURN result;

    end;
$$ language plpgsql;
--SELECT sensorRanking();
------------------------------------------------------------------------------------------------------------------------

