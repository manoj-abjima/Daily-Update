
--String Function

	--return ascii no.
	SELECT ASCII('b') AS NumCodeOfFirstChar

	--return index of c
	SELECT CHARINDEX('c', 'abcd') AS strg

	--return char of code 51
	SELECT CHAR(51) AS strg

	--not working
	SELECT CONCAT_WS('.', 'manoj', 'kumar', 'das')as conName

	--returns length with leading and trailing spaces
	SELECT DATALENGTH('manojdas') --8

	SELECT DATALENGTH(' manojdas ') --10

	--returns length without trailing spaces
	SELECT LEN(' manojdas ') --9

	--formats date
	DECLARE @d DATETIME = '01/01/2022'
	SELECT FORMAT (@d, 'd', 'no') AS 'Norwegian Result'

	--format no.
	SELECT FORMAT(123456789, '*##*##-##*#')

	--return 5 char from left
	SELECT LEFT('manojdas', 5) AS strng;

	--return index of char
	SELECT PATINDEX('%s%', 'manojdas')

	SELECT PATINDEX('%[ol]%', 'W3Schools.com');

	--repeats string
	SELECT REPLICATE('manoj ', 3)

	--returns no. as str
	SELECT STR(185.476, 5, 4)

	--remove 3 char from 1 and add 2nd str to 1
	SELECT STUFF('das das', 1, 3, 'manoj')

	--return NULL
	SELECT STUFF('das das', 8, 3, 'manoj')

	--return 3 char from 1
	SELECT SUBSTRING('manojdas', 1, 3) AS substr;

	--translate 1 arg from 2nd arg char to 3 arg 
	SELECT TRANSLATE('Monday', 'Mon', 'Sun');

--Number Function
	
	--Celing
	SELECT CEILING(25.75) AS ceil

	--Floor
	SELECT FLOOR(25.75) AS Floor

	--Power
	SELECT POWER(4, 2)

	--Random
	SELECT floor(RAND()*10)

	--Round
	SELECT ROUND(235.415, 2) AS Round
	SELECT ROUND(235.715, 0) AS Round
	SELECT ROUND(235.415, -1) AS Round

	--Sign
	SELECT SIGN(255.5)
	SELECT SIGN(-20)
	SELECT SIGN(0)

	--Square Root
	SELECT SQRT(64)

	--Square
	SELECT SQUARE(4)


--Date Function
	
	--Current date & time
	SELECT CURRENT_TIMESTAMP

	--Add Date
	SELECT DATEADD(year, 1, '2022/02/16') AS Addyear
	SELECT DATEADD(month, 2, '2022/02/16') AS Addmonth
	SELECT DATEADD(month, -2, '2022/02/16') AS Addmonth
	SELECT DATEADD(day, 2, '2022/02/16') AS AddDay

	--Date Difference
	SELECT DATEDIFF(year, '2012/01/01', '2022/01/01') AS DateDiff
	SELECT DATEDIFF(month, '2019/01/01', '2022/01/01') AS DateDiff
	SELECT DATEDIFF(day, '2021/01/01', '2022/01/01') AS DateDiff
	SELECT DATEDIFF(hour, '2022/02/16 10:00', '2022/02/16 18:00') AS DateDiff

	--Date Name
	SELECT DATENAME(year, '2022/01/01') AS DatePartString
	SELECT DATENAME(month, '2022/01/01') AS DatePartString
	SELECT DATENAME(day, '2022/01/01') AS DatePartString

	--Day
	SELECT day('2022/01/01') AS MonthDay

	--Month
	SELECT month('2022/01/01') AS dateMonth

	--Year
	SELECT year('2022/01/01') AS dateYear

	--Current date
	SELECT GETDATE()		--return current date time
	SELECT GETUTCDATE()		--return current utc date time

	--check date format
	SELECT ISDATE('2022-01-01')

	--system Date
	SELECT SYSDATETIME() AS SysDateTime

	--return quater
	select DATEPART(quarter,'10-11-2021') as dt

--Advance Function
	
	--converts to any datatype
	SELECT CAST(25.65 AS int)
	SELECT CAST(25.65 AS varchar)
	SELECT CAST('a' AS int) --can not convert

	--User
	SELECT CURRENT_USER

	--IIF
	SELECT IIF(500<1000, 'YES', 'NO')

	--IsNull
	SELECT ISNULL(NULL, 'manoj')
	SELECT ISNULL('Hello', 'manoj')


--using merge
create table trgt
(
	id int,
	name varchar(100)
)

create table src
(
	id int,
	name varchar(100)
)

insert into trgt
values(1,'abc'),
		(2,'def'),
		(3,'xyz')

insert into src
values(2,'ijk'),
		(4,'lmn'),
		(6,'opq')

merge trgt t
using src s
on t.id=s.id
when matched then
	update set t.name=s.name
when not matched then
	insert values(s.id,s.name)
output $action as action
	,inserted.id as [newid]
	,inserted.name as newname
	,deleted.id as oldid
	,deleted.name as oldname;