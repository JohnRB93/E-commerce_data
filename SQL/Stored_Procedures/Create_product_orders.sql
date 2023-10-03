USE [Synthetic_e-commerce_store]
GO
/****** Object:  StoredProcedure [dbo].[Create_product_orders_table]    Script Date: 10/1/2023 10:24:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Create_product_orders_table]
AS
BEGIN
    IF OBJECT_ID('product_orders', 'U') IS NOT NULL
    BEGIN
        DROP TABLE product_orders;
    END

    CREATE TABLE product_orders (
		Order_ID INT NOT NULL,
		Product_ID INT NOT NULL
    );
END;