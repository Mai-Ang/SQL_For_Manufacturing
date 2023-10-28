-- SQL CODE
hello 
--VIEW
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



--FUNCTION
  
--tổng số sản phẩm có thể bán được từ product 
CREATE FUNCTION tong_nameproduct()
RETURNS INT
BEGIN
RETURN (SELECT COUNT(ProductID) AS SOLUONGSANPHAM
FROM [Production.Product]
WHERE FinishedGoodsFlag=1)
END

  
--Tổng giá tiền của các sản phẩm bán được
CREATE FUNCTION sumofsaleproduct()
RETURNS INT
BEGIN
RETURN (SELECT sum(ActualCost) AS TONGTIEN
FROM [dbo].[Production.TransactionHistory]
WHERE TransactionType='S')
END
SELECT dbo.sumofsaleproduct() AS TONGTIEN--
