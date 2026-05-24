# World Life Expectancy Project (Data Cleaning)

# Checking/removing duplicate

SELECT country, year, COUNT(*) AS count
FROM world_life_expectancy
GROUP BY Country, Year
HAVING count > 1;

SELECT *
FROM (
	SELECT Row_ID, country, year,
	ROW_NUMBER() OVER(PARTITION BY country, year) AS row_num
	FROM world_life_expectancy
	) AS row_table
WHERE row_num > 1;

DELETE FROM world_life_expectancy
WHERE
	Row_ID IN (
	SELECT Row_ID
FROM (
	SELECT Row_ID, country, year,
	ROW_NUMBER() OVER(PARTITION BY country, year) AS row_num
	FROM world_life_expectancy
	) AS row_table
WHERE row_num > 1);

# Missing values

SELECT *
FROM world_life_expectancy
WHERE Status = '';

SELECT DISTINCT(Status)
FROM world_life_expectancy
WHERE Status != '';

SELECT DISTINCT(Country)
FROM world_life_expectancy
WHERE Status = 'Developing';

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.country
SET t1.Status = 'Developing'
WHERE t1.Status = ''
AND t2.Status != ''
AND t2.Status = 'Developing';
    
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.country
SET t1.Status = 'Developed'
WHERE t1.Status = ''
AND t2.Status != ''
AND t2.Status = 'Developed';

SELECT *
FROM world_life_expectancy;

SELECT *
FROM world_life_expectancy
WHERE `Life expectancy` = '';

SELECT t1.Country, t1.Year, t1.`Life expectancy`,
t2.Country, t2.Year, t2.`Life expectancy`,
t3.Country, t3.Year, t3.`Life expectancy`,
ROUND((t2.`Life expectancy` + t3.`Life expectancy`) / 2, 1)
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
WHERE t1.`Life expectancy` = '';

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
SET t1.`Life expectancy` = ROUND((t2.`Life expectancy` + t3.`Life expectancy`) / 2, 1)
WHERE t1.`Life expectancy` = '';