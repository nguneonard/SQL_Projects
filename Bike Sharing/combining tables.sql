with Combined_Table as
(
		SELECT * from Capstone_project_Coursera..[202101-divvy-tripdata]
		Union
		SELECT * from Capstone_project_Coursera..[202102-divvy-tripdata]
		Union
		SELECT * from Capstone_project_Coursera..[202103-divvy-tripdata]
		Union
		SELECT * from Capstone_project_Coursera..[202104-divvy-tripdata]
		Union
		SELECT * from Capstone_project_Coursera..[202105-divvy-tripdata]
		Union
		SELECT * from Capstone_project_Coursera..[202106-divvy-tripdata]
		Union
		SELECT * from Capstone_project_Coursera..[202107-divvy-tripdata]
		Union
		SELECT * from Capstone_project_Coursera..[202108-divvy-tripdata]
		Union
		SELECT * from Capstone_project_Coursera..[202109-divvy-tripdata]
		Union
		SELECT * from Capstone_project_Coursera..[202110-divvy-tripdata]
		Union
		SELECT * from Capstone_project_Coursera..[202111-divvy-tripdata]
		Union
		SELECT * from Capstone_project_Coursera..[202112-divvy-tripdata]
)
SELECT *
INTO dbo.CYCLIST_TRIP_DATA
FROM Combined_Table


-- Data Exploration
---------------------------------------------
-- count the number of records in CYCLIST_TRIP_DATA
select count(*)
from dbo.CYCLIST_TRIP_DATA


-- Checking if table exists
-- Find the number of rides by casual-members and rides by annual-members
SELECT MEMBER_CASUAL, COUNT(*)
FROM CYCLIST_TRIP_DATA
GROUP BY MEMBER_CASUAL;

-- Counting number of rideable types
SELECT rideable_type, COUNT(1)
FROM CYCLIST_TRIP_DATA
GROUP BY rideable_type;

-- Counting rides ending at each docking station
SELECT END_STATION_ID, END_STATION_NAME, COUNT(1) AS rides
FROM CYCLIST_TRIP_DATA
GROUP BY END_STATION_ID, END_STATION_NAME
ORDER BY rides DESC;

-- Counting rides starting at each docking station
SELECT  START_STATION_NAME, COUNT(1) AS rides
FROM CYCLIST_TRIP_DATA
GROUP BY START_STATION_NAME
ORDER BY rides DESC;

-- Count number of round trips
SELECT START_STATION_ID, END_STATION_ID,RIDEABLE_TYPE,MEMBER_CASUAL
FROM CYCLIST_TRIP_DATA
WHERE START_STATION_ID = END_STATION_ID;

SELECT COUNT(*)
FROM CYCLIST_TRIP_DATA
WHERE START_STATION_ID = END_STATION_ID;


-- Data Quality Check
---------------------------------------------

-- See if anything other than member or casual is present in MEMBER_CASUAL
SELECT DISTINCT MEMBER_CASUAL
FROM CYCLIST_TRIP_DATA;

-- Check the ranges of latitudes and longitudes
SELECT MIN(end_lng),MAX(end_lng),
MIN(end_lat),MAX(end_lat), 
MIN(start_lng),MAX(start_lng),
MIN(start_lat),MAX(start_lat)
FROM CYCLIST_TRIP_DATA;


-- Check if ride ids (which are supposed to be unique) having count >1
SELECT ride_id, COUNT(1)
FROM CYCLIST_TRIP_DATA
GROUP BY ride_id
HAVING COUNT(1) > 1;

-- Checking for nulls in rows
SELECT *
FROM CYCLIST_TRIP_DATA
WHERE started_at IS NULL OR ended_at IS NULL;

-- Checking for rows where column value is absent
-- We want to investigate if the blank fields are either due to empty strings, or null , or whitespaces

-- Below query is to count fields which only have whitespaces 
SELECT COUNT (*) 
FROM CYCLIST_TRIP_DATA 
WHERE TRIM(START_STATION_ID) IS NULL OR TRIM(START_STATION_NAME) IS NULL;


-- Counting number of nulls
-- Checking on start and end stations
SELECT COUNT (*) 
FROM CYCLIST_TRIP_DATA 
WHERE START_STATION_ID IS NULL OR START_STATION_NAME IS NULL;

SELECT COUNT (*) 
FROM CYCLIST_TRIP_DATA 
WHERE END_STATION_ID IS NULL OR END_STATION_NAME IS NULL;]


SELECT COUNT(*)
FROM CYCLIST_TRIP_DATA
WHERE START_LAT IS NULL OR END_LAT IS NULL;

SELECT COUNT(*)
FROM CYCLIST_TRIP_DATA
WHERE START_LNG IS NULL OR END_LNG IS NULL;

