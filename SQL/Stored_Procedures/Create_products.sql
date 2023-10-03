USE [Synthetic_e-commerce_store]
GO
/****** Object:  StoredProcedure [dbo].[Create_products_table]    Script Date: 10/1/2023 10:25:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Create_products_table]
AS
BEGIN
    IF OBJECT_ID('products', 'U') IS NOT NULL
    BEGIN
        DROP TABLE products;
    END

    CREATE TABLE products (
        ID INT PRIMARY KEY,
		Name VARCHAR(100) NOT NULL,
		Unit_Price MONEY NOT NULL
    );
END;