-- 🔹 EXPLORATORY DATA ANALYSIS (EDA)

USE world_layoffs;
SELECT * FROM layoffs_staging2;

-- --------------------------------------------------
-- 1️. BASIC INSIGHTS
-- --------------------------------------------------

-- Check overall maximum layoffs and layoff percentages
SELECT 
    MAX(total_laid_off) AS max_laid_off,
    MAX(percentage_laid_off) AS max_percentage
FROM layoffs_staging2;

-- Companies with 100% layoffs (complete shutdowns)
SELECT * 
FROM layoffs_staging2 
WHERE percentage_laid_off = 1 
ORDER BY total_laid_off DESC;

-- Same, ordered by funds raised — to analyze scale of impact
SELECT * 
FROM layoffs_staging2 
WHERE percentage_laid_off = 1 
ORDER BY funds_raised_millions DESC;

-- --------------------------------------------------
-- 2️. COMPANY & INDUSTRY ANALYSIS
-- --------------------------------------------------

-- Total layoffs by company
SELECT 
    company, 
    SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY company
ORDER BY total_laid_off DESC;

-- Total layoffs by industry
SELECT 
    industry, 
    SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY industry
ORDER BY total_laid_off DESC;

-- --------------------------------------------------
-- 3️. COUNTRY & STAGE ANALYSIS
-- --------------------------------------------------

-- Total layoffs by country
SELECT 
    country, 
    SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY country
ORDER BY total_laid_off DESC;

-- Total layoffs by company funding stage
SELECT 
    stage, 
    SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY stage
ORDER BY total_laid_off DESC;

-- --------------------------------------------------
-- 4️. TIME-BASED ANALYSIS
-- --------------------------------------------------

-- Date range of dataset
SELECT 
    MIN(date) AS start_date,
    MAX(date) AS end_date
FROM layoffs_staging2;

-- Layoffs by individual date
SELECT 
    date, 
    SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY date
ORDER BY date ASC;

-- Yearly layoffs
SELECT 
    YEAR(date) AS year,
    SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY YEAR(date)
ORDER BY year ASC;

-- Monthly layoffs trend
SELECT 
    SUBSTRING(date, 1, 7) AS month,
    SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
WHERE SUBSTRING(date, 1, 7) IS NOT NULL
GROUP BY month
ORDER BY month ASC;

-- Rolling total layoffs over months
WITH rolling_total AS (
    SELECT 
        SUBSTRING(date, 1, 7) AS month,
        SUM(total_laid_off) AS total_off
    FROM layoffs_staging2
    WHERE SUBSTRING(date, 1, 7) IS NOT NULL
    GROUP BY month
)
SELECT 
    month, 
    total_off,
    SUM(total_off) OVER (ORDER BY month) AS rolling_total
FROM rolling_total;

-- --------------------------------------------------
-- 5️. COMPANY PERFORMANCE OVER YEARS
-- --------------------------------------------------

-- Yearly layoffs by each company
SELECT 
    company, 
    YEAR(date) AS year, 
    SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY company, YEAR(date)
ORDER BY total_laid_off DESC;

-- Create company-year mapping
WITH company_year AS (
    SELECT 
        company, 
        YEAR(date) AS year, 
        SUM(total_laid_off) AS total_laid_off
    FROM layoffs_staging2
    GROUP BY company, YEAR(date)
)
SELECT * FROM company_year;

-- Rank companies by layoffs each year
WITH company_year AS (
    SELECT 
        company, 
        YEAR(date) AS year, 
        SUM(total_laid_off) AS total_laid_off
    FROM layoffs_staging2
    GROUP BY company, YEAR(date)
),
company_year_rank AS (
    SELECT *,
           DENSE_RANK() OVER (PARTITION BY year ORDER BY total_laid_off DESC) AS ranking
    FROM company_year
    WHERE year IS NOT NULL
)
SELECT * 
FROM company_year_rank
WHERE ranking <= 5;
