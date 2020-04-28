SELECT			vQuantityReceived.PoNumber as 'PO Number',
				CONVERT(VARCHAR,tblPurchaseOrder.PODatePlaced, 107) as 'PO Date',
				tblVendor.Name as 'Vendor Name',
				ISNULL(tblEmployee.EmpLastName + ', ' + SUBSTRING(tblEmployee.EmpFirstName,1,1) + '.', 'No Buyer on File') as 'Employee Buyer',
				CASE
                       	WHEN (tblEmployee.EmpMgrID) IS NULL 
						THEN 'No Manager on File'
                        ELSE (Manager.EmpLastName + ', ' + SUBSTRING(Manager.EmpFirstName,1,1))
                       	END 'Manager of Buyer',
				vQuantityReceived.ProductID as 'Product ID',
				tblproduct.Description as 'Product Description',
				CONVERT(VARCHAR,vQuantityReceived.DateNeeded, 107) as 'Date Needed',
				tblPurchaseOrderLine.Price as 'Product Price',
				tblPurchaseOrderLine.QtyOrdered as 'Quantity Ordered',
				vQuantityReceived.SumQtyReceived as 'Quantity Received',
				(tblPurchaseOrderLine.QtyOrdered - vQuantityReceived.SumQtyReceived) as 'Quantity Remaining',
				CASE
					WHEN (tblPurchaseOrderLine.QtyOrdered - vQuantityReceived.SumQtyReceived) = 0
					THEN 'Complete'
					WHEN (tblPurchaseOrderLine.QtyOrdered - vQuantityReceived.SumQtyReceived) < 0
					THEN 'Over Shipment'
					WHEN vQuantityReceived.SumQtyReceived = 0.00
					THEN 'Not Received'
					WHEN (tblPurchaseOrderLine.QtyOrdered - vQuantityReceived.SumQtyReceived) > 0
					THEN 'Partial Shipment'
					END 'Receiving Status'
FROM			tblPurchaseOrderLine
INNER JOIN		tblPurchaseOrder
ON				tblPurchaseOrder.PoNumber = tblPurchaseOrderLine.PONumber
INNER JOIN		tblVendor
ON				tblPurchaseOrder.VendorID = tblVendor.VendorID
INNER JOIN		tblEmployee
ON				tblPurchaseOrder.BuyerEmpID = tblEmployee.EmpID
LEFT JOIN		tblEmployee Manager
ON				tblEmployee.EmpMgrID = Manager.EmpID
INNER JOIN		tblProduct
ON				tblPurchaseOrderLine.ProductID = tblProduct.ProductID
LEFT JOIN		tblReceiver
ON				tblPurchaseOrderLine.ProductID = tblReceiver.ProductID
AND				tblPurchaseOrderLine.PONumber = tblReceiver.PONumber
AND				tblPurchaseOrderLine.DateNeeded = tblReceiver.DateNeeded
INNER JOIN		vQuantityReceived
ON				tblPurchaseOrderLine.ProductID = vQuantityReceived.ProductID
AND				tblPurchaseOrderLine.DateNeeded = vQuantityReceived.DateNeeded
AND				tblPurchaseOrderLine.PoNumber = vQuantityReceived.PONumber
ORDER BY		vQuantityReceived.PONumber, vQuantityReceived.ProductID, vQuantityReceived.DateNeeded;

SELECT *
FROM tblReceiver;

