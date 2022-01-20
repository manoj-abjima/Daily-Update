use demo

--create table
create table demo2(
	id int primary key,
	place varchar(30),
	firstname varchar(30),
	lastname varchar(30)
)

--multiple insertion
insert into demo2
values(1,'abc','ram','kumar'),
	(2,'def','sham','singh'),
	(3,'xyz','rocky','kumar'),
	(4,'abc','amit','kumar'),
	(5,'asdd','ramesh','nath'),
	(6,'qwer','vinod','verma');
go

select * from demo2

--updating
update demo2
set place='ijk'
where id=4

--creating new table 
create table newdemo2(
	firstname varchar(30),
	lastname varchar(30)
)

--populating data
insert into newdemo2
select firstname,lastname from demo2
go

select * from newdemo2

--add new column
alter table newdemo2
add fullname varchar(30)

--updating column
update newdemo2
set fullname=firstname+' '+lastname

--updating with from
update demo2
set place='hello'
from demo2
inner join newdemo2 on demo2.firstname=newdemo2.firstname
where newdemo2.firstname='rocky'

select * from demo2

update demo2
set place='assam'
from demo2
inner join newdemo2 on demo2.firstname=newdemo2.firstname
where newdemo2.firstname='ram'


--compound assignment
update demo2
set id*=5
where firstname='sham'

--select using offset and fetch

select * from demo3
order by id
offset 3 rows
fetch next 3 rows only
go

declare @n as int=(select count(id) from demo)
select * from demo2
order by id
offset @n-6 rows
fetch next 5 rows only
go

--merge
merge into demo2 using newdemo2
on demo2.firstname=newdemo2.firstname
when matched and (demo2.firstname!='vinod')
then
update
set lastname='kumar';
go

select * from newdemo2

merge into newdemo2 using demo2
on demo2.firstname=newdemo2.firstname
when matched and (demo2.firstname!='sham')
then
update
set lastname='kumar'
when not matched by target
then
insert (firstname,lastname) 
values(firstname,lastname);
go

--using CTE (Common Table Expression)

WITH CTE_demo2   
AS  
-- Define the CTE query.  
(  
    SELECT * 
    FROM demo2  
	order by id
	offset 3 rows
	fetch next 3 rows only
)  
update CTE_demo2
set id+=10;
go

--using CTE to fetch bottom 5 rows in asc
WITH CTE_rows   
AS    
(  
    SELECT top(5)* FROM demo2  
	order by id desc
)  
select * from CTE_rows
order by id asc
go

select* from demo2


--using write keyword

alter table newdemo2
alter column fullname varchar(max)


update newdemo2
set fullname.write('My name is ',0,0);

update newdemo2
set fullname.write(' ,Hello ',null,null);

select * from newdemo2


--using output clause

insert into demo2
output inserted.id,inserted.place,inserted.firstname,inserted.lastname
values(12,'wxyz','abhi','pratap')

--multiple row using output
insert into demo2
output inserted.id,inserted.place,inserted.firstname,inserted.lastname
values(18,'wxyz','rahul','raj'),
	  (13,'bca','mandy','singh'),
	  (14,'zyx','lucky','kohli'),
	  (15,'zyxw','jordan','kane')


--update using output 
update demo2
set place='assam'
output inserted.id,inserted.place as new,deleted.place as old
where id between 13 and 20

select * from demo2


--using TOP
select top(5)* from demo2

select top(5)id,place,demo2.firstname,demo2.lastname,fullname 
from demo2
inner join newdemo2 
on demo2.firstname=newdemo2.firstname

declare @num as int=4
select top(@num)* from demo2

declare @pct as int=30
select top(@pct)percent id from demo2

update top(5) demo2
set place='abc'

update demo2
set place='abc'
from(select top(5)id from demo2) as new
where demo2.id=new.id



--explicit transaction
begin transaction
	update demo2
	set place='abcd'
	where id=12
	if @@ROWCOUNT=0
		begin
			rollback transaction
			raiserror('Error found',16,1);
		end
	else
		begin
			commit transaction
		end
go

begin transaction
	update demo2
	set place='abcd'
	where id=92
	if @@ROWCOUNT=0
		begin
			rollback transaction
			raiserror('Error found',16,1);
		end
	else
		begin
			commit transaction
		end
go


