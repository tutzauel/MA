USE sample_db1_part --//Zahl der Db auf 2 und einmal auf 3 ändern und Script ausführen
GO

-- Partitionsfunktion erstellen
Create Partition Function myPartitionFunction(datetime) AS
Range RIGHT FOR VALUES ('20190201','20190301','20190401',
						'20190501','20190601','20190701','20190801',
						'20190901','20191001','20191101','20191201')
GO

-- Partitionsschema erstellen
Create Partition Scheme myPartitionScheme AS
Partition myPartitionFunction ALL TO ([PRIMARY]) 
GO

-- fk löschen (in orderItem)
alter table orderItem drop constraint FKn0v6r9hpp0of2sua4rglv9a3a -- FK anpassen
GO
-- pk löschen (in Orders)
alter table orders drop constraint PK__Orders__460A9464C9997FA3	--PK anpasen
GO
--clustered index löschen (wurde mit Löschung des PK gelöscht)
--DROP INDEX [INDEX_PARTITIONCOL_ORDERDATE] ON [dbo].[Orders]
--GO

-- Nonclustered pk erzeugen
alter table orders add constraint PK_ORDERS_NONCLUSTERED PRIMARY KEY NONCLUSTERED (order_id)
	ON [PRIMARY] 
GO

--Clustered Index erzeugen
CREATE CLUSTERED INDEX INDEX_PARTITIONCOL_ORDERDATE ON orders (orderDate)
	ON myPartitionScheme(orderDate) 
GO

--Fk wieder setzen // hier spinnt es, projekt für morgen //
alter table orderitem add constraint FK_ORDERITEM_REFERENCE_ORDER foreign key(order_id) references Orders(order_id)
GO

-- Display Validierung Partition
SELECT o.name objectname,i.name indexname, partition_id, partition_number, [rows]
FROM sys.partitions p
INNER JOIN sys.objects o ON o.object_id=p.object_id
INNER JOIN sys.indexes i ON i.object_id=p.object_id and p.index_id=i.index_id
WHERE o.name LIKE '%orders%'
go


