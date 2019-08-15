USE ProofOfConcept
GO

/*
	Da das Datenmodell mit dem SQL Generator erzeugt wurde, und dieser mit Inhalten von Fremdschlüsselbeziehungen nicht ohne weiteres umgehen kann
	wurde diese zwei Update Methoden geschrieben, die dafür sorgen, dass in der Tabelle OrderItem und Product und der Tabelle Orders und OrderItem
	die Daten konsistent gehalten werden
	@author Leonard Tutzauer
*/
UPDATE dbo.OrderItem
SET dbo.OrderItem.UnitPrice = dbo.Product.UnitPrice
FROM OrderItem
     INNER JOIN dbo.Product 
     ON Orderitem.Product_Id=dbo.Product.Product_Id
go	

UPDATE dbo.Orders
SET TotalAmount = (SELECT SUM(a.UnitPrice * a.Quantity)
					 FROM dbo.OrderItem AS a			 	     
					 WHERE a.order_id = dbo.Orders.Order_Id
					 GROUP BY a.order_id)
GO


