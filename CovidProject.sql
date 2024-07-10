--Looking at the tables
SELECT *
FROM CovidProject..covidDeaths060424
ORDER BY 3,4

--SELECT *
--FROM CovidProject..covidVaccinations060424
--ORDER BY 3,4

-- Select Data

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidProject..covidDeaths060424
ORDER BY 1,2

-- Looking at Total Cases vs Total Deaths

Select location, date, total_cases,total_deaths, 
(CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100 AS Deathpercentage
from CovidProject..covidDeaths060424
WHERE location like '%Brazil%'
order by 1,2

-- Percentage of population got covid

Select location, date, total_cases,population, 
(CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0)) * 100 AS Deathpercentage
from CovidProject..covidDeaths060424
WHERE location like '%Brazil%'
order by 1,2

--Highest Infection Count

SELECT 
    location,
    population,
    MAX(CAST(total_cases AS BIGINT)) AS HighestInfectionCount,
    MAX((CAST(total_cases AS FLOAT) / NULLIF(CAST(population AS FLOAT), 0)) * 100) AS DeathPercentage
FROM 
    CovidProject..covidDeaths060424
GROUP BY 
    location, population
ORDER BY 
    location, population;

--Countries with Highest Death Count per Population

SELECT 
    location,
    MAX(CAST(total_deaths AS BIGINT)) AS TotalDeathCount,
    MAX((CAST(total_deaths AS FLOAT) / NULLIF(CAST(population AS FLOAT), 0)) * 100) AS PercentageDeaths
FROM 
    CovidProject..covidDeaths060424
WHERE continent is not null
GROUP BY 
    location, population
ORDER BY 
    PercentageDeaths DESC;

--Continent Breakdown

SELECT continent, 
	   MAX(cast(total_deaths as BIGINT)) AS TotalDeathCount
From CovidProject..covidDeaths060424
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC

--Continents With Highest Death Count

SELECT continent, MAX(CAST(total_deaths AS BIGINT)) AS TotalDeathCount
FROM CovidProject..covidDeaths060424
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC;

SELECT continent, MAX(CAST(total_deaths AS BIGINT)) AS TotalDeathCount
FROM CovidProject..covidDeaths060424
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC;

-- Global Numbers

SELECT 
   -- CONVERT(DATE, date, 101) AS Date, 
    SUM(CAST(new_cases AS BIGINT)) AS TotalCases, 
    SUM(CAST(new_deaths AS BIGINT)) AS TotalDeaths, 
    (SUM(CAST(new_deaths AS FLOAT)) / NULLIF(SUM(CAST(new_cases AS FLOAT)), 0)) * 100 AS DeathPercentage
FROM 
    CovidProject..covidDeaths060424
WHERE 
    continent IS NOT NULL
	AND new_cases <> '0' 
    AND new_deaths <> '0'
--GROUP BY 
  --  CONVERT(DATE, date, 101)
ORDER BY 
   1,2;

--Using a CTE

WITH PopvsVAC (continent, location, date, population, New_vaccinations, RollingPeopleVaccinated, VaccinationPercentage)
AS
(
    SELECT dea.continent, 
           dea.location, 
           CONVERT(DATE, dea.date, 101) AS date, 
           dea.population, 
           vac.new_vaccinations,
           SUM(CAST(vac.new_vaccinations AS BIGINT)) OVER (Partition by dea.location ORDER BY dea.location, CONVERT(DATE, dea.date, 101)) AS RollingPeopleVaccinated,
           (SUM(CAST(vac.new_vaccinations AS BIGINT)) OVER (Partition by dea.location ORDER BY dea.location, CONVERT(DATE, dea.date, 101)) / CAST(dea.population AS FLOAT)) * 100 AS VaccinationPercentage
    FROM CovidProject..covidDeaths060424 dea
    JOIN CovidProject..covidVaccinations060424 vac
        ON dea.location = vac.location
        AND dea.date = vac.date
      WHERE dea.continent is not null
      AND dea.continent <> ''
)

SELECT *
FROM PopvsVAC
ORDER BY location, date;

--Creating View
Create View PercentPopulationVaccinated AS
SELECT dea.continent, 
           dea.location, 
           CONVERT(DATE, dea.date, 101) AS date, 
           dea.population, 
           vac.new_vaccinations,
           SUM(CAST(vac.new_vaccinations AS BIGINT)) OVER (Partition by dea.location ORDER BY dea.location, CONVERT(DATE, dea.date, 101)) AS RollingPeopleVaccinated,
           (SUM(CAST(vac.new_vaccinations AS BIGINT)) OVER (Partition by dea.location ORDER BY dea.location, CONVERT(DATE, dea.date, 101)) / CAST(dea.population AS FLOAT)) * 100 AS VaccinationPercentage
    FROM CovidProject..covidDeaths060424 dea
    JOIN CovidProject..covidVaccinations060424 vac
        ON dea.location = vac.location
        AND dea.date = vac.date
    WHERE dea.continent is not null
      AND dea.continent <> ''

