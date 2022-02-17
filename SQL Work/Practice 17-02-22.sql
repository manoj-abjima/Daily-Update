

--adding 1st char of city to name

SELECT CONCAT(name, '(', SUBSTRING(city, 1, 1),')') 
FROM teacher;

select * from teacher


create table emp(
	id int primary key identity,
	Dept varchar(30),
	Ename varchar(30),
	salary int
)

insert into emp
values('Designer','ram',2000),
		('Designer','sham',3000),
		('Designer','Lee',1500),
		('Dev','John',1000),
		('Dev','Amit',5000),
		('Dev','Sam',3000),
		('Test','Rita',7000),
		('Test','Sita',2500),
		('Test','Gita',2500)

--select emp having max salary from each dept
	
	--Method 1

	with cte
	as
	(
		select *,ROW_NUMBER() over (partition by dept order by salary desc)as rn from emp
	)
	select id,dept,Ename,salary from cte where rn=1

	--Method 2

	select id,dept,Ename,salary from (select *,ROW_NUMBER() over (partition by dept order by salary desc)as rn from emp)as r
	where rn=1

--concating all name in single line

	select Ename+',' from emp
	for xml path('')

--employee having similar salary

	SELECT *
	FROM emp 
	WHERE Salary IN (
		SELECT Salary
		FROM emp
		GROUP BY Salary
		HAVING COUNT(salary) > 1
	)

--employee not having similar salary

	SELECT *
	FROM emp 
	WHERE Salary not IN (
		SELECT Salary
		FROM emp
		GROUP BY Salary
		HAVING COUNT(salary) > 1
	)

--Exchange dept of employee

	UPDATE emp 
	SET Dept =CASE Dept
				WHEN 'Dev' THEN 'Test'
				WHEN 'Test' THEN 'Designer'
				WHEN 'Designer' THEN 'Dev'
				ELSE Dept END;

	select * from emp

create table rec(
	measure float
)

insert into rec
values(3.2),(4.6),(19.43),(45.23),(51.4),(4.66),(67.82)

--seperate int & float num

select measure,floor(measure) as [Int],measure-floor(measure)as [Float] from rec