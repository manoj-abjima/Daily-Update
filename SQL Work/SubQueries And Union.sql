

--Sub Query

select [Description]
		,[Unit Price]-(select avg([Unit Price]) from Fact.[Order])
from Fact.[Order]


select top 20
		c.Customer
		,c.Category
from  Dimension.Customer c
where c.Category in (select Category from Dimension.Supplier)


select 
		c.[Description]
		,c.[Unit Price]-ag.avrg
from Fact.[Order] c
inner join (
			select [Customer Key],avg([Unit Price]) avrg
			from Fact.[Order]
			group by [Customer Key]
			)ag on ag.[Customer Key]=c.[Customer Key]


select top 20
		c.Customer
		,c.Category
		,c.[Valid From]
from  Dimension.Customer c
where exists (select [Valid From] 
				from Dimension.Supplier ds
				where ds.[Supplier Key]=c.[Customer Key])


--Union and Union All

select 
		dc.Customer
		,dc.Category
		,dc.[Valid From]
		,dc.[Primary Contact]
from Dimension.Customer dc
union
select 
		ds.Supplier
		,ds.Category
		,ds.[Valid From]
		,ds.[Primary Contact]
from Dimension.Supplier  ds


select 
		dc.Customer
		,dc.Category
		,dc.[Valid From]
		,dc.[Primary Contact]
from Dimension.Customer dc
union all
select 
		ds.Supplier
		,ds.Category
		,ds.[Valid From]
		,ds.[Primary Contact]
from Dimension.Supplier  ds