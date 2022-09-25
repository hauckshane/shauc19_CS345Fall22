-- ED: Good SHane
-- Shane Hauck
-- HW 3 - chapter 3 University DB Queries
-- 9/14/22



-- Part 2

DROP DATABASE IF EXISTS shauc19_insurance;
CREATE DATABASE shauc19_insurance;
\c shauc19_insurance

-- 3.13 Write SQL DDL corresponding to the schema in Figure 3.17. Make any reasonable
-- assumptions about data types, and be sure to declare primary and foreign
-- keys.

CREATE TABLE person
    (driver_id varchar(5),
    name varchar(20) not null,
    address varchar(50),
    primary key(driver_id));

CREATE TABLE car
    (license_plate varchar(8),
    model varchar(25),
    year numeric(4,0) check (year > 1701 and year < 2100),
    primary key (license_plate));

CREATE TABLE accident
    (report_number varchar(10),
    year numeric(4,0) check (year > 1701 and year < 2100),
    location varchar(20),
    primary key (report_number));

CREATE TABLE owns
    (driver_id varchar(5),
    license_plate varchar(8),
    primary key (driver_id, license_plate),
    foreign key (driver_id) references person,
    foreign key (license_plate) references car);

CREATE TABlE participated
    (report_number varchar(10),
    license_plate varchar(8),
    driver_id varchar(5),
    damage_amount numeric(8,2),
    primary key (report_number, license_plate),
    foreign key (report_number) references accident,
    foreign key (license_plate) references car,
    foreign key (driver_id) references person);


-- 3.14 Consider the insurance database of Figure 3.17, where the primary keys are
-- underlined. Construct the following SQL queries for this relational database.
-- a. Find the number of accidents involving a car belonging to a person named “John Smith”.

WITH
    t as (SELECT driver_id
          FROM person
          WHERE name = 'John Smith')
SELECT
    count(*)
FROM
    t, participated
WHERE
    t.driver_id = participated.driver_id;

-- b. Update the damage amount for the car with license plate “AABB2000”
--    in the accident with report number “AR2197” to $3000.

UPDATE
    participated
SET
    damage_amount = 3000
WHERE
    license_plate = 'AABB2000' AND
    report_number = 'AR2197';