--Error handling
begin try
	set xact_abort on
	begin transaction
	update demo2
	set place='abcd'
	where id=92
	if @@ROWCOUNT=0
		begin
			rollback transaction
			raiserror('Error found',16,1);
		end
	commit transaction
end try
begin catch
	if @@TRANCOUNT>0
	begin
		rollback transaction
	end
	select ERROR_MESSAGE() as errormsg
end catch


begin try
	set xact_abort on
	begin transaction
	update demo2
	set place='abcd'
	where id=3
	if @@ROWCOUNT=0
		begin
			rollback transaction
			raiserror('Error found',16,1);
		end
	commit transaction
end try
begin catch
	if @@TRANCOUNT>0
	begin
		rollback transaction
	end
	select ERROR_MESSAGE() as errormsg
end catch


--using group by

select lastname from demo2
group by lastname

select firstname,lastname from demo2
group by firstname,lastname

select lastname,count(*)as count from demo2
group by lastname

select lastname,count(*)as count from demo2
group by lastname
having lastname='kumar'

alter table demo2
add salary int

update demo2
set salary='2000'

select lastname,count(*) as count,sum(salary)as total from demo2
group by lastname

select lastname,count(*) as count,sum(salary)as total from demo2
group by lastname
having lastname='kumar'

--using CTE and Ranking

with newdemo(id,[address],[name],amount)
as
(select id,place,(firstname+lastname),salary from demo2)
select * from newdemo

select top 10 * from demo2
order by round(salary,0)

select top 5 with ties * from demo2
order by round(salary,0)

--top random data
select top(cast(rand()*10 as int))* from demo2

--delete  to in chunks min max lock/resources

select * into demo3 from demo2

updatemore:
delete top(2) demo2
if @@rowcount!=0
goto updatemore

select * from demo2

--Row Number
select *,row_number() over (order by salary) as row_num
from demo3

select *,row_number() over (order by id) as row_num
from demo3

select *,row_number() over (order by place) as row_num
from demo3
go

with rn
as
(select *,row_number() over (order by place) as row_num
from demo3)
select * from rn
where row_num between 5 and 10

--using function with CTE
create function getdata(@page int, @ps int)
returns table
as 
return
with rn
as
(select *,row_number() over (order by place) as row_num
from demo3)
select * from rn
where row_num between (@page-1)*@ps and (@page*@ps)

select * from getdata(1,4)
select * from getdata(2,4)
select * from getdata(3,4)

--Ranking

select *,rank() over (order by lastname)as rnk
from demo3

select *,rank() over (order by id)as rnk
from demo3

select *,rank() over (order by place)as rnk
from demo3

--Dense Ranking

select *,rank() over (order by lastname)as rnk, dense_rank() over (order by lastname)as rnk
from demo3

select *,rank() over (order by id)as rnk, dense_rank() over (order by id)as rnk
from demo3

select *,rank() over (order by place)as rnk, dense_rank() over (order by place)as rnk
from demo3

--Ntile function

select *, ntile(1) over (order by id) as [ntile]
from demo3

select *, ntile(3) over (order by id) as [ntile]
from demo3

select *, ntile(7) over (order by id) as [ntile]
from demo3

select *, ntile(10) over (order by id) as [ntile]
from demo3

--passing expression in ntile

select *, ntile((select sum(id)/20 from demo3)) 
over (order by id) as [ntile]
from demo3


select *, ntile((select count(id)/5 from demo3)) 
over (order by id) as [ntile]
from demo3

--Partitioning with rank

select *, rank() over (partition by lastname order by id ) as rnk_part 
from demo3

select *, rank() over (partition by id order by id ) as rnk_part 
from demo3

select *, rank() over (partition by place order by id ) as rnk_part 
from demo3

--Partitioning with ntile

select *, ntile(3) over (partition by lastname order by id ) as ntile_part
from demo3

select *, ntile(2) over (partition by place order by id ) as ntile_part
from demo3

select *, ntile(3) over (partition by id order by id ) as ntile_part
from demo3

--Aggrigate Partition

select *, salary - sum(salary) over(partition by salary)as tot
from demo3

select *, salary - avg(salary) over(partition by salary)as tot
from demo3

select *, salary - sum(id) over(partition by salary)as tot
from demo3

select *, salary - avg(id) over(partition by lastname)as tot
from demo3