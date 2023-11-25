use victor;

SELECT 
    *
FROM
    flights;

SELECT 
    COUNT(*) AS total_rows
FROM
    flights;

SELECT 
    *
FROM
    flights
WHERE
    origin IS NOT NULL;


alter table flights
add primary key (id);

-- i replaced the numeric values of the month with their corresponding names
-- i have already modified datatype from int to text using editor mysql workbench
UPDATE flights 
SET 
    month = CASE
        WHEN month = 1 THEN 'January'
        WHEN month = 2 THEN 'February'
        WHEN month = 3 THEN 'March'
        WHEN month = 4 THEN 'April'
        WHEN month = 5 THEN 'May'
        WHEN month = 6 THEN 'June'
        WHEN month = 7 THEN 'July'
        WHEN month = 8 THEN 'August'
        WHEN month = 9 THEN 'September'
        WHEN month = 10 THEN 'October'
        WHEN month = 11 THEN 'November'
        WHEN month = 12 THEN 'December'
    END;

-- replaced short name of aeroports with normal name   
UPDATE flights 
SET 
    origin = CASE
        WHEN origin = 'EWR' THEN 'Newark Liberty International Airport'
        WHEN origin = 'JFK' THEN 'John F. Kennedy International Airport'
        WHEN origin = 'LGA' THEN 'LaGuardia Airport'
        ELSE origin
    END,
    dest = CASE
        WHEN dest = 'EWR' THEN 'Newark Liberty International Airport'
        WHEN dest = 'JFK' THEN 'John F. Kennedy International Airport'
        WHEN dest = 'LGA' THEN 'LaGuardia Airport'
        ELSE dest
    END;

-- ====================================================================================
-- ====   A report to analyze the performance of airlines in 2013  =====
-- 1. Analysis of time patterns and trends: by examining the departure and arrival time of the aircraft, 
-- changes and time changes, patterns and trends in flight behavior can be identified.
-- ==============================================================================================================

SELECT 
    month, COUNT(*) AS count_of_flights_by_month
FROM
    flights
GROUP BY month
ORDER BY count_of_flights_by_month DESC;

-- distribution of flights by day
SELECT 
    day, COUNT(*) AS count_of_flights_by_day
FROM
    flights
GROUP BY day
ORDER BY count_of_flights_by_day DESC;

-- distribution of flights by hour
SELECT 
    hour, COUNT(*) AS count_of_flights_by_hour
FROM
    flights
GROUP BY hour
ORDER BY count_of_flights_by_hour DESC;


-- the peak month, day, and hour with the highest number of flights
-- using subquery 
SELECT 
    month AS month_name, day, hour, total_flights
FROM
    (SELECT 
        month, day, hour, COUNT(*) AS total_flights
    FROM
        flights
    GROUP BY month , day , hour) AS subquery
ORDER BY total_flights DESC
LIMIT 1;

-- ==========================================================================================
-- 2. Analysis of American companies: By viewing information about airlines such as the number of flights, the impact and
-- overall performance, comparition and analyzing the performance of each company.
-- ============================================================================================
-- Number of Flights by Airline:
SELECT 
    name, COUNT(flight) AS count_flights
FROM
    flights
GROUP BY name
ORDER BY count_flights DESC;

-- Impact Analysis - Average Departure and Arrival Delays
SELECT 
    name,
    ROUND(AVG(dep_delay), 2) AS average_departure_delay_min,
    ROUND(AVG(arr_delay), 2) AS average_arriving_delay_min,
    ROUND(AVG(arr_delay + dep_delay), 2) AS average_total_delay_min
FROM
    flights
GROUP BY name
ORDER BY average_total_delay_min DESC;

-- Calculating the percentage of on-time arrivals for each airline
SELECT 
    name,
    ROUND(SUM(CASE
                WHEN arr_delay <= 0 THEN 1
            END) / COUNT(arr_delay) * 100,
            2) AS `on_time_arrival_rate_%`
FROM
    flights
GROUP BY name
ORDER BY `on_time_arrival_rate_%` DESC;

-- ====================================================================================================
-- Analysis of delays and service quality: By examining delays and arrival time, collecting 
-- and analyze information about the quality of services provided by the airport and companies.
-- ========================================================================================================
-- Examine the distribution of arrival delays.
SELECT 
    arr_delay AS arriving_delay_min, COUNT(*) AS num_fly
FROM
    flights
GROUP BY arr_delay
ORDER BY arr_delay DESC;

-- Examine the distribution of departure delays.
SELECT 
    dep_delay AS departure_delay_min, COUNT(*) AS num_fly
FROM
    flights
GROUP BY dep_delay
ORDER BY dep_delay DESC;

-- ======================================================================================
-- Analysis of flight routes: by checking the origin and destination of flights, distances and
-- flight duration, popular routes and people's choices can be identified and analyzed.
-- ======================================================================================
-- Popular Routes by Frequency:
-- most popular flight routes based on the number of flights
SELECT 
    origin, dest, COUNT(*) num_flight
FROM
    flights
GROUP BY origin , dest
ORDER BY num_flight DESC;

-- Calculate the average distance and flight duration for each route.
SELECT 
    origin,
    dest,
    ROUND(AVG(distance), 2) AS average_distance_miles,
    ROUND(AVG(air_time), 2) AS average_flight_duration_minutes
FROM
    flights
GROUP BY origin , dest
ORDER BY average_flight_duration_minutes DESC;

-- longest and shortest flight routes by name.
SELECT 
    name,
    MAX(distance) AS max_distance_miles,
    MIN(distance) AS min_distance_miles
FROM
    flights
GROUP BY name
ORDER BY max_distance_miles DESC;


-- =========================================================================
--  busiest airports based on the total number of flights
SELECT 
    origin, COUNT(*) AS num_flights
FROM
    flights
GROUP BY origin
ORDER BY num_flights DESC;


-- on-time performance, average delays, and overall airport ranking
SELECT
    origin AS airport,
    COUNT(*) OVER (PARTITION BY origin) AS total_flights,
    COUNT(CASE WHEN arr_delay <= 0 THEN 1 END) OVER (PARTITION BY origin) /
        COUNT(*) OVER (PARTITION BY origin) * 100 AS on_time_arrival_rate,
    AVG(dep_delay) OVER (PARTITION BY origin) AS avg_departure_delay,
    AVG(arr_delay) OVER (PARTITION BY origin) AS avg_arrival_delay
FROM
    flights
ORDER BY
    total_flights DESC;


    
 















