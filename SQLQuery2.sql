--cleaning data in sql project

SELECT *
FROM housing..Sheet1$

--Standarize data format 


SELECT SaleDateConverted,Convert(Date,SaleDate)
FROM housing..Sheet1$
UPDATE Sheet1$
SET SaleDate=CONVERT(Date,SaleDate)
ALTER TABLE Sheet1$
ADD SaleDAteConverted DAte;
UPDATE Sheet1$
SET SaleDateConverted=CONVERT(Date,SaleDate)


--Property address data
--SELECT PropertyAddress
SELECT *
FROM housing..Sheet1$
--WHERE PropertyAddress is null
ORDER BY ParcelID


SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM housing..Sheet1$ a
JOIN housing..Sheet1$ b
ON a.ParcelID=b.ParcelID
AND a.[UniqueID ]<>b.[UniqueID ]
WHERE a.PropertyAddress is null

UPDATE a
SET PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM housing..Sheet1$ a
JOIN housing..Sheet1$ b
ON a.ParcelID=b.ParcelID
AND a.[UniqueID ]<>b.[UniqueID ]
WHERE a.PropertyAddress is null

--breaking address into individual columns(address,city,states)

SELECT PropertyAddress
FROM housing..Sheet1$
Select
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)as Address
,SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)+1),LEN(PropertyAddress)as Address
FROM housing..Sheet1$



ALTER TABLE Sheet1$
ADD  PROPERTYSPLITADDRESS Nvarchar(255);

UPDATE Sheet1$
SET PROPERTYSPLITADDRESS=SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)



ALTER TABLE Sheet1$
ADD  PROPERTYSPLITADDRESS Nvarchar(255);

UPDATE Sheet1$
SET SaleDateConverted=SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)+1)


SELECT *
FROM housing..Sheet1$


SELECT OwnerAddress
FROM housing..Sheet1$

select 
PARSENAME(REPLACE(OwnerAddress,',','.'),3)
,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
,PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM housing..Sheet1$

ALTER TABLE housing..Sheet1$
ADD OwnerSplitAddress Nvarchar(255);

UPDATE Sheet1$
SET OwnerSplitAddress=PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE Sheet1$
ADD OwnerSplitCity Nvarchar(255);
UPDATE Sheet1$
SET OwnerSplitCity=PARSENAME(REPLACE(OwnerAddress,',','.'),2)
ALTER TABLE Sheet1$
ADD OwnerSplitState Nvarchar(255);
UPDATE Sheet1$
SET OwnerSplitCity=PARSENAME(REPLACE(OwnerAddress,',','.'),1)
Select *
From housing..Sheet1$



-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From housing..Sheet1$
Group by SoldAsVacant
order by 2
Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
	   From housing..Sheet1$
	   UPDATE housing..Sheet1$
	   SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

	   
-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From housing..Sheet1$
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



-- Delete Unused Columns
ALTER TABLE housing..Sheet1$
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
Select *
From housing..Sheet1$
