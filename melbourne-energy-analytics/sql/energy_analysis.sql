CREATE DATABASE melbourne_energy;
USE melbourne_energy;
SELECT DATABASE();
CREATE TABLE staging_energy (
    year INT,
    postcode VARCHAR(10),
    suburb VARCHAR(255),
    category VARCHAR(50),
    emission_source VARCHAR(50),

    total_electricity_kwh DECIMAL(18,2),
    total_gas_gj DECIMAL(18,2),

    average_intensity_kwh_per_customer_per_annum DECIMAL(18,2),
    average_intensity_gj_per_customer_per_annum DECIMAL(18,2),

    average_intensity_kwh_per_customer_per_day DECIMAL(18,4),
    average_intensity_mj_per_customer_per_day DECIMAL(18,4),

    scope_1_kg_co2e DECIMAL(18,2),
    scope_2_kg_co2e DECIMAL(18,2),
    scope_3_kg_co2e DECIMAL(18,2),
    total_emissions_kg_co2e DECIMAL(18,2),

    average_emissions_per_customer_kg_co2e DECIMAL(18,2),
    average_emissions_energy_per_customer_kg_co2e_per_day DECIMAL(18,4),

    rest_of_municipality_total_electricity_kwh DECIMAL(18,2),
    rest_of_municipality_total_gas_gj DECIMAL(18,2),
    rest_of_municipality_emissions_kg_co2e DECIMAL(18,2),

    total_cost DECIMAL(18,2),

    average_intensity_household_per_day DECIMAL(18,4),
    average_intensity_household_per_month DECIMAL(18,4),
    average_intensity_household_per_annum DECIMAL(18,2),

    geo_shape TEXT,
    geo_point_2d VARCHAR(100)
);

DROP TABLE IF EXISTS staging_energy;



CREATE TABLE staging_energy (
    year VARCHAR(255),
    postcode VARCHAR(255),
    suburb VARCHAR(255),
    category VARCHAR(255),
    emission_source VARCHAR(255),
    total_electricity_kwh VARCHAR(255),
    total_gas_gj VARCHAR(255),
    average_intensity_kwh_per_customer_per_annum VARCHAR(255),
    average_intensity_gj_per_customer_per_annum VARCHAR(255),
    average_intensity_kwh_per_customer_per_day VARCHAR(255),
    average_intensity_mj_per_customer_per_day VARCHAR(255),
    scope_1_kg_co2e VARCHAR(255),
    scope_2_kg_co2e VARCHAR(255),
    scope_3_kg_co2e VARCHAR(255),
    total_emissions_kg_co2e VARCHAR(255),
    average_emissions_per_customer_kg_co2e VARCHAR(255),
    average_emissions_energy_per_customer_kg_co2e_per_day VARCHAR(255),
    rest_of_municipality_total_electricity_kwh VARCHAR(255),
    rest_of_municipality_total_gas_gj VARCHAR(255),
    rest_of_municipality_emissions_kg_co2e VARCHAR(255),
    total_cost VARCHAR(255),
    average_intensity_household_per_day VARCHAR(255),
    average_intensity_household_per_month VARCHAR(255),
    average_intensity_household_per_annum VARCHAR(255),
    geo_shape VARCHAR(255),
    geo_point_2d VARCHAR(255)
);

-- 1. Drop the table
DROP TABLE IF EXISTS staging_energy;