SELECT COUNT(*)
FROM CYCLIST_TRIP_DATA
WHERE MEMBER_CASUAL IS NULL;

SELECT COUNT(*)
FROM CYCLIST_TRIP_DATA
WHERE RIDEABLE_TYPE IS NULL;


-- Data Cleaning
---------------------------------------------

-- Delete all rows where any field is null
-- Below query deletes 1,95,057 rows
DELETE
FROM CYCLIST_TRIP_DATA
WHERE RIDE_ID IS NULL
OR RIDEABLE_TYPE IS NULL
OR STARTED_AT IS NULL
OR ENDED_AT IS NULL
OR START_STATION_NAME IS NULL
OR START_STATION_ID IS NULL
OR END_STATION_NAME IS NULL
OR END_STATION_ID IS NULL
OR START_LAT IS NULL
OR START_LNG IS NULL
OR END_LAT IS NULL
OR END_LNG IS NULL
OR MEMBER_CASUAL IS NULL;

-- Identify and exclude data with anomalies
-- 10743 rows deleted.
DELETE
FROM CYCLIST_TRIP_DATA
WHERE STARTED_AT >= ENDED_AT;

-- Checking if ride ids still have count >1
SELECT ride_id, COUNT(1)
FROM CYCLIST_TRIP_DATA
GROUP BY ride_id
HAVING COUNT(1) > 1;

-- Check again for any nulls
SELECT COUNT (*) 
FROM CYCLIST_TRIP_DATA 
WHERE START_STATION_ID IS NULL OR START_STATION_NAME IS NULL;


---------------------------------------------
-- Tables for Visualization
---------------------------------------------

-- Create new column trip duration secs
ALTER TABLE dbo.CYCLIST_TRIP_DATA
ADD TRIP_DURATION_SECS INT;


-- Calculate trip length
UPDATE dbo.CYCLIST_TRIP_DATA
SET TRIP_DURATION_SECS = DATEPART(HOUR FROM (ended_at-started_at))*3600 + DATEPART(MINUTE 
FROM (ended_at-started_at))*60 + DATEPART(SECOND FROM (ended_at-started_at));

select *
from CYCLIST_TRIP_DATA

-- Number of rides for casual and members
With number_of_rides
as
(
	SELECT MEMBER_CASUAL, COUNT(*) AS NO_OF_RIDES
	FROM CYCLIST_TRIP_DATA
	GROUP BY MEMBER_CASUAL
)
SELECT *
INTO dbo.MEM_CAS_RIDES
FROM number_of_rides
ORDER BY NO_OF_RIDES DESC


-- Count of rides for each bike type
With number_of_rides_bikes
as
(
	SELECT RIDEABLE_TYPE, COUNT(*) AS NO_OF_RIDES
    FROM CYCLIST_TRIP_DATA
    GROUP BY RIDEABLE_TYPE
)
SELECT *
INTO dbo.BIKES_RIDES
FROM number_of_rides_bikes
ORDER BY NO_OF_RIDES DESC;

-- Distribution of members and casuals for each bike type
With mem_cas_bikes
as
(
	SELECT RIDEABLE_TYPE, MEMBER_CASUAL, COUNT(*) AS NO_OF_RIDES
    FROM CYCLIST_TRIP_DATA
    GROUP BY RIDEABLE_TYPE,MEMBER_CASUAL
)
SELECT *
INTO dbo.MEM_CAS_BIKES_RIDES
FROM mem_cas_bikes
ORDER BY RIDEABLE_TYPE DESC;

-- Count round trips for each bike type and membership type
With round_trip
as
(
   SELECT START_STATION_NAME, COUNT(*) AS NO_OF_ROUND_TRIPS, RIDEABLE_TYPE, MEMBER_CASUAL
   FROM CYCLIST_TRIP_DATA
   WHERE START_STATION_ID = END_STATION_ID
   GROUP BY START_STATION_NAME, RIDEABLE_TYPE, MEMBER_CASUAL
)
SELECT *
INTO dbo.ROUND_RIDES
FROM round_trip
ORDER BY START_STATION_NAME, RIDEABLE_TYPE;


----------------------------------------------------------------------------
--     Distribution of casual and member rides across the year
----------------------------------------------------------------------------

--rides for members and casual members yearly
With cas_mem_yr
as
(
   select CONVERT(CHAR(4), STARTED_AT, 100) + CONVERT(CHAR(4), STARTED_AT, 120) AS MON_YEAR, 
           MEMBER_CASUAL, COUNT(*) AS NO_OF_RIDES
   FROM CYCLIST_TRIP_DATA
   GROUP BY CONVERT(CHAR(4), STARTED_AT, 100) + CONVERT(CHAR(4), STARTED_AT, 120),MEMBER_CASUAL

)
SELECT *
INTO dbo.YEAR_RIDES
FROM cas_mem_yr
--select month(STARTED_AT) " ", year(STARTED_AT) as MM_YY
--select CONCAT(YEAR([STARTED_AT]), '-', RIGHT(CONCAT('00', MONTH([STARTED_AT])), 2))


