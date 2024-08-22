Data Cleaning Process for `layoffs`  Table

This document describes the data cleaning procedures applied to the `layoffs` table to ensure data integrity and consistency. The process involves creating a staging table, removing duplicates, and standardizing data.
1. Creating and Populating the Staging Table

 1.1 Create Staging Table
A new table, `layoffs_staging`, is created with the same structure as the existing `layoffs` table. This staging table serves as an intermediary to manage and clean the data without altering the original dataset.

 1.2 Verify Table Structure
The structure of the newly created `layoffs_staging` table is verified to ensure it matches the expected format.

 1.3 Populate Staging Table
Data from the original `layoffs` table is copied into the `layoffs_staging` table. This step ensures that the cleaning operations are performed on a complete dataset.

 1.4 Verify Data Insertion
The data in `layoffs_staging` is checked to confirm that the insertion process has successfully transferred all records from the original table.

 2. Removing Duplicates

 2.1 Identify Duplicates
Duplicates are identified by assigning a unique row number to each entry within partitions defined by specific columns. This helps in distinguishing between unique and duplicate records.

 2.2 Create and Query CTE for Duplicates
A Common Table Expression (CTE) is used to further identify duplicates. Rows where the row number indicates a duplicate are selected for review.

 2.3 Query Data for Specific Company
Specific data entries, such as those related to the company "Casper," are queried to identify and analyze duplicates related to particular companies.

 2.4 Create New Staging Table for Cleaned Data
A new staging table, `layoffs_staging2`, is created with an additional column to track duplicates. This new table will be used to manage cleaned data.

 2.5 Populate New Staging Table
Data from the initial staging table is inserted into `layoffs_staging2`, including a row number for each record to help in identifying and removing duplicates.

 2.6 Remove Duplicates
Records identified as duplicates are deleted from `layoffs_staging2`, ensuring that only unique entries remain.

 2.7 Verify Removal of Duplicates
The final state of `layoffs_staging2` is checked to confirm that all duplicates have been successfully removed.

 3. Standardizing Data

 3.1 Inspect Current Values
Current values in `layoffs_staging2` are inspected to identify inconsistencies and areas needing standardization.

 3.2 Standardize Company Names
Company names are standardized by trimming leading and trailing whitespace to ensure uniformity across the dataset.

 3.3 Standardize Industry Values
Industry values are standardized by consolidating variations into a common format. For instance, industry names starting with "Crypto" are updated to a consistent value.

 3.4 Standardize Location and Country Values
Distinct values for locations and countries are reviewed and standardized to correct any variations or inconsistencies.

 3.5 Standardize Date Format
Date values are converted from text to a proper `DATE` format to facilitate accurate date-based queries and analysis.

 4. Handling Null Values

 4.1 Identify Null Values
Records with null values in critical columns, such as `total_laid_off`, `percentage_laid_off`, and `industry`, are identified for further handling.

 4.2 Update Missing Industry Values
In cases where the `industry` value is missing but should be inferred from other records of the same company, updates are made to fill in these missing values.

 4.3 Final Cleanup
The column used for tracking duplicates, `row_num`, is dropped from the final table. The cleaned dataset in `layoffs_staging2` is then verified to ensure all changes have been applied correctly.
