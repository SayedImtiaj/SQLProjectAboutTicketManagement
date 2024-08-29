use master
if DB_ID('railway_systems') is not null
drop database Railway_Ticket_Systems
go

sp_helpdb master
go

use master
go
Declare @data_path nvarchar(256)
set @data_path = ( select substring (physical_name,1,charindex(N'master.mdf',lower(physical_name)) -1)
from master.sys.master_files
where database_id=1 and file_id=1);
execute ('create database Railway_Ticket_Systems
On primary (Name=Railway_Ticket_Systems_data,FileName='''
+ @data_path + 'Railway_Ticket_Systems_data.mdf'', Size=16MB,MaxSize=Unlimited,Filegrowth=2MB)
log on (Name = Railway_Ticket_Systems_log,filename=''' 
+ @data_path + 'Railway_Ticket_Systems_log.ldf'',Size=10MB,Maxsize=100MB,Filegrowth=1MB)'
);
go

use Railway_Ticket_Systems

create TABLE  user_logins
(
	user_id INT PRIMARY KEY identity,
    user_password varchar(30),
    first_name varchar(30),
	last_name varchar(30),
	sign_up_on DATE,
	email_id varchar(30)
);


CREATE TABLE  passengers 
(
	passenger_id INT PRIMARY KEY identity,
    user_password nvarchar(30),
    first_name varchar(30),
	last_name varchar(30),
	sign_up_on DATE,
	email_id varchar(30),
	contact varchar(30)
);


CREATE TABLE  train_types 
(
	train_type_id INT PRIMARY KEY identity,
    train_type varchar(30),
    coaches_count varchar(30),
	passenger_strength varchar(30),
	train_count DATE
);


CREATE TABLE  station 
(
	station_id INT PRIMARY KEY identity,
    station_name varchar(30),
	city varchar(30),
	state varchar(30)
);


CREATE TABLE  train_detailsess
(
	train_id INT PRIMARY KEY identity,
    train_type_id INT REFERENCES train_type (train_type_id),
    source_station_id INT REFERENCES stations (station_id),
	destination_station_id INT REFERENCES stations (station_id),
	journey_id int references journey(journey_id),
	duration_minutes INT,
	journey_start TIMESTAMP,
	passenger_strength INT
);


CREATE TABLE  journeys 
(
	journey_id int PRIMARY KEY identity,
	passenger_id int REFERENCES passenger (passenger_id),
    booking_id varchar(30),
	payment_id varchar(30),
	payment_status varchar(30),
	paid_on TIMESTAMP,
	booking_status varchar(30),
	seat_alloted varchar(30)
);


create TABLE  train_route 
(
row_id int PRIMARY KEY identity,
route_id int,
station_id int REFERENCES stations (station_id),
order_number INT,
halt_duration_minutes INT,
estimated_arrival TIME,
estimated_departure TIME
);




	-- Example ALTER TABLE command
-- Add a new column to the user_login table
ALTER TABLE user_login
ADD is_admin BIT DEFAULT 0;

-- Example SELECT with CASE WHEN
-- Identify users who are administrators
SELECT
    user_id,
    first_name,
    last_name,
    CASE WHEN user_id = 1 THEN 'Administrator' ELSE 'Regular User' END AS user_type
FROM
    user_login;

-- Example UPDATE with JOIN
-- Make user with user_id 1 an administrator
UPDATE passenger
SET passenger_id = 4
WHERE user_id = 1;

-- Example DELETE with JOIN
-- Delete a passenger and associated journey
DELETE FROM
    passenger
WHERE
    passenger_id = 2;

-- Example GROUP BY and HAVING with aggregate functions
-- Get the average duration and total passenger_strength for each train type
SELECT
    train_types,
    AVG(duration_minutes) AS avg_duration,
    SUM(passenger_strength) AS total_passenger_strength
FROM
    train_detailses
GROUP BY
    train_types
HAVING
    COUNT(train_id) > 1;

-- Example INNER JOIN
-- Retrieve information about booked journeys and corresponding passengers
SELECT
    journey.journey_id,
    journey.booking_id,
    journey.booking_status,
    passenger.first_name,
    passenger.last_name
FROM
    journey
INNER JOIN
    passenger ON journey.passenger_id = passenger.passenger_id;

-- Example OUTER JOIN
-- Retrieve all stations and corresponding train_routes, even if there's no match
SELECT
    stations.station_name,
    train_routes.estimated_arrival,
    train_routes.estimated_departure
FROM
    stations
LEFT OUTER JOIN
    train_routes ON stations.station_id = train_routes.station_id;

-- Example CREATE VIEW
-- Create a view to simplify complex queries
CREATE VIEW v_journey_details
AS
SELECT
    journey.journey_id,
    passenger.first_name,
    passenger.last_name,
    journey.booking_status,
    train_detailses.train_id
FROM
    journey
JOIN
    passenger ON journey.passenger_id = passenger.passenger_id
JOIN
    train_detailses ON journey.journey_id = train_detailses.journey_id;

-- Example CREATE INDEX
-- Create an index on the journey table for faster retrieval based on booking_id
CREATE INDEX idx_journey_booking
ON journey (booking_id);

-- Example EXISTS subquery
-- Check if there are any bookings for a specific user
IF EXISTS (SELECT 1 FROM user_login WHERE user_id = 1)
    PRINT 'User has bookings';
ELSE
    PRINT 'User has no bookings';

-- Example EXECUTE statement
-- Execute a dynamic SQL statement
DECLARE @sql_query NVARCHAR(MAX);
SET @sql_query = 'SELECT * FROM user_login;';
EXECUTE sp_executesql @sql_query;

-- Example IS NULL and IS NOT NULL
-- Find users with and without email addresses
SELECT
    user_id,
    first_name,
    last_name
FROM
    user_login
WHERE
    email_id IS NULL;

SELECT
    user_id,
    first_name,
    last_name
FROM
    user_login
WHERE
    email_id IS NOT NULL;
-- Example CREATE TRIGGER
-- Create a trigger to update the passenger_strength in train_detailses after a journey is confirmed
CREATE TRIGGER trg_update_passenger_strength
ON journey
AFTER UPDATE
AS
BEGIN
    IF UPDATE(booking_status) AND (SELECT booking_status FROM INSERTED) = 'Confirmed'
    BEGIN
        UPDATE train_detailses
        SET passenger_strength = passenger_strength - 1
        WHERE journey_id = (SELECT journey_id FROM INSERTED);
    END
END;

-- Example INNER JOIN with GROUP BY and HAVING
-- Find the average duration of journeys with more than 1 booking
SELECT
    AVG(duration_minutes) AS avg_duration
FROM
    train_detailses
JOIN
    journey ON train_detailses.journey_id = journey.journey_id
GROUP BY
    train_detailses.train_id
HAVING
    COUNT(journey.booking_id) > 1;

-- Example OUTER JOIN with IS NULL
-- Find stations that are not part of any train route
SELECT
    stations.station_name
FROM
    stations
LEFT OUTER JOIN
    train_routes ON stations.station_id = train_routes.station_id
WHERE
    train_routes.station_id IS NULL;

-- Example ALL with subquery
-- Find passengers who booked journeys with payment_status = 'Paid'
SELECT
    passenger.first_name,
    passenger.last_name
FROM
    passenger
WHERE
    passenger_id = ALL (SELECT passenger_id FROM journey WHERE payment_status = 'Paid');

-- Example EXISTS with subquery
-- Find users who have made at least one payment
SELECT
    user_login.first_name,
    user_login.last_name
FROM
    user_login
WHERE
    EXISTS (SELECT 1 FROM journey WHERE journey.passenger_id =1)

