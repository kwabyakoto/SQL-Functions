select distinct  	tblPurchaseOrderLine.PONumber,
          	   		tblVendor.Name,
          	   		tblEmployee.EmpLastName 'Purchase Employee',
   	          		tblProduct.ProductID,
   	          		tblProduct.Description,
   	          		tblProductType.Description 'Product Type Description',
   	          		Price
from             	tblPurchaseOrderLine
INNER JOIN       	tblProduct
on        	   		tblProduct.ProductID = tblPurchaseOrderLine.ProductID
INNER JOIN       	tblProductType
on        	   		tblProduct.ProductTypeID = tblProductType.ProductTypeID
INNER JOIN       	tblPurchaseOrder
on        			tblPurchaseOrder.PoNumber = tblPurchaseOrderLine.PONumber
INNER JOIN       	tblEmployee
on        	   		tblPurchaseOrder.BuyerEmpID = tblEmployee.EmpID
INNER JOIN       	tblVendor
on        			tblVendor.VendorID = tblPurchaseOrder.VendorID
WHERE				price = (SELECT max (tblPurchaseOrderLine.Price) 
							 from tblPurchaseOrderLine 
							 where tblProduct.ProductID = tblPurchaseOrderLine.ProductID)
AND              	tblProduct.Description = 'Alpine Small Pot';