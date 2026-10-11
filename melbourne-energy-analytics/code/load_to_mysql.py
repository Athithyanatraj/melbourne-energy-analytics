import pandas as pd
import mysql.connector

# Load CSV
df = pd.read_csv(
    r"E:\melbourne-energy-analytics\data\processed\residential_energy_clean.csv"
)

print("CSV rows:", len(df))

# Connect to MySQL
conn = mysql.connector.connect(
    host="127.0.0.1",
    user="root",
    password="Athithya!3",
    database="melbourne_energy"
)

cursor = conn.cursor()

# Clear previous incorrect import
cursor.execute("TRUNCATE TABLE staging_energy")

# Insert rows
columns = [
    "year",
    "postcode",
    "suburb",
    "category",
    "emission_source",
    "total_electricity_kwh",
    "total_gas_gj",
    "average_intensity_kwh_per_customer_per_annum",
    "average_intensity_gj_per_customer_per_annum",
    "average_intensity_kwh_per_customer_per_day",
    "average_intensity_mj_per_customer_per_day",
    "scope_1_kg_co2e",
    "scope_2_kg_co2e",
    "scope_3_kg_co2e",
    "total_emissions_kg_co2e",
    "average_emissions_per_customer_kg_co2e",
    "average_emissions_energy_per_customer_kg_co2e_per_day",
    "rest_of_municipality_total_electricity_kwh",
    "rest_of_municipality_total_gas_gj",
    "rest_of_municipality_emissions_kg_co2e",
    "total_cost",
    "average_intensity_household_per_day",
    "average_intensity_household_per_month",
    "average_intensity_household_per_annum",
    "geo_shape",
    "geo_point_2d"
]

placeholders = ", ".join(["%s"] * len(columns))

query = f"""
INSERT INTO staging_energy ({", ".join(columns)})
VALUES ({placeholders})
"""

# Convert NaN → None
df = df.astype(object).where(pd.notnull(df), None)

for row in df[columns].itertuples(index=False, name=None):
    cursor.execute(query, row)

conn.commit()

print("Rows inserted:", len(df))

cursor.close()
conn.close()