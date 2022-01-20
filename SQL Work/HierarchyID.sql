
use demo

--basic heirarchy ID
declare @hid hierarchyid;
set @hid='/1/2/3/4/';
select @hid, @hid.ToString();


declare @hid1 hierarchyid;
declare @hid2 hierarchyid;
set @hid1='/1/2/3/4/';
set @hid2='/1/2/3/4/5/'
select @hid1.ToString()
union
select @hid2.ToString();

declare @hid3 hierarchyid;
declare @hid4 hierarchyid;
set @hid3='/1/2/3/4/';
set @hid4='/1/2/3/4/1/'
select @hid3.ToString()as hid
union
select @hid4.ToString()as hid
order by hid

declare @hid5 hierarchyid;
declare @hid6 hierarchyid;
set @hid5='/1/2/3/4/';
set @hid6='/1/2/3/4/5/'
select @hid5.ToString()as hid
union
select @hid6.ToString()as hid
order by hid

--add decendent between

declare @rt hierarchyid;
declare @lt hierarchyid;
set @rt='/1/';
set @lt='/3/'
select @rt.GetAncestor(1).GetDescendant(@rt,@lt).ToString()

-- add a node
declare @mn1 hierarchyid;
declare @nd1 hierarchyid;
set @mn1='/2/';
select @mn1.GetDescendant(max(@nd1),null).ToString()
where @nd1.IsDescendantOf(@mn1)=1 and @nd1.GetLevel()=@mn1.GetLevel()+1


declare @mn2 hierarchyid;
declare @nd2 hierarchyid;
set @mn2='/2/';
select @mn2.GetDescendant(null,min(@nd2)).ToString()
where @nd2.IsDescendantOf(@mn2)=1 and @nd2.GetLevel()=@mn2.GetLevel()+1


declare @mn3 hierarchyid;
declare @nd3 hierarchyid;
set @mn3='/2/';
select @mn3.GetDescendant(max(@nd3),'/2/4/').ToString()
where @nd3.IsDescendantOf(@mn3)=1 and @nd3.GetLevel()=@mn3.GetLevel()+1


declare @mn4 hierarchyid;
declare @nd4 hierarchyid;
set @mn4='/2/';
select @mn4.GetDescendant('/2/3/',min(@nd4)).ToString()
where @nd4.IsDescendantOf(@mn4)=1 and @nd4.GetLevel()=@mn4.GetLevel()+1

select * from demo3;

alter table demo3
add [node] hierarchyid;

--using CTE with hierarchy id
with sibs
as
(
select id,num,cast(row_number() over (partition by num order by id)as varchar)+'/' as sib
from demo3
where id!=1
),
nd as
(select id,num,hierarchyid::GetRoot()as [node] from demo3
where id=1
union all
select p.id,p.num,cast(nd.[node].ToString()+sibs.sib as hierarchyid)as [node]
from demo3 as p
join nd on p.num=nd.id
join sibs on p.id=sibs.id
)
--select node.ToString(),* from nd
update demo3
set [node]=nd.[node]
from demo3 as p join nd
on p.id=nd.id

select *,[node].ToString() from demo3

--moving node

declare @old hierarchyid
declare @new hierarchyid
set @old='/2/'
set @new='/1/3/'

update demo3
set [node]=[node].GetReparentedValue(@old,@new)
where  [node].IsDescendantOf(@old)=1


--using triggers to check descendants

create trigger bdel on demo3 for delete
as
if exists
(select * from demo3 as p 
join deleted on p.[node].IsDescendantOf(deleted.[node])=1
and p.[node]!=deleted.[node])
begin
Raiserror('Has Descendant',16,1);
Rollback Transaction;
end

delete demo3 where [node]='/1/'
delete demo3 where [node]='/1/2/'



--trigger to find parent is missing or not
create trigger ins on demo3 for insert, update
as
if exists
(select [node].ToString() from inserted
where not exists (select [node] from demo3 where [node]=inserted.[node].GetAncestor(1))
and [node]!=hierarchyid::GetRoot())
begin
Raiserror('Missing Parent',16,1);
Rollback Transaction;
end

select *,[node].ToString() from demo3
insert into demo3 
values(12,'abcde','raman','CV',2000,'/1/2/3/4/5/',4)

--Recursion

with f1(a,b)
as
(select 3,4 
union all
select a-1,b*a from f1
where not a<=1
)
select a,b from f1;

--recursion using function
create function f1(@n1 int,@n2 int)
returns int
as
BEGIN 
if(@n1<=1) return @n2;
return dbo.f1(@n1-1,@n2*@n1);
END

select dbo.f1(3,4)

select * from f1(10,5)

--max recursion
with f1(a,b)
as
(select 500,4 
union all
select a-1,b+a from f1
where not a<=1
)
select a,b from f1
option(maxrecursion 0)

select * from demo3;

--using cte with recursion
declare @n as int
set @n=2;

with cte
as
(select id,num from demo3
where id=@n
union all
select p.id,p.num from demo3 as p
join cte on cte.id=p.num
)
select p.*,p.node.ToString() from demo3 as p
join cte on cte.id=p.num

select *,node.ToString() from demo3

--using cte in function with recursion
create function ntree(@n int)
returns table
as
return
with cte
as
(select id,num from demo3
where id=@n
union all
select p.id,p.num from demo3 as p
join cte on cte.id=p.num
and p.id!=p.num
)
select * from cte

select p.*,p.node.ToString() from demo3 as p
join ntree(2) as tree
on p.id=tree.id


with cte(num)
as
(select 1 as num 
union all select cte.num+1 from cte
where num<=10
)
select * from cte


--using pivot

select * from demo3
pivot 
(
count(id) for place in (abc,abcd,assam,xyz)
)as p

select * from demo3
pivot 
(
sum(id) for place in (abc,abcd,assam,xyz)
)as p
order by num
select * from demo3

select * from (select id, cast(num as int)as num,place from demo3) as dm
pivot
(count(id) for place in (abc,abcd,assam)
)as p


--using case statement

select cast(id as int)as id,
count(case when place='abc' then 1 end) as abc,
count(case when place='abcd' then 1 end) as abcd,
count(case when place='assam' then 1 end) as assam
from demo3
group by cast(id as int)


--using unpivot

select * into pivotdemo from demo3
pivot
(
count(id) for place in (abc,abcd,assam)
)as p

select * from pivotdemo

select * from pivotdemo
unpivot
(id for place in (abc,abcd,assam)
)as p


--security part 1

select * from sys.server_principals

create login manoj with password='password'

create user manoj

select * from demo.sys.database_principals

drop user manoj

create role myrole

--chech permissions
select * from sys.fn_my_permissions(null,'server')

select * from sys.fn_my_permissions(null,'database')

select * from sys.fn_my_permissions('demo3','object')

--to grant permission to user
--grant control server <login name>

create login mandy with password='password'

create user mannew from login [mandy] with default_schema=saucer

select * from sys.database_principals

select * from sys.fn_my_permissions('demo','database');

create schema saucer
create table pl(
	id int primary key,
	name varchar(50)
)
create table st(
	id int primary key,
	name varchar(50)
)
create table cm(
	id int primary key,
	name varchar(50)
)
create view places as
select * from pl
union
select * from st
union
select * from cm

select * from sys.schemas where name='saucer'

select o.name from sys.objects as o join sys.schemas as s
on o.schema_id=s.schema_id
where s.name='saucer'


select * from saucer.pl


create login winManoj from windows

create user winManoj