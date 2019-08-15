Use GrundlagenPartitionierung
go

--Partitionsfunktion erstellen
Create Partition Function myPartitionFunction(datetime) AS
Range Right FOR VALUES ('2003/01/01', '2004/01/01', '2005/01/01')
go
--Partitionsschema erstellen
Create Partition Scheme myPartitionScheme AS
Partition myPartitionFunction to (FG1, FG2, FG3, [PRIMARY])
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

declare @OrderDate Datetime
Declare @i int
set @OrderDate = '2007/01/01'
set @i = 0

while @i < 300
	Begin
			insert myOrderTable(OrderDate, Amount, ProduktID)
			values (@OrderDate + @i, @i + 5, @i) 
			set @i = @i + 1
	end

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


 select $partition.mypartitionfunction (m.OrderDate) as Partitionsnummer
, min (m.OrderDate) as [Min Value]
, max (m.OrderDate) as [Max Value]
, count (*) [Datensätze in Partition]
from myOrderTable m
Group by $partition.mypartitionfunction (m.OrderDate)
Order by Partitionsnummer

select * from PartitionInfo
				
Alter Partition SCHEME myPartitionScheme NEXT USED FG5
go
Alter Partition Function myPartitionFunction() Split Range ('2007/01/01') 
go

Alter Partition Function myPartitionFunction()	Merge Range ('2005/01/01')

Alter Table sourceTable Switch Partition [x] to destinationTable [y]

Alter Database DatabaseName ADD Filegroup FilegroupName
Alter Database DatabaseName ADD File
 (
	Name = P4,
	FileName = 'storage path',
	size = 1204KB, MaxSize = UNLIMITED, Filegrowth = 10%
) to FILEGROUP FilegroupName


truncate table myOrderTable
go
DROP Table myOrderTable
go
drop partition scheme mypartitionscheme
go
drop partition function mypartitionfunction
go