----casual members rides yearly
With yr_rides_cas
as
(
   select CONVERT(CHAR(4), STARTED_AT, 100) + CONVERT(CHAR(4), STARTED_AT, 120) AS MON_YEAR, 
           MEMBER_CASUAL, COUNT(*) AS NO_OF_RIDES
   FROM CYCLIST_TRIP_DATA
   WHERE MEMBER_CASUAL = 'casual'
   GROUP BY CONVERT(CHAR(4), STARTED_AT, 100) + CONVERT(CHAR(4), STARTED_AT, 120),MEMBER_CASUAL

)
SELECT *
INTO dbo.YEAR_RIDES_CASUAL
FROM yr_rides_cas

--rides for members yearly
With yr_rides_mem
as
(
   select CONVERT(CHAR(4), STARTED_AT, 100) + CONVERT(CHAR(4), STARTED_AT, 120) AS MON_YEAR, 
           MEMBER_CASUAL, COUNT(*) AS NO_OF_RIDES
   FROM CYCLIST_TRIP_DATA
   WHERE MEMBER_CASUAL = 'member'
   GROUP BY CONVERT(CHAR(4), STARTED_AT, 100) + CONVERT(CHAR(4), STARTED_AT, 120),MEMBER_CASUAL

)
SELECT *
INTO dbo.YEAR_RIDES_MEMBERS
FROM yr_rides_mem


---extract daily rides
With daily_rides
as
(
   select CONCAT(day(STARTED_AT) ,' - ', month(STARTED_AT) ,' - ', year(STARTED_AT)) as DATE_MON_YEAR,
   MEMBER_CASUAL, COUNT(*) AS NO_OF_RIDES
   FROM dbo.CYCLIST_TRIP_DATA
   GROUP BY CONCAT(day(STARTED_AT) ,' - ', month(STARTED_AT) ,' - ', year(STARTED_AT)), MEMBER_CASUAL

)
SELECT *
INTO dbo.daily_RIDES
FROM daily_rides
ORDER BY NO_OF_RIDES;


--select CONCAT(day(STARTED_AT) ,' - ', month(STARTED_AT) ,' - ', year(STARTED_AT)) as DATE_MON_YEAR
--FROM dbo.CYCLIST_TRIP_DATA

--ALTER TABLE dbo.CYCLIST_TRIP_DATA  
--DROP COLUMN ride_length;

-- week rides
With week_rides
as
(
	SELECT day(STARTED_AT) as WEEKDAY, MEMBER_CASUAL, COUNT(*) AS NO_OF_RIDES
	FROM dbo.CYCLIST_TRIP_DATA
	GROUP BY day(STARTED_AT), MEMBER_CASUAL
)
SELECT *
INTO dbo.week_RIDES
FROM week_rides
ORDER BY NO_OF_RIDES DESC

-- Hours  --DATEPART(HOUR, [date])
With hourly
as
(
	SELECT DATEPART(HOUR, STARTED_AT) as HOUR, MEMBER_CASUAL, COUNT(*) AS NO_OF_RIDES
	FROM dbo.CYCLIST_TRIP_DATA
	GROUP BY DATEPART(HOUR, STARTED_AT), MEMBER_CASUAL
)
SELECT *
INTO dbo.Hour_Rides
FROM hourly
ORDER BY NO_OF_RIDES DESC

-- mins  --DATEPART(HOUR, [date])
With mins
as
(
	SELECT DATEPART(MINUTE, STARTED_AT) as Mins, MEMBER_CASUAL, COUNT(*) AS NO_OF_RIDES
	FROM dbo.CYCLIST_TRIP_DATA
	GROUP BY DATEPART(MINUTE, STARTED_AT), MEMBER_CASUAL
)
SELECT *
INTO dbo.Minute_Rides
FROM mins
ORDER BY NO_OF_RIDES DESC



-- weekdays  --DATEPART(HOUR, [date])
With mins
as
(
	SELECT DATEPART(MINUTE, STARTED_AT) as Mins, MEMBER_CASUAL, COUNT(*) AS NO_OF_RIDES
	FROM dbo.CYCLIST_TRIP_DATA
	GROUP BY DATEPART(MINUTE, STARTED_AT), MEMBER_CASUAL
)
SELECT *
INTO dbo.Minute_Rides
FROM mins
ORDER BY NO_OF_RIDES DESC