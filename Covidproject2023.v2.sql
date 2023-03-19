-- Select the schema to use
USE covidproject2023;

-- Verifycation of permisitions to upload data
set global local_infile=1;

SHOW GLOBAL VARIABLES LIKE 'local_infile';

-- Creation of the covidvaccinations table 
CREATE TABLE covidvaccinations (
    iso_code VARCHAR(250),
    continent VARCHAR(250),
    location VARCHAR(250),
    date VARCHAR(250),
    total_tests INT,
    new_tests INT,
    total_tests_per_thousand DECIMAL(13 , 3 ),
    new_tests_per_thousand DECIMAL(13 , 3 ),
    new_tests_smoothed INT,
    new_tests_smoothed_per_thousand DECIMAL(13 , 3 ),
    positive_rate DECIMAL(13 , 3 ),
    tests_per_case DECIMAL(13 , 3 ),
    tests_units VARCHAR(250),
    total_vaccinations INT,
    people_vaccinated INT,
    people_fully_vaccinated INT,
    total_boosters INT,
    new_vaccinations INT,
    new_vaccinations_smoothed INT,
    total_vaccinations_per_hundred DECIMAL(13 , 3 ),
    people_vaccinated_per_hundred DECIMAL(13 , 3 ),
    people_fully_vaccinated_per_hundred DECIMAL(13 , 3 ),
    total_boosters_per_hundred DECIMAL(13 , 3 ),
    new_vaccinations_smoothed_per_million INT,
    new_people_vaccinated_smoothed INT,
    new_people_vaccinated_smoothed_per_hundred DECIMAL(13 , 3 ),
    stringency_index DECIMAL(13 , 3 ),
    population_density DECIMAL(13 , 3 ),
    median_age DECIMAL(13 , 3 ),
    aged_65_older DECIMAL(13 , 3 ),
    aged_70_older DECIMAL(13 , 3 ),
    gdp_per_capita DECIMAL(13 , 3 ),
    extreme_poverty DECIMAL(13 , 3 ),
    cardiovasc_death_rate DECIMAL(13 , 3 ),
    diabetes_prevalence DECIMAL(13 , 3 ),
    female_smokers DECIMAL(13 , 3 ),
    male_smokers DECIMAL(13 , 3 ),
    handwashing_facilities DECIMAL(13 , 3 ),
    hospital_beds_per_thousand DECIMAL(13 , 3 ),
    life_expectancy DECIMAL(13 , 3 ),
    human_development_index DECIMAL(13 , 3 ),
    excess_mortality_cumulative_absolute DECIMAL(13 , 4 ),
    excess_mortality_cumulative DECIMAL(13 , 4 ),
    excess_mortality DECIMAL(13 , 3 ),
    excess_mortality_cumulative_per_million DECIMAL(13 , 4 )
);

-- Loding data to the schema
load data local infile 'C:/Users/ehanz/OneDrive/Documents/data_analysis/Covid/CovidVaccinations.V2.csv'
into table covidvaccinations
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

-- Verification of the amount of rows loaded
SELECT 
    COUNT(*)
FROM
    covidvaccinations;
 
-- Verification of the informacion load
SELECT *
from covidvaccinations
order by location, date;

-- Creation of the coviddeaths table 
CREATE TABLE coviddeaths (
    iso_code VARCHAR(50),
    continent VARCHAR(50),
    location VARCHAR(100),
    datadate VARCHAR(100),
    population INT,
    total_cases INT,
    new_cases DECIMAL(13 , 3 ),
    new_cases_smoothed DECIMAL(13 , 3 ),
    total_deaths INT,
    new_deaths INT,
    new_deaths_smoothed DECIMAL(13 , 3 ),
    total_cases_per_million DECIMAL(13 , 3 ),
    new_cases_per_million DECIMAL(13 , 3 ),
    new_cases_smoothed_per_million DECIMAL(13 , 3 ),
    total_deaths_per_million DECIMAL(13 , 3 ),
    new_deaths_per_million DECIMAL(13 , 3 ),
    new_deaths_smoothed_per_million DECIMAL(13 , 3 ),
    reproduction_rate DECIMAL(13 , 2 ),
    icu_patients INT,
    icu_patients_per_million DECIMAL(13 , 3 ),
    hosp_patients INT,
    hosp_patients_per_million DECIMAL(13 , 3 ),
    weekly_icu_admissions INT,
    weekly_icu_admissions_per_million DECIMAL(13 , 3 ),
    weekly_hosp_admissions INT,
    weekly_hosp_admissions_per_million DECIMAL(13 , 3 )
);

