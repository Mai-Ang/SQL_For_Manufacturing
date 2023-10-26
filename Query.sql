-- SQL CODE
hello 
--VIEW
--2 VIEW ĐƠN GIẢN

--2 VIEW PHỨC TẠP

--1 VIEW UPDATE

--PROCEDURE
----hiển thị thông tin khi bomlevel = 2 và số lượng thành phần = 4----
CREATE PROC Hienthithongtin
AS
BEGIN
SELECT *from [Production.BillOfMaterials]
WHERE PerAssemblyQty = 4 AND BOMLevel = 2
END

EXEC Hienthithongtin

----cập nhật 1 sản phẩm mới----
ALTER PROCEDURE UpdateProduct
    @ProductID INT,
    @NewProductName NVARCHAR(50),
    @Color NVARCHAR(15),
    @NewListPrice MONEY
AS
BEGIN
    -- Cập nhật thông tin sản phẩm trong bảng Products
    UPDATE [Production.Product]
    SET [Name] = @NewProductName,
        Color = @Color,
        ListPrice = @NewListPrice
    WHERE ProductID = @ProductID

    -- In ra thông báo thành công
    PRINT N'Thông tin sản phẩm có ID ' + CAST(@ProductID AS NVARCHAR(10)) + N' đã được cập nhật.'
END
EXEC UpdateProduct @ProductID = 10001, @NewProductName = N'Sản phẩm B', @Color = 'WhiteGray', @NewListPrice = 60.00


----Tạo proc để tính tổng chi phí sản phẩm dựa trên các thông tin về nguyên liệu và công việc----
ALTER PROC CalculateProductionCost
    @ProductID INT,
    @Quantity INT
AS
BEGIN
    -- Tính tổng chi phí nguyên vật liệu
    DECLARE @MaterialCost DECIMAL(10, 2)
    SELECT @MaterialCost = SUM(ActualCost * @Quantity)
    FROM [Production.TransactionHistory]
    WHERE ProductID = @ProductID

    -- Tính tổng chi phí công việc
    DECLARE @LaborCost DECIMAL(10, 2)
    SELECT @LaborCost = ListPrice * StandardCost
    FROM [Production.Product]
    WHERE ProductID = @ProductID

    -- Tổng chi phí sản xuất
    DECLARE @TotalCost DECIMAL(10, 2)
    SET @TotalCost = @MaterialCost + @LaborCost

    -- In ra kết quả
	PRINT N'Tổng chi phí sản xuất cho sản phẩm ' + CAST(@ProductID AS NVARCHAR(10)) + ' là: ' + CAST(@TotalCost AS NVARCHAR(20))END
EXEC CalculateProductionCost @ProductID = 956, @Quantity = 2


--OUTPUT
----output về thông tin chi tiết sản phẩm----
ALTER PROC GetProductDetails
    @ProductID INT,
    @ProductName NVARCHAR(50) OUTPUT,
    @Number NVARCHAR(50) OUTPUT,
    @ListPrice Money OUTPUT
AS
BEGIN
    -- Lấy thông tin sản phẩm dựa trên ID sản phẩm
    SELECT @ProductName = [Name], @Number = ProductNumber, @ListPrice = ListPrice
    FROM [Production.Product]
    WHERE ProductID = @ProductID
END
DECLARE @ProductID INT = 518
DECLARE @ProductName NVARCHAR(50)
DECLARE @Number NVARCHAR(1000)
DECLARE @ListPrice Money

EXEC GetProductDetails @ProductID, @ProductName OUTPUT, @Number OUTPUT, @ListPrice OUTPUT

PRINT N'Thông tin sản phẩm có ID: '+CAST(@ProductID AS NVARCHAR(10)) 
PRINT N'Tên sản phẩm: ' + @ProductName
PRINT N'Mã sản phẩm: ' + @Number
PRINT N'Giá: ' + CAST(@ListPrice AS NVARCHAR(20))


--INPUT
----thêm phần tử vào SizeUnitMeasureCode----
CREATE PROC UpdateProductSizeUnitMeasure
    @ProductID INT,
    @NewSizeUnitMeasureCode NVARCHAR(50)
AS
BEGIN
    -- Cập nhật trường SizeUnitMeasureCode cho sản phẩm
    UPDATE [Production.Product]
    SET SizeUnitMeasureCode = @NewSizeUnitMeasureCode
    WHERE ProductID = @ProductID
END
EXEC UpdateProductSizeUnitMeasure 
    @ProductID = 326, -- 326 là ProductID của sản phẩm cần cập nhật
    @NewSizeUnitMeasureCode = 'BOX' -- 'BOX' là giá trị mới cho trường SizeUnitMeasureCode


----khai báo lỗi từ nguồn hàng khi nhập WorkOrderID nếu null sẽ không báo lỗi và ngược lại----
ALTER PROC CheckWorkOrderErrors
    @WorkOrderID INT
AS
BEGIN
    DECLARE @ScrapReason NVARCHAR(255)
	DECLARE @ScrapReasonID INT
	 -- Kiểm tra xem có dữ liệu cho WorkOrderID đã nhập hay không
    IF NOT EXISTS (SELECT 1 FROM [Production.WorkOrder] WHERE WorkOrderID = @WorkOrderID)
    BEGIN
        PRINT N'Không có dữ liệu.'
        RETURN  -- Kết thúc stored procedure
    END

    -- Lấy thông tin ScrapReason từ bảng ScrapReason liên quan đến WorkOrder
    SELECT @ScrapReasonID = sr.ScrapReasonID, @ScrapReason = sr.[Name]
    FROM [Production.WorkOrder] AS wo
    LEFT JOIN [Production.ScrapReason] AS sr ON wo.ScrapReasonID = sr.ScrapReasonID
    WHERE wo.WorkOrderID = @WorkOrderID

    -- Kiểm tra ScrapReason
    IF @ScrapReason IS NULL
    BEGIN
        PRINT N'Không có lỗi.'
    END
    ELSE
    BEGIN
		PRINT N'Mã lỗi: ' + CAST(@ScrapReasonID AS NVARCHAR(10))
        PRINT N'Tên lỗi: ' + @ScrapReason
    END
END
-- Thực thi stored procedure với WorkOrderID 
EXEC CheckWorkOrderErrors @WorkOrderID = 110

--FUNCTION
--2 TRẢ VÔ HƯỚNG

--2 TRẢ VỀ BẢNG

--1 TRẢ VỀ KIỂU TỰ ĐỊNH NGHĨA

--TRIGGER
--1 TRIG UPDATE

--1 TRIG INSERT

--1 TRIG DELETE

--2 TRANSACTION



