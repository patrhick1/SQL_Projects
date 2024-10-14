/**
Data Exploration Project in MySQL

This project is a continuation of my data cleaning project within MySQL. The cleaned dataset contains 
company and industry layoff data from March 2020 to March 2023. 

Objective:
The goal of this exploration is to analyze the layoffs across various companies, industries, and time periods, 
and to identify key trends. By leveraging SQL aggregation functions, window functions, and CTEs, we can explore 
different aspects of the data such as:

1. Total layoffs by company and industry.
2. A rolling progression of monthly layoffs from March 2020 to March 2023.
3. The top 5 industries with the highest number of layoffs each year.
Methods:
- Using aggregation (`SUM`) to calculate total layoffs.
- Applying window functions (`DENSE_RANK`, `SUM OVER`) to analyze data over time.
- Utilizing Common Table Expressions (CTEs) to structure and organize queries for complex operations.
The insights derived from this analysis will help understand which companies and industries experienced the most layoffs 
and how layoffs evolved over time.

Let's dive into the exploration!
**/

-- Let's see the total amount of lay off by companies
SELECT company, SUM(total_laid_off) AS sum_of_layoff
FROM cleaned_layoff
GROUP BY company
ORDER BY sum_of_layoff DESC;

-- What about the industries
SELECT industry, SUM(total_laid_off) AS sum_of_layoff
FROM cleaned_layoff
GROUP BY industry
ORDER BY sum_of_layoff DESC;

-- Let's see the progression of layoffs from the first mont (March 2020) to latest month (March 2023)
WITH rolling_monthly_layoff_cte AS (
SELECT SUBSTRING(`date`,1,7) as `month`,
		SUM(total_laid_off)  AS sum_of_layoff 
FROM cleaned_layoff
GROUP BY SUBSTRING(`date`,1,7)
HAVING `month` IS NOT NULL
ORDER BY SUBSTRING(`date`,1,7)
)
SELECT *, SUM(sum_of_layoff) OVER(ORDER BY `month`) AS rolling_sum
FROM rolling_monthly_layoff_cte
ORDER BY `month`
;


/**
This query identifies the top 5 industries with the highest number of layoffs for each year.
-- 
-- Step 1: The `industry_layoff` CTE aggregates the total number of layoffs per industry for each year by summing 
--         the total laid-off employees and grouping the data by industry and year.
-- 
-- Step 2: The `get_ranking` CTE ranks the industries within each year using `DENSE_RANK()`, ordering by the 
--         total number of layoffs in descending order (highest layoffs are ranked first).
-- 
-- Step 3: The final SELECT statement filters the results to include only the top 5 industries with the most layoffs 
--         for each year by selecting the records where the ranking is 5 or less.
-- 
-- Output: The result will display the top 5 industries, their respective layoff numbers, and rankings for each year.
**/
WITH industry_layoff AS (
SELECT industry, 
		YEAR(`date`) AS `year`,
        SUM(total_laid_off) AS total_layoff
FROM cleaned_layoff
GROUP BY industry, YEAR(`date`) 
HAVING industry IS NOT NULL
AND `year` IS NOT NULL
), get_ranking AS (
SELECT *, 
		DENSE_RANK() OVER(PARTITION BY `year` ORDER BY total_layoff DESC) AS ranking
FROM industry_layoff
)
SELECT *
FROM get_ranking
WHERE ranking <= 5
;

