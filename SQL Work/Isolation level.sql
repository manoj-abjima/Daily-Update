

--Read Uncommitted
	set transaction isolation level read uncommitted

	begin tran
		select * from Dimension.Customer

		select * from Dimension.Customer
	commit

	--Dirty Read
	begin tran
		update Dimension.Customer
		set Category='New'
		where [Customer Key]=1
	rollback;

--Read Commit
	set transaction isolation level read committed

	begin tran
		select * from Dimension.Customer

		select * from Dimension.Customer
	commit

	--Dirty Read
	begin tran
		update Dimension.Customer
		set Category='New'
		where [Customer Key]=1
	rollback;

	--Non Repeatable Read
	begin tran
		update Dimension.Customer
		set Category='New'
		where [Customer Key]=1
	commit;

	begin tran
		update Dimension.Customer
		set Category='Novelty Shop'
		where [Customer Key]=1
	commit;

--Repeatable Read
	set transaction isolation level repeatable read;

	begin tran;
		select * from Dimension.Customer;

		select * from Dimension.Customer;
	commit;

	--Non Repeatable Read
	set lock_timeout -1
	begin tran;
		update Dimension.Customer
		set Category='New'
		where [Customer Key]=1;
	commit;

	begin tran
		update Dimension.Customer
		set Category='Novelty Shop'
		where [Customer Key]=1
	commit;


--Snapshot Isolation lavel

	alter database [WideWorldImportersDW] set allow_snapshot_isolation on;
	go

	set transaction isolation level snapshot 
	set lock_timeout 15000;

	begin tran
		update Dimension.Customer
		set Category='Shop'
		where [Customer Key]=1;
		waitfor delay '00:00:15';
	rollback;

	select * from Dimension.Customer


--Deadlock

	--User1

	declare @txt varbinary(10)=cast('manoj' as varbinary)
	set context_info @txt
	set lock_timeout -1

	begin tran
		update Dimension.Customer
		set Category='Shop'
		where [Customer Key]=1;

		update Dimension.City
		set Country='US'
		where [City Key]=1;
	rollback;

	--User2

	declare @txt varbinary(10)=cast('das' as varbinary)
	set context_info @txt
	set lock_timeout -1

	begin tran
		update Dimension.City
		set Country='US'
		where [City Key]=1;

		update Dimension.Customer
		set Category='Shop'
		where [Customer Key]=1;
	rollback;