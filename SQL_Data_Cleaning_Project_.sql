-- Data Cleaning Project
/* 
This is the beginning of my data cleaning project.
The CSV file used for this project can be obtained from:
"https://github.com/AlexTheAnalyst/MySQL-YouTube-Series/blob/main/layoffs.csv"
*/

-- Step 1: Set up database and table to store CSV file

DROP DATABASE IF EXISTS company_layoff;
CREATE DATABASE company_layoff;
USE company_layoff;  -- Ensure the correct database is in use

-- Creating the raw_lay_offs table
CREATE TABLE raw_lay_offs(
    company VARCHAR(225),
    location VARCHAR(225) NULL,
    industry VARCHAR(225) NULL,
    total_laid_off INT NULL,
    percentage_laid_off INT NULL,
    `date` VARCHAR(12) NULL, -- Set to VARCHAR since date was in wrong format from CSV
    stage VARCHAR(225) NULL,
    country VARCHAR(225) NULL,
    funds_raised_millions VARCHAR(225)
);

-- Load CSV File into raw_lay_offs
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/layoffs.csv'
INTO TABLE raw_lay_offs
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Step 2: Create a Temporary Table for Redundancy
CREATE TEMPORARY TABLE temp_layoff LIKE raw_lay_offs;

-- Copy the rows from raw_lay_offs into the temporary table
INSERT INTO temp_layoff
SELECT * FROM raw_lay_offs;

-- Step 3: Removing Duplicate Rows
CREATE TABLE cleaned_layoff(
    company VARCHAR(225),
    location VARCHAR(225) NULL,
    industry VARCHAR(225) NULL,
    total_laid_off INT NULL,
    percentage_laid_off INT NULL,
    `date` VARCHAR(12) NULL, 
    stage VARCHAR(225) NULL,
    country VARCHAR(225) NULL,
    funds_raised_millions VARCHAR(225) DEFAULT NULL,
    row_num INT
);

-- Insert into cleaned_layoff with row numbers for deduplication
INSERT INTO cleaned_layoff
SELECT *, ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, 
                            percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM temp_layoff;

-- Delete duplicate rows
DELETE FROM cleaned_layoff
WHERE row_num > 1;

-- Step 4: Standardization of Data
UPDATE cleaned_layoff
SET company = TRIM(company);

UPDATE cleaned_layoff
SET industry = 'Crypto'
WHERE industry LIKE 'Cryp%';

-- Set the date format to the correct SQL format

UPDATE cleaned_layoff
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

-- Modify the column data type to DATE for the date column
ALTER TABLE cleaned_layoff
MODIFY COLUMN `date` DATE DEFAULT NULL
;
-- Remove trailing periods from country names
UPDATE cleaned_layoff
SET country = TRIM(TRAILING '.' FROM country);

-- Step 5: Dealing with NULL and Blank Values
UPDATE cleaned_layoff
SET industry = NULL
WHERE industry = '';

-- Fill in missing industry values by matching with other records
UPDATE cleaned_layoff AS t1
JOIN cleaned_layoff AS t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL AND t2.industry IS NOT NULL;

-- Delete rows where both total_laid_off and percentage_laid_off are NULL
DELETE FROM cleaned_layoff
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

-- Drop the row_num column
ALTER TABLE cleaned_layoff
DROP COLUMN row_num;

-- Final cleaned data
SELECT * 
FROM cleaned_layoff;
