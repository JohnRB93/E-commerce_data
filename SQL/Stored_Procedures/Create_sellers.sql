CREATE PROCEDURE Create_sellers_table
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