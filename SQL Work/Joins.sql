
--inner joins
select top 10 
		c.[Customer Key]
		,c.Customer
		,c.Category
		,c.[Postal Code]
		,c.[Valid From]
		,d.Date
		,d.[Fiscal Month Label]
		,d.[ISO Week Number]
from Dimension.Customer c
join Dimension.Date d on c.[Valid From]=d.Date

--left outer joins
select top 10 
		c.[Customer Key]
		,c.Customer
		,c.Category
		,c.[Postal Code]
		,c.[Valid From]
		,d.Date
		,d.[Fiscal Month Label]
		,d.[ISO Week Number]
from Dimension.Customer c
left outer join Dimension.Date d on c.[Valid From]=d.Date


--right outer joins
select top 10 
		c.[Customer Key]
		,c.Customer
		,c.Category
		,c.[Postal Code]
		,c.[Valid From]
		,d.Date
		,d.[Fiscal Month Label]
		,d.[ISO Week Number]
from Dimension.Customer c
right outer join Dimension.Date d on c.[Valid From]=d.Date


select top 10
		dc.[Customer Key]
		,dc.Customer
		,dc.Category
		,fo.Description
		,fo.Package
		,fo.Quantity
		,fs.Profit
		,fs.[Unit Price]
from Dimension.Customer dc
join Fact.[Order] fo on dc.[Customer Key]=fo.[Customer Key]
join Fact.Sale fs on dc.[Customer Key]=fs.[Customer Key]


select top 10
		dc.[Customer Key]
		,dc.Customer
		,dc.Category
		,fo.Description
		,fo.Package
		,fo.Quantity
		,fs.Profit
		,fs.[Unit Price]
from Dimension.Customer dc
left join Fact.[Order] fo on dc.[Customer Key]=fo.[Customer Key]
left join Fact.Sale fs on dc.[Customer Key]=fs.[Customer Key]
where dc.[Customer Key] <> 0