-- Loding data to the schema
load data local infile 'C:/Users/ehanz/OneDrive/Documents/data_analysis/Covid/CovidDeaths.V2.csv'
into table coviddeaths
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

-- Verification of the amount of rows loaded
SELECT 
    COUNT(*)
FROM
    coviddeaths;
    
-- Verification of the informacion load    
SELECT 
    *
FROM
    coviddeaths
order by location, date;

--- PROBLEM ENCOUNTER: HOW TO CHANGE THE VARIABLE OF A HOLE COLUM FROM VARCHAR(100) TO DATE 

-- Information searched by Location

-- Select data that we are going to use
select location, date, total_cases, new_cases, total_deaths, population
from coviddeaths
order by location, date;

-- Looking at total cases vs total deaths
-- Show how likelihood someone could day in each country
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentaje
from coviddeaths
where location like '%states%'
order by location, date;

-- Looking the total cases vs total population
-- Percentage of population infected
select location, date, population, total_cases, (total_cases/population)*100 as PercentajePopulationInfected
from coviddeaths
where location like '%states%'
and continent is not null
order by location, date;

-- Countries with highest infection rate vs population
select location, population, max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as PercentajePopulationInfected
from coviddeaths
where continent is not null
group by location, population
order by PercentajePopulationInfected desc;

-- Countries with the highest death count population
select location, max(total_deaths) as TotalDeathsCount
from coviddeaths
where continent is not null
group by location
order by TotalDeathsCount desc;

-- Change the "blank" data in the continent column to the locations that agroup continents
UPDATE coviddeaths 
SET continent = NULL 
WHERE continent = '
';

-- Information searched by Continent
-- Continents with the highest death count

select location, max(total_deaths) as TotalDeathsCount
from coviddeaths
where continent is null
-- and location <> 'world'
and location <> 'high income'
and location <> 'upper middle income'
and location <> 'lower middle income'
and location <> 'low income'
group by location
order by TotalDeathsCount desc;

-- Global Numbers

-- Blogal deaths percentaje by date
select date, SUM(new_cases) as TotalCases, sum(new_deaths) as TotalDeaths, sum(new_deaths)/sum(new_cases)*100 as DeathsPercentaje
from coviddeaths
where continent is null
and location <> 'world'
and location <> 'high income'
and location <> 'upper middle income'
and location <> 'lower middle income'
and location <> 'low income'
group by date
order by 1, 2;

-- Total global deaths percentaje
select SUM(new_cases) as TotalCases, sum(new_deaths) as TotalDeaths, sum(new_deaths)/sum(new_cases)*100 as DeathsPercentaje
from coviddeaths
where continent is null
and location <> 'world'
and location <> 'high income'
and location <> 'upper middle income'
and location <> 'lower middle income'
and location <> 'low income';

-- Total vaccionation vs vaccionations (with the use of cte for RollingPeopleVaccinated)
with PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from coviddeaths as dea
join covidvaccinations as vac
	on dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not null
and dea.location <> 'world'
and dea.location <> 'high income'
and dea.location <> 'upper middle income'
and dea.location <> 'lower middle income'
and dea.location <> 'low income'
order by dea.location, dea.date
)
select *, (RollingPeopleVaccinated/population)*100
from PopvsVac;

-- Creating view to store for later visualizacion

create view RollingPeopleVaccinated as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from coviddeaths as dea
join covidvaccinations as vac
	on dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not null
and dea.location <> 'world'
and dea.location <> 'high income'
and dea.location <> 'upper middle income'
and dea.location <> 'lower middle income'
and dea.location <> 'low income'
order by dea.location, dea.date;