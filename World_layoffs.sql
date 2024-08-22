### 1. Creating and Populating the Staging Table
CREATE TABLE layoffs_staging LIKE layoffs;

-- Create a new table** `layoffs_staging` with the same structure as the existing `layoffs` table.
SELECT * FROM layoffs_staging;

-- Query the new staging table** to verify its structure (initially empty).
INSERT layoffs_staging SELECT * FROM layoffs;

-- Insert all data** from the `layoffs` table into the new `layoffs_staging` table.
SELECT * FROM layoffs_staging;

-- Verify the data** has been successfully copied into `layoffs_staging`.

### 2. Removing Duplicates

SELECT *, ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off,
`date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

-- Select data** from `layoffs_staging` with a row number assigned to each row within partitions defined by the specified columns.

WITH duplicate_cte AS
(
    SELECT *, 
    ROW_NUMBER() OVER(
    PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
    FROM layoffs_staging
)
SELECT * FROM duplicate_cte
WHERE row_num > 1;

-- Create a CTE (Common Table Expression)** `duplicate_cte` that assigns a row number to each row within partitions based on specific columns.

-- Select rows** where `row_num` is greater than 1 (indicating duplicates).

SELECT * FROM layoffs_staging
WHERE company = 'Casper';

-- Query data** from `layoffs_staging` for a specific company (`Casper`), to check for specific entries.

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `row_num` INT,
  `funds_raised_millions` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Create a new table** `layoffs_staging2` with an additional column `row_num` for tracking duplicates.

SELECT * FROM layoffs_staging2;

-- Query the new table** `layoffs_staging2` to verify its structure (initially empty).

INSERT INTO layoffs_staging2
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_staging;

-- Insert data** into `layoffs_staging2` from `layoffs_staging`, including the `row_num` for each row to identify duplicates.

SELECT * FROM layoffs_staging2;

-- Verify** that the data and `row_num` have been inserted correctly.

SELECT * FROM layoffs_staging2
WHERE row_num > 1;

-- Query rows** where `row_num` is greater than 1 to find duplicates.

DELETE FROM layoffs_staging2
WHERE row_num > 1;

-- Delete rows** from `layoffs_staging2` where `row_num` is greater than 1, effectively removing duplicates.

SELECT * FROM layoffs_staging2
WHERE row_num > 1;

-- Verify** that duplicates have been removed.

SELECT * FROM layoffs_staging2;

-- Query the final state** of `layoffs_staging2` to ensure it’s cleaned.

### 3. Standardizing Data

SELECT * FROM layoffs_staging2;

-- Query data** to inspect current values.

SELECT DISTINCT(trim(company))
FROM layoffs_staging2;

-- Find distinct company names** after trimming whitespace.

UPDATE layoffs_staging2
SET company = trim(company);

-- Update** the `company` field to remove leading and trailing whitespace.

SELECT * FROM layoffs_staging2;

-- Check** the updated `company` field values.


SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;

-- Find distinct values** in the `industry` field to check for inconsistencies.

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

-- Query rows** where the `industry` starts with 'Crypto'.

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- Standardize** the `industry` field to 'Crypto' for all values starting with 'Crypto'.

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

-- Verify** the `industry` field has been updated.

SELECT DISTINCT location
FROM layoffs_staging2
ORDER BY 1;

-- Find distinct values** in the `location` field.

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

-- Find distinct values** in the `country` field.

SELECT *
FROM layoffs_staging2
WHERE country LIKE 'United States%'
ORDER BY 1;

-- Query rows** where the `country` starts with 'United States' to check for variations.

SELECT *
FROM layoffs_staging2;

-- Query data** to inspect current `country` values.

SELECT `date`, str_to_date(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

-- Convert `date` field** values from text to a `DATE` format using `str_to_date()`.

UPDATE layoffs_staging2
SET `date` = str_to_date(`date`, '%m/%d/%Y');

-- Update** the `date` field to the proper `DATE` format.

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- Modify** the column type of `date` to `DATE` for better storage and querying.

### 4. Handling Null Values

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Query rows** where both `total_laid_off` and `percentage_laid_off` are null.

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL;

-- Query rows** where `industry` is null.

SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';

-- Query data** for the company 'Airbnb'.

SELECT * FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t2.industry='')
AND t1.industry IS NOT NULL;

-- Join** the table with itself to find rows where `industry` is missing but should be filled based on other rows with the same company.

SELECT t1.industry, t2.industry FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t2.industry='')
AND t1.industry IS NOT NULL;

-- Select the `industry` values** from both joined tables to inspect the missing values.

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
SET t1.industry = t2.industry 
WHERE t1.industry IS NULL 
AND t1.industry IS NOT NULL;

-- Update** `industry` in `t1` with values from `t2` where `industry` is missing in `t1` but present in `t2`.

ALTER TABLE layoffs_staging2
DROP row_num;

-- Drop the `row_num` column** used for identifying duplicates.

SELECT * FROM layoffs_staging2;

-- Query the final state** of `layoffs_staging2` to confirm all changes have been applied.
