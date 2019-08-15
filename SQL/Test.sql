USE sample_db1
GO

--Cache leeren
DBCC DROPCLEANBUFFERS
go

-- Zeit messen
SET STATISTICS TIME [ON | Off] 
GO 

-- Lese und Schreibvorgänge anzeigen lassen
SET STATISTICS IO 
GO

-- Example
SET STATISTICS TIME ON
GO 
	SELECT * FROM dbo.Orders
	
SET STATISTICS TIME OFF 
GO



-- # TEST Abfragen#
SELECT * FROM dbo.Orders

SELECT a.CUSTOMER_ID, a.lastName, b.orderDate, b.orderDate, b.totalAmount, c.quantity, d.PRODUCT_ID, d.productName, c.unitPrice
FROM Customer a
INNER JOIN dbo.Orders b ON b.CUSTOMER_ID = a.CUSTOMER_ID
INNER JOIN dbo.OrderItem c ON c.ORDER_ID = b.ORDER_ID
INNER JOIN dbo.Product d ON d.PRODUCT_ID = c.PRODUCT_ID

SELECT a.CUSTOMER_ID, a.lastName, b.orderDate, b.totalAmount, c.quantity, d.PRODUCT_ID, d.productName, c.unitPrice
FROM Customer a
INNER JOIN dbo.Orders b ON b.CUSTOMER_ID = a.CUSTOMER_ID
INNER JOIN dbo.OrderItem c ON c.ORDER_ID = b.ORDER_ID
INNER JOIN dbo.Product d ON d.PRODUCT_ID = c.PRODUCT_ID
WHERE b.orderDate = '20190603 11:51:40:840' 

SELECT a.CUSTOMER_ID, a.lastName, b.orderDate, b.totalAmount, c.quantity, d.PRODUCT_ID, d.productName, c.unitPrice
FROM Customer a
INNER JOIN dbo.Orders b ON b.CUSTOMER_ID = a.CUSTOMER_ID
INNER JOIN dbo.OrderItem c ON c.ORDER_ID = b.ORDER_ID
INNER JOIN dbo.Product d ON d.PRODUCT_ID = c.PRODUCT_ID
WHERE b.orderDate >= '20190603 11:51:40:840' AND 
	  b.orderDate <= '20190903 11:51:40:840'

SELECT a.CUSTOMER_ID, a.lastName, b.orderDate, b.totalAmount, c.quantity, d.PRODUCT_ID, d.productName, c.unitPrice
FROM Customer a
INNER JOIN dbo.Orders b ON b.CUSTOMER_ID = a.CUSTOMER_ID
INNER JOIN dbo.OrderItem c ON c.ORDER_ID = b.ORDER_ID
INNER JOIN dbo.Product d ON d.PRODUCT_ID = c.PRODUCT_ID
WHERE b.orderDate >= '20190603 11:51:40:840' AND 
	  b.orderDate <= '20190903 11:51:40:840'
order BY b.orderdate ASC


