-- Cleaning the data.

SELECT * FROM ProtifolioProject..Nashville_housing

-- Standrizing sale date.
SELECT SaleDateConverted
FROM ProtifolioProject..Nashville_housing

ALTER TABLE Nashville_housing
ADD SaleDateConverted DATE;

UPDATE Nashville_housing
 SET SaleDateConverted = CONVERT(DATE,SaleDate)


 -- populate property address data


SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM ProtifolioProject..Nashville_housing a
	JOIN ProtifolioProject..Nashville_housing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM ProtifolioProject..Nashville_housing a
	JOIN ProtifolioProject..Nashville_housing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL


-- Breaking out addresses into individual columns(Address,city,state)

SELECT 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) As address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) As address
FROM ProtifolioProject..Nashville_housing


ALTER TABLE Nashville_housing
ADD PropertySplitAddress VARCHAR(255);

UPDATE Nashville_housing
 SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)


ALTER TABLE Nashville_housing
ADD PropertySplitCity VARCHAR(255);

UPDATE Nashville_housing
 SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))


 SELECT *
 FROM ProtifolioProject..Nashville_housing


 
 SELECT OwnerAddress
 FROM ProtifolioProject..Nashville_housing



 SELECT 
 PARSENAME(REPLACE(OwnerAddress,',','.'),3),
 PARSENAME(REPLACE(OwnerAddress,',','.'),2),
 PARSENAME(REPLACE(OwnerAddress,',','.'),1)
 FROM ProtifolioProject..Nashville_housing



 
ALTER TABLE Nashville_housing
ADD OwnerSplitAddress VARCHAR(255);

UPDATE Nashville_housing
 SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)


ALTER TABLE Nashville_housing
ADD OwnerSplitCity VARCHAR(255);

UPDATE Nashville_housing
 SET OwnerSplitCity =  PARSENAME(REPLACE(OwnerAddress,',','.'),2)


 
ALTER TABLE Nashville_housing
ADD OwnerSplitState VARCHAR(255);

UPDATE Nashville_housing
 SET OwnerSplitState =  PARSENAME(REPLACE(OwnerAddress,',','.'),1)


 SELECT *
 FROM ProtifolioProject..Nashville_housing


 -- Change Y and N to Yes and NO in 'sold as Vacant' field


 SELECT DISTINCT(SoldAsVacant),COUNT(SoldAsVacant)
 FROM ProtifolioProject..Nashville_housing
 GROUP BY SoldAsVacant
 ORDER BY 2


 SELECT SoldAsVacant,
 CASE when SoldAsVacant	= 'Y' THEN 'Yes'
	  when SoldAsVacant = 'N' THEN 'NO'
	  ELSE SoldAsVacant
	  END
 FROM ProtifolioProject..Nashville_housing

 UPDATE Nashville_housing
 SET SoldAsVacant =  CASE when SoldAsVacant	= 'Y' THEN 'Yes'
	  when SoldAsVacant = 'N' THEN 'NO'
	  ELSE SoldAsVacant
	  END


-- Romove Duplicates


WITH RowNumCTE AS(
 SELECT *, ROW_NUMBER() OVER (
 PARTITION BY ParcelID,
			  PropertyAddress,
			  SalePrice,
			  SaleDate,
			  LegalReference
			  ORDER BY
				UniqueID
			  
 ) RowNum
 FROM ProtifolioProject..Nashville_housing
)
DELETE
FROM RowNumCTE
WHERE RowNum > 1


-- Delete unused columns
SELECT *
FROM ProtifolioProject..Nashville_housing


ALTER TABLE ProtifolioProject..Nashville_housing
DROP COLUMN OwnerAddress, TaxDistrict,PropertyAddress

ALTER TABLE ProtifolioProject..Nashville_housing
DROP COLUMN SaleDate