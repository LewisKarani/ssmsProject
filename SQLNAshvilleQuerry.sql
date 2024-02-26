-- Standardise date format

select *
from CleaningSQLforPortfolio.dbo.NashvilleData

select SaleDate, CONVERT(Date, SaleDate)
from CleaningSQLforPortfolio..NashvilleData

ALTER TABLE CleaningSQLforPortfolio.dbo.NashvilleData
ADD SalesDateConv Date;

UPDATE CleaningSQLforPortfolio.dbo.NashvilleData
SET SalesDateConv = CONVERT(Date, SaleDate)

select SalesDateConv, CONVERT(Date, SaleDate)
from CleaningSQLforPortfolio..NashvilleData

select a.ParcelID, a.Propertyaddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from CleaningSQLforPortfolio.dbo.NashvilleData a
JOIN CleaningSQLforPortfolio.dbo.NashvilleData b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

-- now update the table with the null propert address filled with the property address with same id

update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from CleaningSQLforPortfolio.dbo.NashvilleData a
JOIN CleaningSQLforPortfolio.dbo.NashvilleData b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

-- breaking the Address(splitting)

ALTER TABLE CleaningSQLforPortfolio.dbo.NashvilleData
ADD PropertyCityAddy nvarchar(255)
ALTER TABLE CleaningSQLforPortfolio.dbo.NashvilleData
ADD PropStreetAddy nvarchar(255)

-- split the property address to individual columns

select *, 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1),
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))
FROM CleaningSQLforPortfolio.dbo.NashvilleData

-- Update the table with the split data

UPDATE CleaningSQLforPortfolio.dbo.NashvilleData
SET PropertyCityAddy = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

UPDATE CleaningSQLforPortfolio.dbo.NashvilleData
SET PropStreetAddy = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

-- split the owner address column

ALTER TABLE CleaningSQLforPortfolio.dbo.NashvilleData
ADD OwnerAddCity nvarchar(255)
ALTER TABLE CleaningSQLforPortfolio.dbo.NashvilleData
ADD OwnerAddStreet nvarchar(255)
ALTER TABLE CleaningSQLforPortfolio.dbo.NashvilleData
ADD OwnerAddAbbrev nvarchar(255)

-- split using Parsename function
select *,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
from CleaningSQLforPortfolio.dbo.NashvilleData

-- update the added columns with this data

UPDATE CleaningSQLforPortfolio.dbo.NashvilleData
SET OwnerAddCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

UPDATE CleaningSQLforPortfolio.dbo.NashvilleData
SET OwnerAddStreet = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

UPDATE CleaningSQLforPortfolio.dbo.NashvilleData
SET OwnerAddAbbrev = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

-- Check for inconsistency in collumns anc correct it i.e set 'Y' and 'N' to "yes' and 'No'

select SoldAsVacant,
CASE
   WHEN SoldAsVacant = 'Y' THEN 'Yes'
   WHEN SoldAsVacant = 'N' THEN 'No'
   ELSE SoldAsVacant
   END
from CleaningSQLforPortfolio.dbo.NashvilleData

select * 
from CleaningSQLforPortfolio.dbo.NashvilleData

-- Deleting Duplicate rows


--WITH NumRowCTE AS(
--select *,
--ROW_NUMBER() OVER (
--    PARTITION BY ParcelID, PropertyAddress, SalePrice,SaleDate, LegalReference
--	ORDER BY UniqueID) AS row_num
--from CleaningSQLforPortfolio.dbo.NashvilleData)


-- Delete unused columns
ALTER TABLE CleaningSQLforPortfolio.dbo.NashvilleData
DROP COLUMN PropertyAddress, SaleDate, OwnerAddress, LandUse