-- 2. Recreate it with geo_shape as LONGTEXT
CREATE TABLE staging_energy (
    year VARCHAR(255),
    postcode VARCHAR(255),
    suburb VARCHAR(255),
    category VARCHAR(255),
    emission_source VARCHAR(255),
    total_electricity_kwh VARCHAR(255),
    total_gas_gj VARCHAR(255),
    average_intensity_kwh_per_customer_per_annum VARCHAR(255),
    average_intensity_gj_per_customer_per_annum VARCHAR(255),
    average_intensity_kwh_per_customer_per_day VARCHAR(255),
    average_intensity_mj_per_customer_per_day VARCHAR(255),
    scope_1_kg_co2e VARCHAR(255),
    scope_2_kg_co2e VARCHAR(255),
    scope_3_kg_co2e VARCHAR(255),
    total_emissions_kg_co2e VARCHAR(255),
    average_emissions_per_customer_kg_co2e VARCHAR(255),
    average_emissions_energy_per_customer_kg_co2e_per_day VARCHAR(255),
    rest_of_municipality_total_electricity_kwh VARCHAR(255),
    rest_of_municipality_total_gas_gj VARCHAR(255),
    rest_of_municipality_emissions_kg_co2e VARCHAR(255),
    total_cost VARCHAR(255),
    average_intensity_household_per_day VARCHAR(255),
    average_intensity_household_per_month VARCHAR(255),
    average_intensity_household_per_annum VARCHAR(255),
    geo_shape LONGTEXT,              -- Changed to LONGTEXT here!
    geo_point_2d VARCHAR(255)
);

USE melbourne_energy;

SELECT COUNT(*) AS total_rows
FROM staging_energy;

SELECT
    category,
    emission_source,
    COUNT(*) AS records
FROM staging_energy
GROUP BY category, emission_source;


SELECT *
FROM staging_energy
LIMIT 5;

CREATE TABLE dim_year (
    year_id INT PRIMARY KEY,
    year INT NOT NULL
);

INSERT INTO dim_year (year_id, year)
SELECT DISTINCT
    year,
    year
FROM staging_energy;

SELECT * FROM dim_year;


CREATE TABLE dim_suburb (
    suburb_id INT AUTO_INCREMENT PRIMARY KEY,
    postcode VARCHAR(10),
    suburb VARCHAR(255),
    geo_point_2d VARCHAR(100),
    UNIQUE (postcode, suburb)
);


INSERT INTO dim_suburb (
    postcode,
    suburb,
    geo_point_2d
)
SELECT DISTINCT
    postcode,
    suburb,
    geo_point_2d
FROM staging_energy;


SELECT * FROM dim_suburb;


CREATE TABLE dim_energy_source (
    energy_source_id INT AUTO_INCREMENT PRIMARY KEY,
    emission_source VARCHAR(50) UNIQUE
);


INSERT INTO dim_energy_source (emission_source)
SELECT DISTINCT emission_source
FROM staging_energy;

SELECT * FROM dim_energy_source;


CREATE TABLE fact_energy (
    fact_id INT AUTO_INCREMENT PRIMARY KEY,

    year_id INT NOT NULL,
    suburb_id INT NOT NULL,
    energy_source_id INT NOT NULL,

    category VARCHAR(50),

    total_electricity_kwh DECIMAL(18,2),
    total_gas_gj DECIMAL(18,2),

    average_intensity_kwh_per_customer_per_annum DECIMAL(18,2),
    average_intensity_gj_per_customer_per_annum DECIMAL(18,2),

    average_intensity_kwh_per_customer_per_day DECIMAL(18,4),
    average_intensity_mj_per_customer_per_day DECIMAL(18,4),

    scope_1_kg_co2e DECIMAL(18,2),
    scope_2_kg_co2e DECIMAL(18,2),
    scope_3_kg_co2e DECIMAL(18,2),
    total_emissions_kg_co2e DECIMAL(18,2),

    average_emissions_per_customer_kg_co2e DECIMAL(18,2),
    average_emissions_energy_per_customer_kg_co2e_per_day DECIMAL(18,4),

    rest_of_municipality_total_electricity_kwh DECIMAL(18,2),
    rest_of_municipality_total_gas_gj DECIMAL(18,2),
    rest_of_municipality_emissions_kg_co2e DECIMAL(18,2),

    total_cost DECIMAL(18,2),

    average_intensity_household_per_day DECIMAL(18,4),
    average_intensity_household_per_month DECIMAL(18,4),
    average_intensity_household_per_annum DECIMAL(18,2),

    FOREIGN KEY (year_id)
        REFERENCES dim_year(year_id),

    FOREIGN KEY (suburb_id)
        REFERENCES dim_suburb(suburb_id),

    FOREIGN KEY (energy_source_id)
        REFERENCES dim_energy_source(energy_source_id),

    UNIQUE (year_id, suburb_id, energy_source_id)
);


