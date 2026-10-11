TRUNCATE TABLE staging_energy;

LOAD DATA LOCAL INFILE 'E:/melbourne-energy-analytics/data/processed/residential_energy_clean.csv'
INTO TABLE staging_energy
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;