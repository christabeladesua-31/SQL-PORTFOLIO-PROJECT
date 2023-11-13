select *
from [SQL PORTFOLIO PROJECT]..[covid deaths ]
where continent is not null
order by 3,4

--select *
--from [SQL PORTFOLIO PROJECT]..[covid vaccination]
--order by 3,4

select location,date, total_cases, new_cases, total_deaths, population
from [SQL PORTFOLIO PROJECT]..[covid deaths ]
order by 1,2

select location, date, total_cases,total_deaths, (CONVERT(float,total_deaths)/
nullif(convert(float, total_cases), 0))*100 as DeathPercentage
from [SQL PORTFOLIO PROJECT]..[covid deaths ]
where location like '%afghanistan%'
and continent is not null
order by 1,2

select location, date, total_cases,population, (CONVERT(float, population)/
nullif(convert(float, total_cases), 0))*100 as DeathPercentage
from [SQL PORTFOLIO PROJECT]..[covid deaths ]
order by 1,2

select location, max(total_cases) as HighestInfectionCount,population,
MAX((total_cases/population)) *100 as PercentPopulationInfected
from [SQL PORTFOLIO PROJECT]..[covid deaths ]
group by location, population
order by PercentPopulationInfected desc


select location, max(cast(total_cases as int)) as totaldeathcount
from [SQL PORTFOLIO PROJECT]..[covid deaths ]
where continent is not null
group by location
order by totaldeathcount desc

select location, max(cast(total_cases as int)) as totaldeathcount
from [SQL PORTFOLIO PROJECT]..[covid deaths ]
where continent is not null
group by location
order by totaldeathcount desc

select continent, max(cast(total_cases as int)) as totaldeathcount
from [SQL PORTFOLIO PROJECT]..[covid deaths ]
where continent is not null
group by continent
order by totaldeathcount desc

select continent, max(cast(total_cases as int)) as totaldeathcount
from [SQL PORTFOLIO PROJECT]..[covid deaths ]
where continent is not null
group by continent
order by totaldeathcount desc

select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths,
sum(cast(new_deaths as int))/nullif(sum(new_cases),0)*100 as deathpercentage
from [SQL PORTFOLIO PROJECT]..[covid deaths ]
where continent is not null
group by date
order by 1,2

select *
from [SQL PORTFOLIO PROJECT]..[covid vaccination ] vac
join [SQL PORTFOLIO PROJECT]..[covid deaths ] dea
    on dea.location = vac.location
	and dea.date =vac.date

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from [SQL PORTFOLIO PROJECT]..[covid vaccination ] vac
join [SQL PORTFOLIO PROJECT]..[covid deaths ] dea
    on dea.location = vac.location
	and dea.date =vac.date
where dea.continent is not null
order by 2,3

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(bigint, vac.new_vaccinations)) over (partition by dea.location order by 
  dea.location, dea.date) as peoplevaccinated
from [SQL PORTFOLIO PROJECT]..[covid vaccination ] vac
join [SQL PORTFOLIO PROJECT]..[covid deaths ] dea
    on dea.location = vac.location
	and dea.date =vac.date
where dea.continent is not null
order by 2,3

with popvsvac (continent, location, date, population, new_vaccinations, peoplevaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(bigint, vac.new_vaccinations)) over (partition by dea.location order by 
dea.location, dea.date) as peoplevaccinated
from [SQL PORTFOLIO PROJECT]..[covid vaccination ] vac
join [SQL PORTFOLIO PROJECT]..[covid deaths ] dea
    on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
)
select *, (peoplevaccinated/population)*100
from popvsvac


drop table if exists #percentpeoplevaccinated
create table #percentpeoplevaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
peoplevaccinated numeric
)


insert into #percentpeoplevaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(bigint, vac.new_vaccinations)) over (partition by dea.location order by 
dea.location, dea.date) as peoplevaccinated
from [SQL PORTFOLIO PROJECT]..[covid vaccination ] vac
join [SQL PORTFOLIO PROJECT]..[covid deaths ] dea
    on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null

select *, (peoplevaccinated/population)*100
from #percentpeoplevaccinated

create view percentpeoplevaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(bigint, vac.new_vaccinations)) over (partition by dea.location order by 
dea.location, dea.date) as peoplevaccinated
from [SQL PORTFOLIO PROJECT]..[covid vaccination ] vac
join [SQL PORTFOLIO PROJECT]..[covid deaths ] dea
    on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
