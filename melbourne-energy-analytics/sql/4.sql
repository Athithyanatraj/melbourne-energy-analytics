SELECT
    s.suburb,

    ROUND(
        SUM(f.total_electricity_kwh),
        0
    ) AS total_electricity_kwh,

    ROUND(
        AVG(f.average_intensity_kwh_per_customer_per_annum),
        2
    ) AS avg_kwh_per_customer

FROM fact_energy f

JOIN dim_suburb s
    ON f.suburb_id = s.suburb_id

JOIN dim_energy_source e
    ON f.energy_source_id = e.energy_source_id

WHERE e.emission_source = 'Electricity'

GROUP BY s.suburb

ORDER BY avg_kwh_per_customer DESC;