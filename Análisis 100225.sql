-- Agregar columna ride_length
ALTER TABLE `202412-divvy-tripdata`  
drop COLUMN ride_lenght;
-- Duración de los viajes
SELECT 
    ride_id, 
    rideable_type, 
    started_at, 
    ended_at, 
    start_station_name, 
    start_station_id, 
    end_station_name, 
    end_station_id, 
    start_lat, 
    start_lng, 
    end_lat, 
    end_lng, 
    member_casual,
    -- Calcular la duración del viaje en formato HH:MM:SS
    TIMEDIFF(ended_at, started_at) AS ride_length,
    dayname(started_at) as day_of_week
FROM `202412-divvy-tripdata` limit 50000;
SET SQL_SAFE_UPDATES = 0;
UPDATE `202412-divvy-tripdata`  
SET ride_length = TIMEDIFF(ended_at, started_at);
-- Agregar columna  member_casual 
SELECT 
    member_casual, 
    COUNT(*) AS total_trips
FROM `202412-divvy-tripdata`
GROUP BY member_casual;
-- Cantidad de viajes por día
SELECT 
    DAYNAME(started_at) AS day_of_week, 
    COUNT(*) AS total_viajes
FROM `202412-divvy-tripdata`
GROUP BY day_of_week
ORDER BY FIELD(day_of_week, 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday');
-- Agregar day_of_week en una columna permanente
ALTER TABLE `202412-divvy-tripdata`  
ADD COLUMN day_of_week VARCHAR(10);
SET SQL_SAFE_UPDATES = 0;  -- Desactiva el modo seguro
UPDATE `202412-divvy-tripdata`  
SET day_of_week = DAYNAME(started_at);  
SET SQL_SAFE_UPDATES = 1;  -- Vuelve a activarlo después del UPDATE

select * from `202412-divvy-tripdata`;
-- Duración media de los viajes
SELECT 
    SEC_TO_TIME(AVG(TIMESTAMPDIFF(SECOND, started_at, ended_at))) AS mean_duration
FROM `202412-divvy-tripdata`;
-- Duración media de viajeros casuales y miembros
SELECT 
    member_casual, 
    SEC_TO_TIME(AVG(TIMESTAMPDIFF(SECOND, started_at, ended_at))) AS mean_duration
FROM `202412-divvy-tripdata`
GROUP BY member_casual;
-- Duración media por día de la semana
SELECT 
    DAYNAME(started_at) AS day_of_week, 
    SEC_TO_TIME(AVG(TIMESTAMPDIFF(SECOND, started_at, ended_at))) AS duracion_media
FROM `202412-divvy-tripdata`
GROUP BY day_of_week
ORDER BY FIELD(day_of_week, 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday');

UPDATE `202412-divvy-tripdata`
SET ride_length = TIME(ride_length);

ALTER TABLE `202412-divvy-tripdata`
MODIFY COLUMN ride_length TIME;

UPDATE `202412-divvy-tripdata`
SET ride_length = TIMEDIFF(ended_at, started_at);

