/*

Queries used for Tableau Covid Project

*/



-- 1. Death Percentage

SELECT 
    SUM(CAST(new_cases AS float)) AS total_cases, 
    SUM(CAST(new_deaths AS float)) AS total_deaths, 
    (SUM(CAST(new_deaths AS float)) * 100.0 / NULLIF(SUM(CAST(new_cases AS float)), 0)) AS DeathPercentage
FROM 
    CovidProject..covidDeaths060424
--WHERE 
    --continent IS NOT NULL 
--GROUP BY 
  --  date
ORDER BY 
    total_cases, total_deaths;


--1.1 "International"  Location


SELECT 
    SUM(CAST(new_cases AS float)) AS total_cases, 
    SUM(CAST(new_deaths AS float)) AS total_deaths, 
    (SUM(CAST(new_deaths AS float)) * 100.0 / NULLIF(SUM(CAST(new_cases AS float)), 0)) AS DeathPercentage
FROM 
    CovidProject..covidDeaths060424
WHERE 
    location = 'World'
--GROUP BY 
  --  date
ORDER BY 
    total_cases, total_deaths;


-- 2. TotalDeathCount by Regions


SELECT 
    location, 
    SUM(CAST(new_deaths AS INT)) AS TotalDeathCount
FROM 
    CovidProject..covidDeaths060424
WHERE 
    continent = '' 
    AND location NOT IN ('World', 'European Union', 'International', 'High income', 'Upper middle income', 'Lower middle income', 'Low income')
GROUP BY 
    location
ORDER BY 
    TotalDeathCount DESC;


-- 3. HighestInfectionCount Percentage Population

SELECT 
    location, 
    population, 
    MAX(CAST(total_cases AS INT)) AS HighestInfectionCount,  
    MAX((CAST(total_cases AS FLOAT) / CAST(population AS FLOAT)) * 100) AS PercentPopulationInfected
FROM 
    CovidProject..covidDeaths060424
--WHERE 
    --location LIKE '%states%'
GROUP BY 
    location, 
    population
ORDER BY 
    PercentPopulationInfected DESC;

-- 4. PercentPopulationInfected

SELECT 
    location, 
    population,
    CAST(date AS DATE) AS date, 
    MAX(CAST(total_cases AS FLOAT)) AS HighestInfectionCount,  
    MAX((CAST(total_cases AS FLOAT) / CAST(population AS FLOAT)) * 100) AS PercentPopulationInfected
FROM 
    CovidProject..covidDeaths060424
--WHERE 
    --location LIKE '%states%'
GROUP BY 
    location, 
    population, 
    CAST(date AS DATE)
ORDER BY 
    PercentPopulationInfected DESC;









