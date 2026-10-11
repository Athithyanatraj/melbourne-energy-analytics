WITH yearly_energy AS (
    SELECT
        y.year,
        SUM(f.total_electricity_kwh) AS electricity_kwh
    FROM fact_energy f
    JOIN dim_year y
        ON f.year_id = y.year_id
    JOIN dim_energy_source e
        ON f.energy_source_id = e.energy_source_id
    WHERE e.emission_source = 'Electricity'
    GROUP BY y.year
)
SELECT
    year,
    electricity_kwh,
    LAG(electricity_kwh) OVER (ORDER BY year) AS previous_year_kwh,
    ROUND(
        (
            electricity_kwh
            - LAG(electricity_kwh) OVER (ORDER BY year)
        )
        / LAG(electricity_kwh) OVER (ORDER BY year)
        * 100,
        2
    ) AS yoy_growth_pct
FROM yearly_energy
ORDER BY year;