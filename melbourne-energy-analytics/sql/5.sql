SELECT
    s.suburb,

    ROUND(
        AVG(f.average_intensity_kwh_per_customer_per_annum),
        2
    ) AS avg_kwh_per_customer,

    CASE
        WHEN AVG(f.average_intensity_kwh_per_customer_per_annum) >= 7000
            THEN 'High'
        WHEN AVG(f.average_intensity_kwh_per_customer_per_annum) >= 4000
            THEN 'Medium'
        ELSE 'Low'
    END AS consumption_segment

FROM fact_energy f

JOIN dim_suburb s
    ON f.suburb_id = s.suburb_id

JOIN dim_energy_source e
    ON f.energy_source_id = e.energy_source_id

WHERE e.emission_source = 'Electricity'

GROUP BY s.suburb

ORDER BY avg_kwh_per_customer DESC;