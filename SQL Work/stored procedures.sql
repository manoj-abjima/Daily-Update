USE [demo]

--select procedure
create procedure [dbo].[newproc]
as
select * from demo
GO

--insert procedure
create procedure [dbo].[insproc]
as
insert into demo
values('das',10)
GO

--delete procedure
create procedure [dbo].[deleteproc]
as
delete from demo
where id=10
GO

--insert with parameters
create procedure [dbo].[insertproc](
@name varchar(20),
@id integer
)
as
insert into demo
values(@name,@id)
GO

--update procedure
CREATE procedure [dbo].[updatedata](
@name varchar(20),
@id integer
)
as
	update demo
	set name=@name
	where id=@id
GO

--procedure with statement type
CREATE procedure [dbo].[inssel](
@name varchar(20),
@id integer,
@StatementType varchar(20)=''
)
as
begin
	if @StatementType = 'Insert'
		begin
		insert into demo
		values(@name,@id)
		end
	if @StatementType = 'Select'
		begin
		select * from demo
		where name=@name
		end
end
GO

--using string split
create procedure mulinsert
(
@id int,
@place varchar(30)
)
as
begin;

insert into demo(id,place)
select @id,value from string_split(@place,',');

select * from demo 
where id=@id
end;

exec  mulinsert 
@id=23,
@place='assam.,abcd.,abcde!';

go 

--using user type parameters
create type placename
as table
(
place varchar(30) not null
);

create procedure typeinsrt
(
@id int,
@place placename readonly
)
as
begin;

insert into demo(id,place)
select @id,place from @place;

select * from demo 
where id=@id
end;

declare @plc placename

insert into @plc (place)
values 
('hii'),
('how'),
('r u')

exec typeinsrt
@id=23,
@place=@plc