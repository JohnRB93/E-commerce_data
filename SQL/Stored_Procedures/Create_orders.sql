USE [Synthetic_e-commerce_store]
GO
/****** Object:  StoredProcedure [dbo].[Create_orders_table]    Script Date: 10/1/2023 10:23:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Create_orders_table]
AS
BEGIN
    IF OBJECT_ID('orders', 'U') IS NOT NULL
    BEGIN
        DROP TABLE orders;
    END

    CREATE TABLE orders (
        ID INT PRIMARY KEY,
		Customer_ID INT NOT NULL,
		Seller_ID INT NOT NULL,
		Number_of_Items INT NOT NULL,
		Order_Date DATE NOT NULL,
		Order_Time TIME NOT NULL,
		Estimated_Delivery_Date DATE NOT NULL,
		Date_delivered DATE NOT NULL
    );
END;