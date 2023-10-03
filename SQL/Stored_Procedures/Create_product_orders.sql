CREATE PROCEDURE Create_product_orders_table
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