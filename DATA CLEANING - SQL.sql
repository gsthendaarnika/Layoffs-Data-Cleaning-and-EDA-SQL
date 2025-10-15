-- 🔹 DATA CLEANING PROCESS

USE world_layoffs;
SELECT * FROM layoffs;

-- --------------------------------------------------
-- 1️. REMOVE DUPLICATES
-- --------------------------------------------------

-- Create a staging table to work safely
CREATE TABLE layoffs_staging LIKE layoffs;
INSERT INTO layoffs_staging SELECT * FROM layoffs;

-- Identify duplicates using ROW_NUMBER()
WITH duplicate_cte AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY company, location, industry, total_laid_off, 
                            percentage_laid_off, date, stage, country, funds_raised_millions
           ) AS row_num
    FROM layoffs_staging
)
SELECT * 
FROM duplicate_cte
WHERE row_num > 1;

-- Create a cleaned version without duplicates
CREATE TABLE layoffs_staging2 (
    company TEXT,
    location TEXT,
    industry TEXT,
    total_laid_off INT DEFAULT NULL,
    percentage_laid_off TEXT,
    date TEXT,
    stage TEXT,
    country TEXT,
    funds_raised_millions INT DEFAULT NULL,
    row_num INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO layoffs_staging2
SELECT *, 
       ROW_NUMBER() OVER (
           PARTITION BY company, location, industry, total_laid_off, 
                        percentage_laid_off, date, stage, country, funds_raised_millions
       ) AS row_num
FROM layoffs_staging;

-- Delete duplicate rows
DELETE FROM layoffs_staging2 WHERE row_num > 1;

-- --------------------------------------------------
-- 2️. STANDARDIZE DATA
-- --------------------------------------------------

-- Trim unwanted spaces
UPDATE layoffs_staging2 SET company = TRIM(company);

-- Unify inconsistent industry names
SELECT DISTINCT industry FROM layoffs_staging2 ORDER BY 1;

UPDATE layoffs_staging2 
SET industry = 'Crypto' 
WHERE industry LIKE 'Crypto%';

-- Clean country field
UPDATE layoffs_staging2 
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

-- Convert text date to DATE format
UPDATE layoffs_staging2 
SET date = STR_TO_DATE(date, '%m/%d/%Y');

ALTER TABLE layoffs_staging2 
MODIFY COLUMN date DATE;

-- --------------------------------------------------
-- 3️. HANDLE NULL & BLANK VALUES
-- --------------------------------------------------

-- Identify null/blank industries
UPDATE layoffs_staging2 
SET industry = NULL 
WHERE industry = '';

-- Fill missing industries using company matches
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2 
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL 
  AND t2.industry IS NOT NULL;

-- Remove rows with no layoff data
DELETE FROM layoffs_staging2 
WHERE total_laid_off IS NULL 
  AND percentage_laid_off IS NULL;

-- --------------------------------------------------
-- 4️. FINAL CLEANUP
-- --------------------------------------------------
ALTER TABLE layoffs_staging2 DROP COLUMN row_num;

SELECT * FROM layoffs_staging2;
