----CS1555/2055 - DATABASE MANAGEMENT SYSTEMS (FALL 2021)
----DEPT. OF COMPUTER SCIENCE, UNIVERSITY OF PITTSBURGH
----ASSIGNMENT #2: Insert Statements


INSERT INTO homework2.FOREST VALUES ('1','Allegheny National Forest',3500,0.31,20,90,10,60);
INSERT INTO homework2.FOREST VALUES ('2','Pennsylvania Forest',2700,0.74,40,70,20,110);
INSERT INTO homework2.FOREST VALUES ('3','Stone Valley',5000,0.56,60,160,30,80);
INSERT INTO homework2.FOREST VALUES ('4','Big Woods',3000,0.92,150,180,20,120);
INSERT INTO homework2.FOREST VALUES ('5','Crooked Forest',2400,0.23,100,140,70,130);

INSERT INTO homework2.STATE (name, abbreviation, area, population) VALUES ('Pennsylvania', 'PA', '50000', '14000000');
INSERT INTO homework2.STATE (name, abbreviation, area, population) VALUES ('Ohio', 'OH', '45000', '12000000');
INSERT INTO homework2.STATE (name, abbreviation, area, population) VALUES ('Virginia', 'VA', '35000', '10000000');

INSERT INTO homework2.COVERAGE VALUES (1,'OH',1,3500);
INSERT INTO homework2.COVERAGE VALUES (2,'OH',1,2700);
INSERT INTO homework2.COVERAGE VALUES (3,'OH',0.3,1500);
INSERT INTO homework2.COVERAGE VALUES (3,'PA',0.42,2100);
INSERT INTO homework2.COVERAGE VALUES (3,'VA',0.28,1400);
INSERT INTO homework2.COVERAGE VALUES (4,'PA',0.4,1200);
INSERT INTO homework2.COVERAGE VALUES (4,'VA',0.6,1800);
INSERT INTO homework2.COVERAGE VALUES (5,'VA',1,2400);

INSERT INTO homework2.ROAD VALUES (1,'Forbes',500);
INSERT INTO homework2.ROAD VALUES (2,'Bigelow',300);
INSERT INTO homework2.ROAD VALUES (3,'Bayard',555);
INSERT INTO homework2.ROAD VALUES (4,'Grant',100);
INSERT INTO homework2.ROAD VALUES (5,'Carson',150);
INSERT INTO homework2.ROAD VALUES (6,'Greatview',180);
INSERT INTO homework2.ROAD VALUES (7,'Beacon',333);

INSERT INTO homework2.INTERSECTION VALUES (1,1);
INSERT INTO homework2.INTERSECTION VALUES (1,2);
INSERT INTO homework2.INTERSECTION VALUES (1,4);
INSERT INTO homework2.INTERSECTION VALUES (1,7);
INSERT INTO homework2.INTERSECTION VALUES (2,1);
INSERT INTO homework2.INTERSECTION VALUES (2,4);
INSERT INTO homework2.INTERSECTION VALUES (2,5);
INSERT INTO homework2.INTERSECTION VALUES (2,6);
INSERT INTO homework2.INTERSECTION VALUES (2,7);
INSERT INTO homework2.INTERSECTION VALUES (3,3);
INSERT INTO homework2.INTERSECTION VALUES (3,5);
INSERT INTO homework2.INTERSECTION VALUES (4,4);
INSERT INTO homework2.INTERSECTION VALUES (4,5);
INSERT INTO homework2.INTERSECTION VALUES (4,6);
INSERT INTO homework2.INTERSECTION VALUES (5,1);
INSERT INTO homework2.INTERSECTION VALUES (5,3);
INSERT INTO homework2.INTERSECTION VALUES (5,5);
INSERT INTO homework2.INTERSECTION VALUES (5,6);

INSERT INTO homework2.WORKER (ssn, name,  rank, employing_state) VALUES ('123456789','John',6, 'OH');
INSERT INTO homework2.WORKER (ssn, name,  rank, employing_state) VALUES ('121212121','Jason',5,'PA');
INSERT INTO homework2.WORKER (ssn, name,  rank, employing_state) VALUES ('222222222','Mike',4,'OH');
INSERT INTO homework2.WORKER (ssn, name,  rank, employing_state) VALUES ('333333333','Tim',2,'VA');

