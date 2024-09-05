select * 
from data_cleaning
limit 5;

-- checking the date format and standarzing it if needed

select SaleDate from data_cleaning;
select SaleDate, STR_TO_DATE(SaleDate, '%Y-%m-%d') as newdate from data_cleaning;

UPDATE data_cleaning
SET SaleDate = STR_TO_DATE(SaleDate, '%Y-%m-%d');


-- populating property address data

select PropertyAddress
from data_cleaning where PropertyAddress IS NULL; -- 29 null values

select *
from data_cleaning 
-- where PropertyAddress IS NULL; 
order by ParcelID;

-- the parcelid and the property address fields are same, for example 015 14 0 060.00 with this parcel id the address is same, so we can look for those parcel ids from the null address and see if there are others with the same parcel id and poplate the address.ALTER

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, 
       IFNULL(a.PropertyAddress, b.PropertyAddress)
FROM data_cleaning a
JOIN data_cleaning b
  ON a.ParcelID = b.ParcelID
 AND a.UniqueID != b.UniqueID
WHERE a.PropertyAddress IS NULL;

UPDATE data_cleaning a
JOIN data_cleaning b
  ON a.ParcelID = b.ParcelID
 AND a.UniqueID != b.UniqueID
SET a.PropertyAddress = IFNULL(a.PropertyAddress, b.PropertyAddress)
WHERE a.PropertyAddress IS NULL;

-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From data_cleaning;

SELECT
    SUBSTRING_INDEX(PropertyAddress, ',', 1) AS Address,
    SUBSTRING(PropertyAddress, LOCATE(',', PropertyAddress) + 1) AS Address_Rest
FROM data_cleaning;

ALTER TABLE data_cleaning
Add PropertySplitAddress varchar(255);

Update data_cleaning
SET PropertySplitAddress = SUBSTRING_INDEX(PropertyAddress, ',', 1);


ALTER TABLE data_cleaning
Add PropertySplitCity varchar(255);

Update data_cleaning
SET PropertySplitCity = SUBSTRING(PropertyAddress, LOCATE(',', PropertyAddress) + 1);

Select PropertyAddress,PropertySplitAddress,PropertySplitCity
From data_cleaning;

-- Owner Address Spliting

SELECT OwnerAddress,
    SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 1), ',', -1) AS Part3,
    SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1) AS Part2,
    SUBSTRING_INDEX(OwnerAddress, ',', -1) AS Part1
FROM data_cleaning;

SELECT
    -- Extract the street address (first part)
    SUBSTRING_INDEX(OwnerAddress, ',', 1) AS Part3,

    -- Extract the city (second part)
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1)) AS Part2,

    -- Extract the state (third part)
    TRIM(SUBSTRING_INDEX(OwnerAddress, ',', -1)) AS Part1
FROM data_cleaning;


ALTER TABLE data_cleaning
Add OwnerSplitAddress varchar(255);

Update data_cleaning
SET OwnerSplitAddress = SUBSTRING_INDEX(OwnerAddress, ',', 1);


ALTER TABLE data_cleaning
Add OwnerSplitCity varchar(255);

Update data_cleaning
SET OwnerSplitCity = SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1);



ALTER TABLE data_cleaning
Add OwnerSplitState varchar(255);

Update data_cleaning
SET OwnerSplitState = TRIM(SUBSTRING_INDEX(OwnerAddress, ',', -1));



Select OwnerAddress,OwnerSplitAddress
From data_cleaning;


-- Updating the SoldAsVacant field

select DISTINCT SoldAsVacant
from data_cleaning;

select SoldAsVacant, case when SoldAsVacant= 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end as SoldAsVacant
from data_cleaning;


update data_cleaning
set SoldAsVacant = case when SoldAsVacant= 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end ;

select SoldAsVacant, count(*)
from data_cleaning
group by SoldAsVacant;

with cte as (
select *,
row_number() OVER (Partition by 
ParcelID,
PropertyAddress,
SaleDate,
SalePrice,
LegalReference
ORDER BY UniqueID) as row_num
from data_cleaning
order by ParcelID)

delete from data_cleaning where UniqueID in (select UniqueID from cte where row_num>1);


-- delete unwanted columns

ALTER TABLE data_cleaning 
DROP COLUMN OwnerAddress,
DROP COLUMN TaxDistrict,
DROP COLUMN PropertyAddress;


desc data_cleaning;





