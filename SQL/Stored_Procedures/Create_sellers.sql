USE [Synthetic_e-commerce_store]
GO
/****** Object:  StoredProcedure [dbo].[Create_sellers_table]    Script Date: 10/1/2023 10:26:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Create_sellers_table]
AS
BEGIN
    IF OBJECT_ID('sellers', 'U') IS NOT NULL
    BEGIN
        DROP TABLE sellers;
    END

    CREATE TABLE sellers (
        ID INT PRIMARY KEY,
		First_Name VARCHAR(50) NOT NULL,
		Last_Name VARCHAR(50) NOT NULL,
		State VARCHAR(50) NOT NULL,
		Five_Star_Reviews INT NOT NULL,
		Four_Star_Reviews INT NOT NULL,
		Three_Star_Reviews INT NOT NULL,
		Two_Star_Reviews INT NOT NULL,
		One_Star_Reviews INT NOT NULL,
    );
END;