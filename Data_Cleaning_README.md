# SQL_Projects
This repository will house all my SQL Projects
# Data Cleaning of Company Layoffs Dataset Using SQL for Power BI Analysis

## Description
This project involves cleaning and preparing a dataset containing statistics on company layoffs for further exploration and visualization using Power BI. The primary goal is to transform raw, inconsistent data into a clean, analysis-ready dataset by handling duplicates, standardizing data formats, and addressing missing values. The cleaned data will facilitate accurate and insightful analysis in Power BI.

## Dataset Information

- **Source**: The dataset is sourced from [AlexTheAnalyst's GitHub repository](https://github.com/AlexTheAnalyst/MySQL-YouTube-Series/blob/main/layoffs.csv), which accompanies his YouTube tutorial series on SQL.

- **Description**: The dataset contains information about recent company layoffs, including company name, location, industry, total number laid off, percentage laid off, date of layoff, company stage, country, and funds raised in millions.

### Sample Data:

| Company    | Location      | Industry     | Total_Laid_Off | Percentage_Laid_Off | Date       | Stage     | Country        | Funds_Raised_Millions |
|------------|---------------|--------------|----------------|---------------------|------------|-----------|----------------|-----------------------|
| Atlassian  | Sydney        | Other        | 500            | 0.05                | 3/6/2023   | Post-IPO  | Australia      | 210                   |
| SiriusXM   | New York City | Media        | 475            | 0.08                | 3/6/2023   | Post-IPO  | United States  | 525                   |
| Alerzo     | Ibadan        | Retail       | 400            | NULL                | 3/6/2023   | Series B  | Nigeria        | 16                    |
| UpGrad     | Mumbai        | Education    | 120            | NULL                | 3/6/2023   | Unknown   | India          | 631                   |
| Loft       | Sao Paulo     | Real Estate  | 340            | 0.15                | 3/3/2023   | Unknown   | Brazil         | 788                   |

- **Preprocessing Steps**:
  - **Data Import**: Loaded the CSV file into a MySQL database.
  - **Duplicate Removal**: Identified and removed duplicate records using Common Table Expressions (CTEs) and window functions.
  - **Data Standardization**:
    - Trimmed whitespace and standardized company and country names.
    - Converted date strings to proper `DATE` data types.
  - **Handling Missing Values**:
    - Filled missing industry values by inferring from existing data.
    - Removed records with insufficient data that couldn't be reliably corrected.
  - **Data Validation**: Ensured data types and constraints were correctly applied for accurate analysis.
