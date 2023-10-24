-- SQL CODE
hello 
--VIEW
create VIEW WorkOrderRoutingDetail AS
SELECT WorkOrderID, ProductID, LocationID,PlannedCost      (view hien thi WorkOrderID, ProductID, LocationID co plannedcost>50)
FROM [dbo].[Production.WorkOrderRouting]
WHERE PlannedCost > 50;

select * from WorkOrderRoutingDetail



CREATE VIEW BillOfMaterialsIDDetail AS
SELECT BillOfMaterialsID, UnitMeasureCode, PerAssemblyQty        (view hien thi  BillOfMaterialsID, UnitMeasureCode, PerAssemblyQty  khi ComponentID < 500 AND UnitMeasureCode = 'EA')
FROM [dbo].[Production.BillOfMaterials]
WHERE ComponentID < 500 AND UnitMeasureCode = 'EA';


 select * from BillOfMaterialsDetail



CREATE VIEW twotableTransactionHistoryAndProduct AS
SELECT
    TH.TransactionID,
    TH.ReferenceOrderID,
    P.Name,                                                           (view hien thi TransactionID,ReferenceOrderID,Name,ProductNumber cua bang TransactionHistory And Product voi quantity <5)
    P.ProductNumber
FROM
    [dbo].[Production.TransactionHistory] AS TH
INNER JOIN
    [dbo].[Production.Product] AS P
ON
    TH.ProductID = P.ProductID
WHERE
    TH.Quantity < 5;


select *from twotableTransactionHistoryAndProduct




CREATE VIEW InforJoinThreeTable AS
SELECT
    WR.LocationID,
    WR.ScheduledStartDate,
    WR.ScheduledEndDate
FROM
    [dbo].[Production.WorkOrderRouting] AS WR
INNER JOIN
    [dbo].[Production.WorkOrder] AS W
    ON WR.WorkOrderID = W.WorkOrderID
INNER JOIN
    [dbo].[Production.BillOfMaterials] AS BOM
    ON W.ProductID = BOM.ProductAssemblyID
WHERE
    MONTH(BOM.StartDate) = 5;




select * from InforJoinFourTable



alter VIEW V_Update AS
SELECT
  LocationID,
   ScheduledStartDate,
   ScheduledEndDate
FROM InforJoinFourTable;
GO
UPDATE [dbo].[Production.WorkOrder]
SET ScrappedQty = 0
WHERE ScrapReasonID IS NULL;


 select * from V_Update





--2 VIEW ĐƠN GIẢN

--2 VIEW PHỨC TẠP

--1 VIEW UPDATE

--PROCEDURE
--1 KHÔNG THAM SỐ

--1 CÓ THAM SỐ DEFAULT

-- THAM SỐ INPUT

--1 THAM SỐ OUTPUT

--FUNCTION
--2 TRẢ VÔ HƯỚNG

--2 TRẢ VỀ BẢNG

--1 TRẢ VỀ KIỂU TỰ ĐỊNH NGHĨA

--TRIGGER
--1 TRIG UPDATE

--1 TRIG INSERT

--1 TRIG DELETE

--2 TRANSACTION



--PROCEDURE
--hien thi thong tin hoa don khi bomlevel = 3
CREATE PROC HienthithongtinHoadon
AS
BEGIN
SELECT *from [Production.BillOfMaterials]
WHERE PerAssemblyQty = 4 AND BOMLevel = 2
END

EXEC HienthithongtinHoadon

--tao them 1 dong vao bang scrapReason voi cot ModifiedDate lay mac dinh la nam hien tai
CREATE PROC Taothembang(
@ScrapReasonID SMALLINT,
@Name NVARCHAR(50),
@ModifiedDate DATETIME)
AS
BEGIN 
 IF @ModifiedDate IS NULL OR @ModifiedDate = ''
SET @ModifiedDate = GETDATE();
INSERT INTO [dbo].[Production.ScrapReason](ScrapReasonID,[Name],ModifiedDate)
VALUES (@ScrapReasonID,@Name,@ModifiedDate)
END
SET IDENTITY_INSERT [dbo].[Production.ScrapReason] ON
EXEC Taothembang 17,'Drill size medium',null
select * from [dbo].[Production.ScrapReason]

--chua lam output

--xay dung thu tuc nhap vao --CÓ GÌ SỬA DÙM
--ALTER PROC p_ThongtinProduct(@ProductID INT)
--AS 
--BEGIN 
--IF @ProductID NOT IN (SELECT pp.ProductID FROM [Production.Product] pp
--INNER JOIN [Production.TransactionHistoryArchive] ptha 
--ON pp.ProductID = ptha.ProductID
--INNER JOIN [Production.TransactionHistory] pth
--ON pth.[ReferenceOrderLineID] = ptha.[ReferenceOrderLineID])
--PRINT(N'Mã Không tồn tại')
--ELSE
	--SELECT [Name],ProductNumber
	--FROM [Production.Product] pp
	--WHERE pp.ProductID = @ProductID
--END

CREATE PROC p_ThongtinProduct (@ProductID SMALLINT)
AS
BEGIN 
	IF @ProductID NOT IN (SELECT ProductID FROM [Production.Product])
	PRINT(N'Mã không tồn tại')
ELSE
	SELECT ProductID,[Name],ProductNumber
	FROM [Production.Product]
	WHERE ProductID = @ProductID
END
EXEC p_ThongtinProduct 531
