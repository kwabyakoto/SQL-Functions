SELECT			tblPurchaseOrder.PoNumber as 'Purchase Order Number',
				tblVendor.Name as 'Vendor Name',
				tblPurchaseOrderLine.ProductID as 'Product ID',
				tblproduct.Description as 'Product Description',
				CONVERT(VARCHAR,tblPurchaseOrder.PODatedNeeded, 107) as 'Product Date Needed',
				tblPurchaseOrderLine.QtyOrdered as 'Quantity Ordered',
				ISNULL(SUM(tblReceiver.QtyReceived),0.00) as 'Total Quantity Received',
				(tblPurchaseOrderLine.QtyOrdered - ISNULL(SUM(tblReceiver.QtyReceived),0.00)) as 'Quantity Remaining to be Received',
				CASE
					WHEN (tblPurchaseOrderLine.QtyOrdered - ISNULL(SUM(tblReceiver.QtyReceived),0.00)) = 0
					THEN 'Complete'
					WHEN (tblPurchaseOrderLine.QtyOrdered - ISNULL(SUM(tblReceiver.QtyReceived),0.00)) < 0
					THEN 'Over Shipment'
					WHEN ISNULL(SUM(tblReceiver.QtyReceived),0.00) = 0.00
					THEN 'Not Received'
					WHEN (tblPurchaseOrderLine.QtyOrdered - ISNULL(SUM(tblReceiver.QtyReceived),0.00)) > 0
					THEN 'Partial Shipment'
					END 'Receiving Status'
FROM			tblPurchaseOrder
INNER JOIN		tblVendor
ON				tblPurchaseOrder.VendorID = tblVendor.VendorID
LEFT JOIN		tblEmployee
ON				tblPurchaseOrder.BuyerEmpID = tblEmployee.EmpID
INNER JOIN		tblPurchaseOrderLine
ON				tblPurchaseOrder.PoNumber = tblPurchaseOrderLine.PONumber
INNER JOIN		tblProduct
ON				tblPurchaseOrderLine.ProductID = tblProduct.ProductID
LEFT JOIN		tblReceiver
ON				tblPurchaseOrderLine.ProductID = tblReceiver.ProductID
AND				tblPurchaseOrderLine.PONumber = tblReceiver.PONumber
AND				tblPurchaseOrderLine.DateNeeded = tblReceiver.DateNeeded
GROUP BY		tblPurchaseOrder.PoNumber, tblVendor.Name, tblPurchaseOrderLine.ProductID,tblproduct.Description,tblPurchaseOrder.PODatedNeeded, tblPurchaseOrderLine.QtyOrdered  
ORDER BY		tblPurchaseOrder.PoNumber, tblPurchaseOrderLine.ProductID, tblPurchaseOrder.PODatedNeeded;
