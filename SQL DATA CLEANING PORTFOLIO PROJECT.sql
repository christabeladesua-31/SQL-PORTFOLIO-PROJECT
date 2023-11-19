select*
from [SQL PORTFOLIO PROJECT]..[nashville housing]

--standardizing date format
select saledateconverted, convert(date, saledate)
from [SQL PORTFOLIO PROJECT]..[nashville housing]

update [nashville housing]
set SaleDate = convert (date,saledate)

alter table [nashville housing]
add saledateconverted date

update [nashville housing]
set Saledateconverted = convert (date,saledate)

--populate property addresss data
select*
from [SQL PORTFOLIO PROJECT]..[nashville housing]
--where PropertyAddress is null
order by ParcelID

select A.ParcelID, A.PropertyAddress, B.ParcelID, B.PROPERTYADDRESS, ISNULL(A.PROPERTYADDRESS, B.PROPERTYADDRESS)
from [SQL PORTFOLIO PROJECT]..[nashville housing] A
join [SQL PORTFOLIO PROJECT]..[nashville housing] B
    ON A.ParcelID = B.PARCELID
	AND A.[UniqueID ] <> B.[UniqueID ]
WHERE A.PropertyAddress IS NULL

UPDATE A
SET PROPERTYADDRESS = ISNULL(A.PROPERTYADDRESS, B.PROPERTYADDRESS)
from [SQL PORTFOLIO PROJECT]..[nashville housing] A
join [SQL PORTFOLIO PROJECT]..[nashville housing] B
    ON A.ParcelID = B.PARCELID
	AND A.[UniqueID ] <> B.[UniqueID ]
WHERE A.PropertyAddress IS NULL

--BREAKING OUT ADDRESSINTO INDIVIDUAL COLUMNS (ADDRESS, CITY, STATE)
select PropertyAddress
from [SQL PORTFOLIO PROJECT]..[nashville housing]

SELECT 
SUBSTRING(PROPERTYADDRESS, 1, CHARINDEX(',',PROPERTYADDRESS) -1) AS ADDRESS
 ,SUBSTRING(PROPERTYADDRESS, CHARINDEX(',',PROPERTYADDRESS) , LEN(PROPERTYADDRESS)) AS ADDRESS 
FROM [SQL PORTFOLIO PROJECT]..[nashville housing]

update [nashville housing]
SET PROPERTYSPLITADDRESS = SUBSTRING(PROPERTYADDRESS, 1, CHARINDEX(',', PROPERTYADDRESS) -1)

alter table [nashville housing]
add PROPERTYSPLITADDRESS NVARCHAR(255);

update [nashville housing]
SET PROPERTYSPLITCITY = SUBSTRING(PROPERTYADDRESS, CHARINDEX(',', PROPERTYADDRESS) +1, LEN(PROPERTYADDRESS))

alter table [nashville housing]
add PROPERTYSPLITCITY NVARCHAR(255);

select 
parsename(replace(OwnerAddress, ',','.'),3)
,parsename(replace(OwnerAddress, ',','.'),2)
,parsename(replace(OwnerAddress, ',','.'),1)
from [SQL PORTFOLIO PROJECT]..[nashville housing]


update [nashville housing]
SET OWNERSPLITADDRESS = parsename(replace(OwnerAddress, ',','.'),3)

alter table [nashville housing]
add OWNERSPLITADDRESS NVARCHAR(255);

update [nashville housing]
SET OWNERSPLITCITY = parsename(replace(OwnerAddress, ',','.'),2)

alter table [nashville housing]
add OWNERSPLITCITY NVARCHAR(255);

update [nashville housing]
SET OWNERSPLITSTATE = parsename(replace(OwnerAddress, ',','.'),1)

alter table [nashville housing]
add OWNERSPLITSTATE NVARCHAR(255);

--change y and n to yes and no in sold as vacant field
select distinct(soldasvacant), count(soldasvacant)
from [SQL PORTFOLIO PROJECT]..[nashville housing]
group by SoldAsVacant
order by 2

select soldasvacant
, case when SoldAsVacant = 'y' then 'yes'
       when SoldAsVacant = 'n' then 'no'
	   else SoldAsVacant
	   end
from [SQL PORTFOLIO PROJECT]..[nashville housing]

update [nashville housing]
set SoldAsVacant = case when SoldAsVacant ='y' then 'yes'
        when SoldAsVacant = 'n' then 'no'
		else SoldAsVacant
		end

--remove duplicates
with rownumcte as(
select *,
  row_number() over(
  partition by parcelid ,
               propertyaddress,
			   saleprice,
			   saledate,
			   legalreference
			   order by
			     uniqueid
				  )row_num

from [SQL PORTFOLIO PROJECT]..[nashville housing]
--order by ParcelID
)
select *
from rownumcte 
where row_num > 1
order by PropertyAddress

--delete unused columns
select *
from [SQL PORTFOLIO PROJECT]..[nashville housing]

alter table [SQL PORTFOLIO PROJECT]..[nashville housing]
drop column owneraddress, taxdistrict, propertyaddress

alter table [SQL PORTFOLIO PROJECT]..[nashville housing]
drop column saledate
