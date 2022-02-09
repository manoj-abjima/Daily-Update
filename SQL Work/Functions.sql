

--Multi statement Scaler function
create function addnum(@n1 int,@n2 int)
returns int
as
begin 
	return @n1+@n2
end

select dbo.addnum(2,3) as [add]


create function f1(@n1 int,@n2 int)
returns int
as
BEGIN 
if(@n1<=1) return @n2;
return dbo.f1(@n1-1,@n2*@n1);
END

select dbo.f1(3,4)


--Table Value function
create function getdata(@page int, @ps int)
returns table
as 
return
select * from demo3
where id between (@page-1)*@ps and (@page*@ps)


create function get_page_data(@page int, @ps int)
returns table
as 
return
with rn
as
(
	select *,row_number() over (order by place) as row_num
	from demo3
)
select * from rn
where row_num between (@page-1)*@ps and (@page*@ps)


--Multi Statement Table Value function
create or alter function tabadd(@n1 int, @n2 int)
returns @addtab table
(val int)
as
begin
	insert into @addtab (val)
	select @n1+@n2;
	return;
end

select * from tabadd(3,4)

--Inline table value function
create function inadd(@n1 int, @n2 int)
returns table
with schemabinding
as
return( select @n1+@n2 as addition);


create function CTE_add(@n1 int, @n2 int)
returns table
with schemabinding
as
return(
	with cte
	as
	(
		select @n1+@n2 as addition 
	)
	select addition from cte
)

set statistics time on

--Multistatement TVF

create or alter function avgSale(@id int)
returns @avgTable table
(
	id int,
	minsale decimal(9,2),
	maxsale decimal(9,2),
	avgsale decimal(9,2)
)
with schemabinding
as
begin
	insert into @avgTable
	select  o.[Order Key],min(ol.Total) Minimum,max(ol.Total) Maximum,avg(ol.Total) Average
	from Fact.[Order] o
	cross apply(
			select sum(Quantity+[Unit Price]) Total
			from Fact.[Order]
			where [Order Key]=o.[Order Key]
	)ol
	where o.[Customer Key]=@id
	group by o.[Order Key]
	return;
end

select * from avgsale(8)

--Inline TVF

create or alter function itvf_avgSale(@id int)
returns table
with schemabinding
as
return(
	select  o.[Order Key],min(ol.Total) Minimum,max(ol.Total) Maximum,avg(ol.Total) Average
	from Fact.[Order] o
	cross apply(
			select sum(Quantity+[Unit Price]) Total
			from Fact.[Order]
			where [Order Key]=o.[Order Key]
	)ol
	where o.[Customer Key]=@id
	group by o.[Order Key]
)

select * from itvf_avgsale(8)