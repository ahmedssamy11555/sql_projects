SELECT * FROM ProtifolioProject..covid_death

SELECT * FROM ProtifolioProject..covid_vaccinations


-- Select the Used Data.

SELECT Location,date,total_cases,new_cases, total_deaths, population
FROM ProtifolioProject..covid_death
ORDER BY 1,2

-- Looking at total cases verses total deaths.
-- Showing the likelihood of dying in your egypt.
SELECT Location,date,total_cases,new_cases,(total_deaths/total_cases)* 100 AS death_percentage
FROM ProtifolioProject..covid_death
WHERE location LIKE 'egypt'
ORDER BY 1,2



-- Looking at total cases verses the population.
-- Shows what percentage of populaion got covid
SELECT Location,date,population,total_cases,(total_cases/population)* 100 AS percent_of_population_infected
FROM ProtifolioProject..covid_death
-- WHERE location LIKE 'egypt'
ORDER BY 1,2

-- Looking at the country with highest infection rates verses population.

SELECT Location,population,MAX(total_cases) AS highest_infection_count,MAX((total_cases/population))* 100 AS percent_of_population_infected
FROM ProtifolioProject..covid_death
GROUP BY population,location
-- WHERE location LIKE 'egypt'
ORDER BY percent_of_population_infected DESC


-- showing countries with the highest death count per population.
-- breaking things by continent
SELECT location,MAX(cast(total_deaths as int)) AS total_death_count
FROM ProtifolioProject..covid_death
WHERE continent IS NULL
GROUP BY location
ORDER BY total_death_count DESC

-- Global numbers.
SELECT SUM(new_cases) AS total_cases,SUM(cast(new_deaths as int)) AS total_deaths,SUM(cast(new_deaths as int))/SUM(new_cases)*100 AS total_world_deaths
FROM ProtifolioProject..covid_death
-- WHERE location LIKE 'egypt'
WHERE continent IS NOT NULL
-- GROUP BY date
ORDER BY 1,2



--Looking at total population verses vaccination
-- using CTA

with PopvsVac(continent,location,date,population,new_vaccinations,rolling_people_vaccinated)
as(
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(CONVERT(BIGINT,vac.new_vaccinations)) OVER (partition by dea.Location ORDER BY dea.Location,dea.date) AS
rolling_people_vaccinated
FROM ProtifolioProject..covid_death dea
JOIN ProtifolioProject..covid_vaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
-- ORDER BY 1,2
)
SELECT *,(rolling_people_vaccinated/population)*100
FROM PopvsVac

-- Creating views

CREATE VIEW percent_population_vaccinated AS
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(CONVERT(BIGINT,vac.new_vaccinations)) OVER (partition by dea.Location ORDER BY dea.Location,dea.date) AS
rolling_people_vaccinated
FROM ProtifolioProject..covid_death dea
JOIN ProtifolioProject..covid_vaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
-- ORDER BY 1,2













