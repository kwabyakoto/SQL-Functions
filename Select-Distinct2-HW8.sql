select distinct  	tblPurchaseOrderLine.PONumber,
          	   		tblVendor.Name,
   	          		tblProduct.ProductID,
   	          		tblProduct.Description,
   	          		Price
from             	tblPurchaseOrderLine
INNER JOIN       	tblProduct
on               	tblProduct.ProductID = tblPurchaseOrderLine.ProductID
INNER JOIN       	tblPurchaseOrder
on               	tblPurchaseOrder.PoNumber = tblPurchaseOrderLine.PONumber
INNER JOIN       	tblVendor
on               	tblVendor.VendorID = tblPurchaseOrder.VendorID
WHERE				price = (SELECT max (tblPurchaseOrderLine.Price) 
							 from tblPurchaseOrderLine 
							 where tblProduct.ProductID = tblPurchaseOrderLine.ProductID)
AND              	tblProduct.Description = 'Alpine Small Pot';