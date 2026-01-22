---
title: Global COVID-19 
---

COVID-19 has affected every country worldwide, with millions of infections, hospitalizations, and deaths reported since 2020.  
This dashboard provides a clear overview of the pandemic’s impact by country and year.  


- **Infections** → Reported cases  
- **Incidence** → Cases per 100k people  
- **Vaccinations** → Doses administered  
- **Deaths** → Reported deaths 


```sql countries
select distinct country from cvd.covid order by country
```


<Dropdown name=year>
  <DropdownOption value=% valueLabel="All Years"/>
  <DropdownOption value=2020 />
  <DropdownOption value=2021 />
  <DropdownOption value=2022 />
  <DropdownOption value=2023 />
  <DropdownOption value=2024 />
  <DropdownOption value=2025 />
</Dropdown>

<Dropdown data={countries} name=country value=country defaultValue="Germany" /> 
<Dropdown name=metric>
  <DropdownOption value="infections" valueLabel="Infections"/> 
  <DropdownOption value="incidence" valueLabel="Incidence"/>
  <DropdownOption value="vaccinations" valueLabel="Vaccinations"/>
  <DropdownOption value="deaths" valueLabel="Deaths"/> 
</Dropdown>

```sql covid_metrics
  select
    country,
  year,
    infections,
    incidence,
    vaccinations,
    deaths
  from cvd.covid
  where
    country = '${inputs.country.value}'
  and (
        '${inputs.year.value}' = '%'
  or year = cast('${inputs.year.value}' as int)
)
```

<BarChart 
  data={covid_metrics} 
  title="COVID-19 {inputs.metric.label} in {inputs.country.value}" 
  x=year 
  y={inputs.metric.value} />
 


```sql map_data
select
  case
    when country = 'United States' then 'United States of America'
    when country = 'Russia' then 'Russian Federation'
    when country = 'South Korea' then 'Korea, Republic of'
    else country
  end as country,   

  country as country_db,    

  sum(infections) as infections,
  sum(incidence) as incidence,
  sum(vaccinations) as vaccinations,
  sum(deaths) as deaths,

   -- Highlight-Spalte: nur beim gewählten Land > 0
  case 
    when country = '${inputs.country.value}' then sum(
      case 
        when '${inputs.metric.value}' = 'infections' then infections
        when '${inputs.metric.value}' = 'incidence' then incidence
        when '${inputs.metric.value}' = 'vaccinations' then vaccinations
        when '${inputs.metric.value}' = 'deaths' then deaths
      end
    )
    else 0
  end as highlight_value,

  '/country/' || country || '?metric=' || '${inputs.metric.value}' as link

from cvd.covid
where
  ('${inputs.year.value}' = '%' or year = cast('${inputs.year.value}' as int))
group by country
```
Explore country-level COVID-19 trends through interactive visualizations.

Zoom into the map and click on a country to access a detailed overview of its key metrics.

<AreaMap
  data={map_data}
  geoJsonUrl="https://raw.githubusercontent.com/datasets/geo-countries/master/data/countries.geojson"
  areaCol="country"
  geoId="name"
  value="highlight_value"
  title="COVID-19 Map"
  link=link
  colorScheme={["#ffffff", "#1f77b4"]}
  borders={true}
  borderColor="#333333"
  borderWidth=0.5
  tooltip={[
    { id: "country", showColumnName: false, title: "Country" },
    { id: inputs.metric.value, title: inputs.metric.label, fmt: "0,0" }
  ]}
  height=200
  />