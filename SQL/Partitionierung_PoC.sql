/*
Diese Datei enthällt:
- Partitionsfunktion
- Partitionsschema
- Gesetzte Constraints entfernen
- Nicht gruppierter primary key setzen
- Gruppierter Index setzen
- Vorhher gelöschte Constraints setzen##
*/

USE LiveDemo
GO

SELECT * FROM dbo.Orders
SELECT * FROM dbo.Product
SELECT * FROM dbo.OrderItem

SELECT o.name objectname,i.name indexname, partition_id, partition_number, [rows]
FROM sys.partitions p
INNER JOIN sys.objects o ON o.object_id=p.object_id
INNER JOIN sys.indexes i ON i.object_id=p.object_id and p.index_id=i.index_id
WHERE o.name LIKE '%orders%'


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

-- fk löschen
alter table orderItem drop constraint FKn0v6r9hpp0of2sua4rglv9a3a 
GO
-- pk löschen
alter table orders drop constraint PK__Orders__460A94648F699EFC 
GO
-- nonclustered pk setzen
alter table orders add constraint PK_ORDERS_NONCLUSTERED PRIMARY KEY NONCLUSTERED (order_id)
	ON [PRIMARY] 
GO
-- clustered index setzen
CREATE CLUSTERED INDEX INDEX_PARTITIONCOL_ORDERDATE ON orders (OrderDate)
	ON myPartitionScheme(orderDate) 
GO
-- gelöschten fk wieder setzen
alter table orderitem add constraint FK_ORDERITEM_REFERENCE_ORDER foreign key(order_id) references Orders(order_id)
GO

--JOIN um zu testen ob die Schlüssel funktionieren
SELECT a.firstname , b.order_id, c.product_id
FROM Customer a
INNER JOIN orders b ON a.customer_id = b.customer_id
INNER JOIN orderitem C ON B.order_id = C.order_id

-- Display
SELECT o.name objectname,i.name indexname, partition_id, partition_number, [rows]
FROM sys.partitions p
INNER JOIN sys.objects o ON o.object_id=p.object_id
INNER JOIN sys.indexes i ON i.object_id=p.object_id and p.index_id=i.index_id
WHERE o.name LIKE '%orders%'


