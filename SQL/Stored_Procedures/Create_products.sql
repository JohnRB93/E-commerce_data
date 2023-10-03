CREATE PROCEDURE Create_products_table
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