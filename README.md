# Data Cleaning SQL Script

## Overview
This SQL script is designed to clean and standardize a dataset stored in the `data_cleaning` table. The main tasks performed include:

1. **Standardizing Date Formats:** Converts all dates in the `SaleDate` column to a consistent `YYYY-MM-DD` format.
2. **Populating Missing Addresses:** Fills in missing `PropertyAddress` values by matching entries with the same `ParcelID`.
3. **Splitting Address Fields:** Separates `PropertyAddress` and `OwnerAddress` into individual components (Address, City, State).
4. **Standardizing Categorical Data:** Normalizes entries in the `SoldAsVacant` column from `Y/N` to `Yes/No`.
5. **Removing Duplicate Records:** Identifies and deletes duplicate rows based on key fields.
6. **Cleaning Up Columns:** Drops unnecessary columns like `OwnerAddress`, `TaxDistrict`, and `PropertyAddress`.

## Instructions for Use
1. **Import the SQL Script:** Upload the `data_cleaning.csv` file into MySQL Workbench using the `Import Table Data Wizard`.
2. **Run the Script:** Execute the script to apply the data cleaning steps to the `data_cleaning` table.

The table will be cleaned and standardized, ready for analysis or further processing.