INSERT INTO homework2.SENSOR VALUES (1,33,29,TO_TIMESTAMP('6/28/2020 22:00', 'mm/dd/yyyy hh24:mi'),'123456789',TO_TIMESTAMP('12/1/2020 22:00', 'mm/dd/yyyy hh24:mi'),6);
INSERT INTO homework2.SENSOR VALUES (2,78,24,TO_TIMESTAMP('7/9/2020 23:00', 'mm/dd/yyyy hh24:mi'),'222222222',TO_TIMESTAMP('11/1/2020 18:30', 'mm/dd/yyyy hh24:mi'),8);
INSERT INTO homework2.SENSOR VALUES (3,51,51,TO_TIMESTAMP('9/1/2020 18:30', 'mm/dd/yyyy hh24:mi'),'222222222',TO_TIMESTAMP('11/9/2020 8:25', 'mm/dd/yyyy hh24:mi'),4);
INSERT INTO homework2.SENSOR VALUES (4,67,49,TO_TIMESTAMP('9/9/2020 22:00', 'mm/dd/yyyy hh24:mi'),'121212121',TO_TIMESTAMP('12/6/2020 22:00', 'mm/dd/yyyy hh24:mi'),6);
INSERT INTO homework2.SENSOR VALUES (5,66,92,TO_TIMESTAMP('9/11/2020 22:00', 'mm/dd/yyyy hh24:mi'),'123456789',TO_TIMESTAMP('11/7/2020 22:00', 'mm/dd/yyyy hh24:mi'),6);
INSERT INTO homework2.SENSOR VALUES (6,100,52,TO_TIMESTAMP('9/13/2020 22:00', 'mm/dd/yyyy hh24:mi'),'121212121',TO_TIMESTAMP('11/9/2020 23:00', 'mm/dd/yyyy hh24:mi'),5);
INSERT INTO homework2.SENSOR VALUES (7,111,41,TO_TIMESTAMP('9/21/2020 22:00', 'mm/dd/yyyy hh24:mi'),'222222222',TO_TIMESTAMP('11/21/2020 22:00', 'mm/dd/yyyy hh24:mi'),2);
INSERT INTO homework2.SENSOR VALUES (8,120,75,TO_TIMESTAMP('10/13/2020 22:00', 'mm/dd/yyyy hh24:mi'),'123456789',TO_TIMESTAMP('11/13/2020 22:00', 'mm/dd/yyyy hh24:mi'),6);
INSERT INTO homework2.SENSOR VALUES (9,124,108,TO_TIMESTAMP('10/21/2020 22:00', 'mm/dd/yyyy hh24:mi'),'333333333',TO_TIMESTAMP('11/28/2020 22:00', 'mm/dd/yyyy hh24:mi'),7);
INSERT INTO homework2.SENSOR VALUES (10,153,50,TO_TIMESTAMP('11/10/2020 20:00', 'mm/dd/yyyy hh24:mi'),'333333333',TO_TIMESTAMP('11/21/2020 22:00', 'mm/dd/yyyy hh24:mi'),1);
INSERT INTO homework2.SENSOR VALUES (11,151,33,TO_TIMESTAMP('11/21/2020 22:00', 'mm/dd/yyyy hh24:mi'),'222222222',TO_TIMESTAMP('11/27/2020 22:00', 'mm/dd/yyyy hh24:mi'),2);
INSERT INTO homework2.SENSOR VALUES (12,151,73,TO_TIMESTAMP('11/28/2020 22:00', 'mm/dd/yyyy hh24:mi'),'121212121',TO_TIMESTAMP('11/30/2020 9:03', 'mm/dd/yyyy hh24:mi'),2);
INSERT INTO homework2.SENSOR VALUES (13,100,20,TO_TIMESTAMP('11/28/2020 22:00', 'mm/dd/yyyy hh24:mi'),NULL,TO_TIMESTAMP('11/30/2020 9:03', 'mm/dd/yyyy hh24:mi'),2);

