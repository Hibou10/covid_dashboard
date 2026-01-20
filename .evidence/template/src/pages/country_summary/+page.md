---
title: Country Summary
---

This page provides a yearly overview of COVID-19 metrics for the selected country.  

```sql countries
select distinct country from cvd.covid order by country
```

<Dropdown data={countries} name=country value=country defaultValue="Germany" />


```sql country_summary
select
  year,
  infections,
  incidence,
  vaccinations,
  deaths
from cvd.covid
where country = '${inputs.country.value}'
order by year
```

<DataTable data={country_summary} title="Yearly Metrics for {inputs.country.value}">
  <Column id=year title="Year" />
  <Column id=infections title="Infections" contentType=bar barColor=#88c0d0 />
  <Column id=incidence title="Incidence" contentType=bar barColor=#ffe08a backgroundColor=#ebebeb />
  <Column id=vaccinations title="Vaccinations" contentType=bar barColor=#aecfaf />
  <Column id=deaths title="Deaths" contentType=bar barColor=#bf616a />
</DataTable>
