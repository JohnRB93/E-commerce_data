CREATE PROCEDURE Create_customers_table
AS
BEGIN
    IF OBJECT_ID('customers', 'U') IS NOT NULL
    BEGIN
        DROP TABLE customers;
    END

    CREATE TABLE customers (
        ID INT PRIMARY KEY,
		First_Name VARCHAR(50) NOT NULL,
		Last_Name VARCHAR(50) NOT NULL,
		Gender VARCHAR(7) NOT NULL,
		Street_Address VARCHAR(100) NOT NULL,
		City VARCHAR(100) NOT NULL,
		State VARCHAR(25) NOT NULL,
		Postal INT NOT NULL,
		Email VARCHAR(100) NOT NULL,
		Primary_Payment_Methods VARCHAR(25) NOT NULL
    );
END;