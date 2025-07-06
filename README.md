# Layoffs Dataset Cleaning Project

## Project Overview
This project focuses on cleaning a dataset related to company layoffs using MySQL. The primary tasks involve removing duplicates, standardizing the data, 
handling null or blank values, and removing unnecessary columns to make the dataset ready for analysis.

### Key Steps:
1. Removing Duplicates
2. Standardizing the Dataset
3. Handling Null/Blank Values
4. Removing Unnecessary Columns

## Dataset Description
The layoffs dataset contains information about layoffs in various companies, including details like company name, location, industry, total number laid off, 
percentage laid off, date, stage, country, and funds raised. The objective was to clean the dataset to make it ready for further analysis.

### Columns:
a. company: Name of the company.
b. location: Company's location.
c. industry: The industry sector to which the company belongs.
d. total_laid_off: Total number of people laid off.
e. percentage_laid_off: Percentage of the workforce laid off.
f. date: Date when the layoffs occurred.
g. stage: Company funding or business stage.
h. country: The country where the company is based.
i. funds_raised_millions: The amount of money the company raised in millions.

## Data Cleaning Steps
### Create Staging Table
- Created a staging table (layoffs_staging) to hold a cleaned version of the original layoffs table.
- Inserted all data from the original layoffs table into the staging table.
```
CREATE TABLE layoffs_staging LIKE layoffs;
INSERT INTO layoffs_staging SELECT * FROM layoffs;
```

### Removing Duplicates
Used ROW_NUMBER() with PARTITION BY to identify and remove duplicate records based on the combination of several columns (company, industry, total_laid_off,
percentage_laid_off, date).
```
ROW_NUMBER() OVER(PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`)
```
###  Standardizing the Dataset
- Trimmed unnecessary white spaces from the company and country columns.
- Standardized the industry column by converting variations like 'Cryptocurrency' to 'Crypto'.
- Cleaned up the location and country columns by removing extraneous characters (e.g., trailing periods).
- Converted the date column to the proper date format.
```
UPDATE layoffs_staging2 SET company = TRIM(company);
UPDATE layoffs_staging2 SET country = TRIM(TRAILING '.' FROM country);
 ```
### Handling Null/Blank Values
- Identified rows with missing total_laid_off and percentage_laid_off and removed them.
- Filled missing industry values based on similar rows (same company and location).
- Investigated rows where both industry and company were missing.
```
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2 ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL AND t2.industry IS NOT NULL;
 ```
### Removing Unnecessary Columns
- Dropped temporary columns like row_num that were used for cleaning but are not needed in the final dataset.

```
ALTER TABLE layoffs_staging2 DROP COLUMN row_num;
```
### Final Cleaned Dataset
After completing the above steps, the cleaned dataset is stored in layoffs_staging2. The cleaned data is now ready for analysis, and you can retrieve it with:

```
SELECT * FROM layoffs_staging2;
 
```
### Tools Used
- MySQL: All data cleaning tasks were performed using SQL queries in MySQL.

### How to Run the Project
- Clone the repository.
- Import the layoffs dataset into MySQL.
- Run the SQL scripts provided to clean the data.

### Conclusion
This project demonstrates a structured approach to cleaning a dataset by removing duplicates, handling null values, standardizing columns, 
and optimizing the data for further analysis. This cleaned data can now be used for deeper business insights and analysis on layoffs trends.


