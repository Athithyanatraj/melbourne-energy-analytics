WITH suburb_intensity AS (
    SELECT
        s.suburb,
        AVG(f.average_intensity_kwh_per_customer_per_annum) AS avg_kwh_per_customer
    FROM fact_energy f
    JOIN dim_suburb s
        ON f.suburb_id = s.suburb_id
    JOIN dim_energy_source e
        ON f.energy_source_id = e.energy_source_id
    WHERE e.emission_source = 'Electricity'
    GROUP BY s.suburb
)

SELECT
    suburb,
    ROUND(avg_kwh_per_customer, 2) AS avg_kwh_per_customer,

    RANK() OVER (
        ORDER BY avg_kwh_per_customer DESC
    ) AS intensity_rank

FROM suburb_intensity
ORDER BY intensity_rank;

USE melbourne_energy;
-- converting into a single table to visualise using powerbi
CREATE OR REPLACE VIEW vw_energy_analysis AS

SELECT
    y.year,
    s.suburb,
    s.postcode,
    e.emission_source AS energy_source,

    f.category,

    f.total_electricity_kwh,
    f.total_gas_gj,

    f.total_cost,

    f.average_intensity_kwh_per_customer_per_annum
        AS avg_kwh_per_customer,

    f.average_intensity_gj_per_customer_per_annum
        AS avg_gj_per_customer,

    f.average_intensity_kwh_per_customer_per_day
        AS avg_kwh_per_customer_per_day,

    f.total_emissions_kg_co2e
        AS total_emissions_kg_co2e,

    f.average_emissions_per_customer_kg_co2e
        AS avg_emissions_per_customer,

    CASE
        WHEN e.emission_source = 'Electricity'
             AND f.total_electricity_kwh > 0
        THEN f.total_cost / f.total_electricity_kwh
        ELSE NULL
    END AS cost_per_kwh,

    CASE
        WHEN e.emission_source = 'Electricity'
             AND f.average_intensity_kwh_per_customer_per_annum >= 7000
        THEN 'High'

        WHEN e.emission_source = 'Electricity'
             AND f.average_intensity_kwh_per_customer_per_annum >= 4000
        THEN 'Medium'

        WHEN e.emission_source = 'Electricity'
        THEN 'Low'

        ELSE NULL
    END AS consumption_segment

FROM fact_energy f

JOIN dim_year y
    ON f.year_id = y.year_id

JOIN dim_suburb s
    ON f.suburb_id = s.suburb_id

JOIN dim_energy_source e
    ON f.energy_source_id = e.energy_source_id;
    
SELECT COUNT(*)
FROM melbourne_energy.vw_energy_analysis;

SELECT *
FROM melbourne_energy.vw_energy_analysis
LIMIT 5;