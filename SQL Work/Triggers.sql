

--preventing delete or alter in table

create or alter trigger pretrig
on database 
for drop_table,alter_table
as 
begin
print 'drop and alter table events are not allowed'
rollback
end;

drop table demo2

--Log DDL events to table

create table logs(
	id int identity,
	eventTime datetime,
	eventType nvarchar(100),
	loginName nvarchar(100),
	command nvarchar(max)
)

--trigger to store logs

create or alter trigger logs
on database
for ddl_database_level_events
as
begin
set nocount on
declare @eventdata xml=eventdata()
insert into logs(eventTime,eventType,loginName,command)
select @eventdata.value('(/EVENT_INSTANCE/PostTime)[1]','DATETIME'),
		@eventdata.value('(/EVENT_INSTANCE/EventType)[1]','varchar(100)'),
		@eventdata.value('(/EVENT_INSTANCE/LoginName)[1]','varchar(100)'),
		@eventdata.value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]','nvarchar(max)')
end

disable trigger pretrig on database

alter table demo2
add newtab4 varchar(100)

enable trigger pretrig on database

select * from logs