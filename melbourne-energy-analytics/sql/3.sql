WITH yearly_cost AS (
    SELECT
        y.year,
        SUM(f.total_cost) AS total_cost
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
    total_cost,

    LAG(total_cost) OVER (
        ORDER BY year
    ) AS previous_year_cost,

    ROUND(
        (
            total_cost
            - LAG(total_cost) OVER (ORDER BY year)
        )
        / LAG(total_cost) OVER (ORDER BY year)
        * 100,
        2
    ) AS yoy_cost_growth_pct

FROM yearly_cost
ORDER BY year;