INSERT INTO homework2.REPORT VALUES (7,TO_TIMESTAMP('5/10/2020 22:00', 'mm/dd/yyyy hh24:mi'),46);
INSERT INTO homework2.REPORT VALUES (11,TO_TIMESTAMP('5/24/2020 13:40', 'mm/dd/yyyy hh24:mi'),88);
INSERT INTO homework2.REPORT VALUES (12,TO_TIMESTAMP('6/28/2020 22:00', 'mm/dd/yyyy hh24:mi'),87);
INSERT INTO homework2.REPORT VALUES (6,TO_TIMESTAMP('7/9/2020 23:00', 'mm/dd/yyyy hh24:mi'),38);
INSERT INTO homework2.REPORT VALUES (2,TO_TIMESTAMP('9/1/2020 18:30', 'mm/dd/yyyy hh24:mi'),46);
INSERT INTO homework2.REPORT VALUES (1,TO_TIMESTAMP('9/1/2020 22:00', 'mm/dd/yyyy hh24:mi'),34);
INSERT INTO homework2.REPORT VALUES (3,TO_TIMESTAMP('9/5/2020 10:00', 'mm/dd/yyyy hh24:mi'),57);
INSERT INTO homework2.REPORT VALUES (4,TO_TIMESTAMP('9/6/2020 22:00', 'mm/dd/yyyy hh24:mi'),62);
INSERT INTO homework2.REPORT VALUES (5,TO_TIMESTAMP('9/7/2020 22:00', 'mm/dd/yyyy hh24:mi'),52);
INSERT INTO homework2.REPORT VALUES (3,TO_TIMESTAMP('9/9/2020 8:25', 'mm/dd/yyyy hh24:mi'),61);
INSERT INTO homework2.REPORT VALUES (7,TO_TIMESTAMP('9/9/2020 22:00', 'mm/dd/yyyy hh24:mi'),37);
INSERT INTO homework2.REPORT VALUES (1,TO_TIMESTAMP('9/10/2020 20:00', 'mm/dd/yyyy hh24:mi'),58);
INSERT INTO homework2.REPORT VALUES (7,TO_TIMESTAMP('9/10/2020 22:00', 'mm/dd/yyyy hh24:mi'),46);
INSERT INTO homework2.REPORT VALUES (8,TO_TIMESTAMP('9/11/2020 2:00', 'mm/dd/yyyy hh24:mi'),44);
INSERT INTO homework2.REPORT VALUES (7,TO_TIMESTAMP('9/11/2020 22:00', 'mm/dd/yyyy hh24:mi'),49);
INSERT INTO homework2.REPORT VALUES (8,TO_TIMESTAMP('9/13/2020 22:00', 'mm/dd/yyyy hh24:mi'),51);
INSERT INTO homework2.REPORT VALUES (9,TO_TIMESTAMP('9/21/2020 22:00', 'mm/dd/yyyy hh24:mi'),55);
INSERT INTO homework2.REPORT VALUES (10,TO_TIMESTAMP('9/21/2020 22:00', 'mm/dd/yyyy hh24:mi'),70);
INSERT INTO homework2.REPORT VALUES (11,TO_TIMESTAMP('9/24/2020 13:40', 'mm/dd/yyyy hh24:mi'),88);
INSERT INTO homework2.REPORT VALUES (11,TO_TIMESTAMP('9/27/2020 22:00', 'mm/dd/yyyy hh24:mi'),46);
INSERT INTO homework2.REPORT VALUES (12,TO_TIMESTAMP('9/30/2020 9:03', 'mm/dd/yyyy hh24:mi'),60);
INSERT INTO homework2.REPORT VALUES (2,TO_TIMESTAMP('10/1/2020 18:30', 'mm/dd/yyyy hh24:mi'),46);
INSERT INTO homework2.REPORT VALUES (1,TO_TIMESTAMP('10/1/2020 22:00', 'mm/dd/yyyy hh24:mi'),34);
INSERT INTO homework2.REPORT VALUES (3,TO_TIMESTAMP('10/5/2020 10:00', 'mm/dd/yyyy hh24:mi'),57);
INSERT INTO homework2.REPORT VALUES (5,TO_TIMESTAMP('10/7/2020 22:00', 'mm/dd/yyyy hh24:mi'),52);
INSERT INTO homework2.REPORT VALUES (7,TO_TIMESTAMP('10/9/2020 22:00', 'mm/dd/yyyy hh24:mi'),37);
INSERT INTO homework2.REPORT VALUES (6,TO_TIMESTAMP('10/9/2020 23:00', 'mm/dd/yyyy hh24:mi'),38);
INSERT INTO homework2.REPORT VALUES (7,TO_TIMESTAMP('10/10/2020 22:00', 'mm/dd/yyyy hh24:mi'),46);
INSERT INTO homework2.REPORT VALUES (7,TO_TIMESTAMP('10/11/2020 22:00', 'mm/dd/yyyy hh24:mi'),49);
INSERT INTO homework2.REPORT VALUES (8,TO_TIMESTAMP('10/13/2020 22:00', 'mm/dd/yyyy hh24:mi'),51);
INSERT INTO homework2.REPORT VALUES (10,TO_TIMESTAMP('10/21/2020 22:00', 'mm/dd/yyyy hh24:mi'),70);
INSERT INTO homework2.REPORT VALUES (11,TO_TIMESTAMP('10/24/2020 13:40', 'mm/dd/yyyy hh24:mi'),88);
INSERT INTO homework2.REPORT VALUES (11,TO_TIMESTAMP('10/27/2020 22:00', 'mm/dd/yyyy hh24:mi'),46);
INSERT INTO homework2.REPORT VALUES (12,TO_TIMESTAMP('10/30/2020 9:03', 'mm/dd/yyyy hh24:mi'),60);
INSERT INTO homework2.REPORT VALUES (2,TO_TIMESTAMP('11/1/2020 18:30', 'mm/dd/yyyy hh24:mi'),46);
INSERT INTO homework2.REPORT VALUES (3,TO_TIMESTAMP('11/5/2020 10:00', 'mm/dd/yyyy hh24:mi'),57);
INSERT INTO homework2.REPORT VALUES (3,TO_TIMESTAMP('11/6/2020 11:00', 'mm/dd/yyyy hh24:mi'),53);
INSERT INTO homework2.REPORT VALUES (4,TO_TIMESTAMP('11/6/2020 22:00', 'mm/dd/yyyy hh24:mi'),62);
INSERT INTO homework2.REPORT VALUES (5,TO_TIMESTAMP('11/7/2020 22:00', 'mm/dd/yyyy hh24:mi'),52);
INSERT INTO homework2.REPORT VALUES (3,TO_TIMESTAMP('11/9/2020 8:25', 'mm/dd/yyyy hh24:mi'),61);
INSERT INTO homework2.REPORT VALUES (7,TO_TIMESTAMP('11/9/2020 22:00', 'mm/dd/yyyy hh24:mi'),37);
INSERT INTO homework2.REPORT VALUES (6,TO_TIMESTAMP('11/9/2020 23:00', 'mm/dd/yyyy hh24:mi'),38);
INSERT INTO homework2.REPORT VALUES (1,TO_TIMESTAMP('11/10/2020 20:00', 'mm/dd/yyyy hh24:mi'),58);
INSERT INTO homework2.REPORT VALUES (8,TO_TIMESTAMP('11/11/2020 2:00', 'mm/dd/yyyy hh24:mi'),44);
INSERT INTO homework2.REPORT VALUES (7,TO_TIMESTAMP('11/11/2020 22:00', 'mm/dd/yyyy hh24:mi'),49);
INSERT INTO homework2.REPORT VALUES (11,TO_TIMESTAMP('11/11/2020 22:00', 'mm/dd/yyyy hh24:mi'),76);
INSERT INTO homework2.REPORT VALUES (8,TO_TIMESTAMP('11/13/2020 22:00', 'mm/dd/yyyy hh24:mi'),51);
INSERT INTO homework2.REPORT VALUES (7,TO_TIMESTAMP('11/21/2020 22:00', 'mm/dd/yyyy hh24:mi'),47);
INSERT INTO homework2.REPORT VALUES (9,TO_TIMESTAMP('11/21/2020 22:00', 'mm/dd/yyyy hh24:mi'),55);
INSERT INTO homework2.REPORT VALUES (10,TO_TIMESTAMP('11/21/2020 22:00', 'mm/dd/yyyy hh24:mi'),70);
INSERT INTO homework2.REPORT VALUES (12,TO_TIMESTAMP('11/24/2020 13:40', 'mm/dd/yyyy hh24:mi'),77);
INSERT INTO homework2.REPORT VALUES (9,TO_TIMESTAMP('11/27/2020 22:00', 'mm/dd/yyyy hh24:mi'),33);
INSERT INTO homework2.REPORT VALUES (11,TO_TIMESTAMP('11/27/2020 22:00', 'mm/dd/yyyy hh24:mi'),46);
INSERT INTO homework2.REPORT VALUES (9,TO_TIMESTAMP('11/28/2020 22:00', 'mm/dd/yyyy hh24:mi'),35);
INSERT INTO homework2.REPORT VALUES (12,TO_TIMESTAMP('11/28/2020 22:00', 'mm/dd/yyyy hh24:mi'),87);
INSERT INTO homework2.REPORT VALUES (12,TO_TIMESTAMP('11/30/2020 9:03', 'mm/dd/yyyy hh24:mi'),60);
INSERT INTO homework2.REPORT VALUES (1,TO_TIMESTAMP('12/1/2020 22:00', 'mm/dd/yyyy hh24:mi'),34);
INSERT INTO homework2.REPORT VALUES (4,TO_TIMESTAMP('12/6/2020 22:00', 'mm/dd/yyyy hh24:mi'),62);