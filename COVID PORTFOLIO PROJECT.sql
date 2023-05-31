SELECT *
FROM PortfolioProject..[covid-deaths]
where continent is not null
order by 3, 4;

--SELECT *
--FROM PortfolioProject..CovidVaccinations
--order by 3, 4;
--data to use

SELECT location, date,total_cases, new_cases, total_deaths, population
FROM PortfolioProject..[covid-deaths]
order by 1,2

--totalcases vs total deaths


 SELECT CONVERT(bigint, total_cases)as total_cases, CONVERT(bigint, total_deaths) as total_deaths
 FROM PortfolioProject..[covid-deaths]

 SELECT location, date,total_deaths, total_cases, CONVERT(float, total_deaths)/CONVERT(float, total_cases)* 100 as deathpercentage
FROM PortfolioProject..[covid-deaths]
WHERE location like '%States%'
order by 1,2

----total cases vs population
SELECT location, date, total_cases,population, CONVERT(float, total_cases)/CONVERT(float, population)* 100 as CovidpercentagePopulation
FROM PortfolioProject..[covid-deaths]
WHERE location like '%States%'
order by 1,2

--- Country with highest covid rates
SELECT location, MAX(total_cases) as highestInfectionCount, population, MAX(CONVERT(float, total_cases)/CONVERT(float, population))* 100 as HighestCovidpercentage
FROM PortfolioProject..[covid-deaths]
--WHERE location like '%States%'
Group by location, population
order by  HighestCovidpercentage desc


---countries with highest death count per population
SELECT location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..[covid-deaths]
--WHERE location like '%States%'
where continent is not null
Group by location
order by TotalDeathCount 

----breakdown by continent
---continents with highest death count
SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..[covid-deaths]
--WHERE location like '%States%'
where continent is not null
Group by continent
order by TotalDeathCount desc

-- GLOBAL NUMBERS
SELECT  SUM(new_deaths) as total_deaths, SUM(new_cases) as total_cases, (SUM(new_deaths)/sum(new_cases))*100 as deathpercentage
FROM PortfolioProject..[covid-deaths]
---WHERE location like '%States%'
where continent is not null
---Group by date
order by 1,3

---total population vs vaccinations
 
 select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(bigint,vac.new_vaccinations))    OVER (Partition by
 dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
 From PortfolioProject..[covid-deaths] dea
      join PortfolioProject..CovidVaccinations vac
	    on dea.location = vac.location
		and dea.date = vac.date
where dea.continent is not null
order by 2, 3

 --USE CTE 
 With PopvsVac (Continent, Location, date, population, New_Vaccinations, RollingPeopleVaccinated) 
 as
 (
 select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(bigint,vac.new_vaccinations))    OVER (Partition by
 dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
 From PortfolioProject..[covid-deaths] dea
      join PortfolioProject..CovidVaccinations vac
	    on dea.location = vac.location
		and dea.date = vac.date
where dea.continent is not null
--order by 2, 3
)
select *, (RollingPeopleVaccinated/population)*100 from PopvsVac

---TEMP TABLE
--Drop table if exists nameof table
Create Table #PercentPopulqationVaccinated
(
Continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulqationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(bigint,vac.new_vaccinations))    OVER (Partition by
 dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
 From PortfolioProject..[covid-deaths] dea
      join PortfolioProject..CovidVaccinations vac
	    on dea.location = vac.location
		and dea.date = vac.date
--where dea.continent is not null
--order by 2, 
select *, (RollingPeopleVaccinated/population)*100 from  #PercentPopulqationVaccinated

---create view for visualization
Create View  PercentPopulqationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(bigint,vac.new_vaccinations))    OVER (Partition by
 dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
 From PortfolioProject..[covid-deaths] dea
      join PortfolioProject..CovidVaccinations vac
	    on dea.location = vac.location
		and dea.date = vac.date
	where dea.continent is not null

Create View GlobalNumbers as
	SELECT  SUM(new_deaths) as total_deaths, SUM(new_cases) as total_cases, (SUM(new_deaths)/sum(new_cases))*100 as deathpercentage
FROM PortfolioProject..[covid-deaths]
---WHERE location like '%States%'
where continent is not null

