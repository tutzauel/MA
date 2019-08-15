/*
	- Sliding Window
	- Sliding Window in einer StoredProcedure
*/

Use GrundlagenPartitionierung
go
--Partitionsfunktion erstellen
Create Partition Function myPartitionFunction(datetime) AS
Range LEFT FOR VALUES ('20030201', '20030301', '20030401')
go

--Partitionsschema erstellen
Create Partition Scheme myPartitionScheme AS
Partition myPartitionFunction to (fg01, fg02, fg03, fg04)
go

--Tabelle erstellen
Create Table myOrderTable
(
	OrderID int identity NOT NULL,
	OrderDate datetime NOT NULL,
	Amount int,
	ProduktID int,
	Constraint PK_myOrderTable primary key clustered (OrderID, OrderDate)
				ON myPartitionScheme(OrderDate)
) on myPartitionScheme(OrderDate)
go

--Tabelle mit Daten füllen
declare @OrderDate Datetime
Declare @i int
set @OrderDate = '20030401'
set @i = 0

while @i < 30
	Begin
			insert myOrderTable(OrderDate, Amount, ProduktID)
			values (@OrderDate + @i, @i + 5, @i) 
			set @i = @i + 1
	end

--View zur besseren Darstellung erstellen
Create View PartitionInfo as
select OBJECT_NAME (i.object_id) as Objekt_Name,
p.partition_number,fg.NAME as filegroup_name, rows, au.total_pages,
case boundary_value_on_right
when 1 then 'less than'
 ELSE 'Less or equal than' END AS 'Comparition', VALUE
 FROM sys.partitions p JOIN sys.indexes i
 ON p.object_id = i.object_id AND p.index_id = i.index_id
 JOIN sys.partition_schemes ps
 ON ps.data_space_id = i.data_space_id
 JOIN sys.partition_functions f
 ON f.function_id = ps.function_id
 LEFT JOIN sys.partition_range_values rv
 ON f.function_id = rv.function_id
 AND p.partition_number = rv.boundary_id
 JOIN sys.destination_data_spaces dds
 ON dds.partition_scheme_id = ps.data_space_id
 AND dds.destination_id = p.partition_number
 JOIN sys.filegroups fg
 ON dds.data_space_id = fg.data_space_id
 JOIN (SELECT container_id, SUM(total_pages) as total_pages
 FROM sys.allocation_units
 Group by container_id) as au
 ON au.container_id = p.partition_id
 Where i.index_id <2
 go

select * from PartitionInfo

Truncate Table myOrderTable with (Partitions(1))
Go
select * from PartitionInfo

--Next Used fg = fg01
Alter Partition SCHEME myPartitionScheme NEXT USED fg01
go
Alter Partition Function myPartitionFunction() Split Range ('20030501') 
go

select * from PartitionInfo 

Alter Partition Function myPartitionFunction()	Merge Range ('20030201')
select * from PartitionInfo 

-- Sliding Wind StoredProcedure
If Exists(Select Name from sys.procedures where name='CreateNextPartition')
	Drop procedure CreateNextPartition
go
Create procedure dbo.CreateNextPartition (@DtNextBoundary as datetime)
as
Begin
Declare @DtOldestBoundary AS datetime
Declare @strFileGroupToBeUsed AS VARCHAR(100)
Declare @PartitionNumber As int

SELECT @strFileGroupToBeUsed = fg.name, @PartitionNumber = p.partition_number, @DtOldestBoundary = cast(prv.value as datetime) FROM sys.partitions p 
INNER JOIN sys.sysobjects tab on tab.id = p.object_id
INNER JOIN sys.allocation_units au ON au.container_id = p.hobt_id 
INNER JOIN sys.filegroups fg ON fg.data_space_id = au.data_space_id 
INNER JOIN SYS.partition_range_values prv ON prv.boundary_id = p.partition_number
INNER JOIN sys.partition_functions PF ON pf.function_id = prv.function_id
WHERE 1=1
AND pf.name = 'myPartitionFunction'
AND tab.name = 'myOrderTable'
AND cast(value as datetime) = (
SELECT MIN(cast(value as datetime)) FROM sys.partitions p 
INNER JOIN sys.sysobjects tab on tab.id = p.object_id
INNER JOIN SYS.partition_range_values prv ON prv.boundary_id = p.partition_number
INNER JOIN sys.partition_functions PF ON pf.function_id = prv.function_id
WHERE 1=1
AND pf.name = 'myPartitionFunction'
AND tab.name = 'myOrderTable'
)

Select @DtOldestBoundary Oldest_Boundary , @strFileGroupToBeUsed FileGroupToBeUsed,@PartitionNumber PartitionNumber
Truncate Table myOrderTable with (Partitions(@PartitionNumber))
EXEC('Alter Partition Scheme myPartitionScheme NEXT USED '+@strFileGroupToBeUsed)
Alter Partition Function myPartitionFunction() SPLIT RANGE (@DtNextBoundary);
Alter Partition Function myPartitionFunction() MERGE RANGE (@DtOldestBoundary);
End
Go

Execute CreateNextPartition '20030801'
Go

select * from PartitionInfo
Go


-- Methoden um Strukturen zu löschen
truncate table myOrderTable
go
DROP Table myOrderTable
go
drop partition scheme mypartitionscheme
go
drop partition function mypartitionfunction
go