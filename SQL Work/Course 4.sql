
--collation on instance
select SERVERPROPERTY('collation')as defcoll

--colllation on database
select DATABASEPROPERTYEX(DB_NAME(),'collation') as dbcoll

--collation of demo3 table

select name,collation_name from sys.columns
where object_id=OBJECT_ID('demo3')

SELECT firstname FROM demo3 ORDER BY firstname COLLATE Latin1_General_CS_AI;    

--collatiuon for window and sql server
SELECT name, description
FROM   sys.fn_helpcollations() 


--collation on  select

SELECT place FROM demo3
ORDER BY place
COLLATE Latin1_General_CS_AS_KS_WS ASC;

SELECT place FROM demo3
ORDER BY place
COLLATE Traditional_Spanish_ci_ai ASC;

-- table with dependencies
create table dep(
 id int primary key,
 faculty varchar(30),
 stname varchar(30)
)

--resolved
create table notdep1(
 id int primary key,
 faculty varchar(30)
)

create table notdep2(
 faculty varchar(30) foreign key references notdep1(faculty),
 stname varchar(30)
)


--posssible way sto use constraints

create table cons(
	--for null
	nid  int not null,
	--for unique
	uid int unique,
	CONSTRAINT uniq_id UNIQUE (uid),
	--for primary key
	pid int not null primary key,
	constraint pk_id primary key (pid),
	--for foreign key
	fid int foreign key references fr(id),
	constraint fr_id foreign key(fid) references fr(id),
	on update [no action, set null, cascade, set default]
	on delete [no action, set null, cascade]
	--for check
	age int CHECK (age>=18),
	CONSTRAINT ck_age CHECK (age>=18),
	--for default
	place varchar(30) DEFAULT 'assam',

)

--ways to drop constraints

--modify null
alter table cons
modify id int null

--drop primary foreign unique and check
alter table cons
drop constraint pk_id

--drop default
alter table cons
alter column place drop default

--creating view with schemabinding
create view fornew
with schemabinding 
as
select id,[name] from dbo.new

select * from new

--check if table alter's
alter table new
alter column id float

--check if table drops
drop table new

--views can not be updated

--when having group by or distinct or pivot or unpivot
create view forupdt
with schemabinding 
as
select [name] from dbo.new
group by [name]

update forupdt
set name='mandy'
where name='das'

--when having with check option
create view forchkupdt
with schemabinding 
as
select id,[name] from dbo.new
with check option

update forupdt
set name='mandy'
where name='das'


--Indexing
create clustered index indexid
on demo3(id)

select * from demo3
where id=3

--non clustered index
create nonclustered index fullname
on demo3(firstname,lastname)

select * from demo3
where firstname='ram'

select firstname,lastname from demo3
where firstname='ram'

select id,firstname from demo3
where id=1 and firstname='ram' 

--indexing for joins
select d.id,d3.id from demo d
inner merge join demo3 d3 on d3.id=d.id
where d.place='assam'

select d.id,d3.id from demo d
inner join demo3 d3 on d3.id=d.id
where d.place='assam'

select d.id,d3.id from demo d
inner hash join demo3 d3 on d3.id=d.id
where d.place='assam'

create nonclustered index filindx on demo(id)
where place='assam'

select id,place from demo
where id=5 and place='assam'

--column store index
select * from demo4

create clustered index clid on demo4(id)

drop index csid on demo4

create nonclustered columnstore index csid on demo4(id)

select id from demo4

create clustered columnstore index dm3csid on demo3


create clustered columnstore index dm3csid on demo3(place,firstname,lastname)

select * from sys.key_constraints

create table indx(
	id int,
	name varchar(20),
	roll int
)

declare @num as int=1000
while(@num<10000)
begin
insert into indx
values(@num,'abc',@num+5)
set @num+=1
end

select id,name from indx

create clustered columnstore index clindx on indx

drop index clindx on indx

create nonclustered columnstore index clindx on indx(id,[name])