INSERT INTO fact_energy (
    year_id,
    suburb_id,
    energy_source_id,
    category,

    total_electricity_kwh,
    total_gas_gj,

    average_intensity_kwh_per_customer_per_annum,
    average_intensity_gj_per_customer_per_annum,
    average_intensity_kwh_per_customer_per_day,
    average_intensity_mj_per_customer_per_day,

    scope_1_kg_co2e,
    scope_2_kg_co2e,
    scope_3_kg_co2e,
    total_emissions_kg_co2e,

    average_emissions_per_customer_kg_co2e,
    average_emissions_energy_per_customer_kg_co2e_per_day,

    rest_of_municipality_total_electricity_kwh,
    rest_of_municipality_total_gas_gj,
    rest_of_municipality_emissions_kg_co2e,

    total_cost,

    average_intensity_household_per_day,
    average_intensity_household_per_month,
    average_intensity_household_per_annum
)
SELECT
    y.year_id,
    s.suburb_id,
    e.energy_source_id,
    st.category,

    st.total_electricity_kwh,
    st.total_gas_gj,

    st.average_intensity_kwh_per_customer_per_annum,
    st.average_intensity_gj_per_customer_per_annum,
    st.average_intensity_kwh_per_customer_per_day,
    st.average_intensity_mj_per_customer_per_day,

    st.scope_1_kg_co2e,
    st.scope_2_kg_co2e,
    st.scope_3_kg_co2e,
    st.total_emissions_kg_co2e,

    st.average_emissions_per_customer_kg_co2e,
    st.average_emissions_energy_per_customer_kg_co2e_per_day,

    st.rest_of_municipality_total_electricity_kwh,
    st.rest_of_municipality_total_gas_gj,
    st.rest_of_municipality_emissions_kg_co2e,

    st.total_cost,

    st.average_intensity_household_per_day,
    st.average_intensity_household_per_month,
    st.average_intensity_household_per_annum

FROM staging_energy st

JOIN dim_year y
    ON st.year = y.year

JOIN dim_suburb s
    ON st.postcode = s.postcode
    AND st.suburb = s.suburb

JOIN dim_energy_source e
    ON st.emission_source = e.emission_source;
    
    
SELECT COUNT(*) AS fact_rows
FROM fact_energy;    

SELECT
    year_id,
    suburb_id,
    energy_source_id,
    total_electricity_kwh,
    total_gas_gj,
    total_cost
FROM fact_energy
LIMIT 10;

-- Total electricity consumption by year

SELECT
    y.year,
    SUM(f.total_electricity_kwh) AS total_electricity_kwh
FROM fact_energy f
JOIN dim_year y
    ON f.year_id = y.year_id
WHERE f.energy_source_id = (
    SELECT energy_source_id
    FROM dim_energy_source
    WHERE emission_source = 'Electricity'
)
GROUP BY y.year
ORDER BY y.year;

-- Electricity consumption by suburb
SELECT
    s.suburb,
    SUM(f.total_electricity_kwh) AS total_electricity_kwh
FROM fact_energy f
JOIN dim_suburb s
    ON f.suburb_id = s.suburb_id
JOIN dim_energy_source e
    ON f.energy_source_id = e.energy_source_id
WHERE e.emission_source = 'Electricity'
GROUP BY s.suburb
ORDER BY total_electricity_kwh DESC;

-- Cost vs consumption
SELECT
    y.year,
    SUM(f.total_electricity_kwh) AS electricity_kwh,
    SUM(f.total_cost) AS total_cost,
    SUM(f.total_cost) / SUM(f.total_electricity_kwh) AS cost_per_kwh
FROM fact_energy f
JOIN dim_year y
    ON f.year_id = y.year_id
JOIN dim_energy_source e
    ON f.energy_source_id = e.energy_source_id
WHERE e.emission_source = 'Electricity'
GROUP BY y.year
ORDER BY y.year;

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

    LAG(electricity_kwh) OVER (
        ORDER BY year
    ) AS previous_year_kwh,

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