-- Get to know the data
SELECT TOP 5 *
FROM customers;
SELECT TOP 5 *
FROM products;
SELECT TOP 5 *
FROM sellers;
SELECT TOP 5 *
FROM orders;
SELECT TOP 5 *
FROM product_orders;

-- Is there any correlation between customer's state address and number of purchases?
SELECT
	c.State,
	SUM(o.Number_of_Items) AS Sum_of_Items
FROM customers c
	JOIN orders o ON c.ID = o.Customer_ID
GROUP BY c.State
ORDER BY SUM(o.Number_of_Items) DESC;

-- How much is being spent by customers from each state?
WITH order_cost AS (
	SELECT
		po.Order_ID,
		SUM(p.Unit_Price) AS order_cost_total
	FROM products p
		JOIN product_orders po ON p.ID = po.Product_ID
	GROUP BY po.Order_ID
),
states AS (
	SELECT
		o.ID,
		c.State
	FROM customers c
		JOIN orders o ON c.ID = o.Customer_ID
)
SELECT 
	s.State,
	SUM(oc.order_cost_total) AS total_spent
FROM order_cost oc
	JOIN states s ON oc.Order_ID = s.ID
GROUP BY s.State
ORDER BY SUM(oc.order_cost_total) DESC;

-- What is the most popular payment method?
SELECT 
	Primary_Payment_Methods,
	COUNT(Primary_Payment_Methods) AS Count_of_Method
FROM customers
GROUP BY Primary_Payment_Methods
ORDER BY COUNT(Primary_Payment_Methods) DESC;

-- Which products are being bought the most, by all customers and gender?
SELECT
	p.Name,
	p.Unit_Price,
	COUNT(po.Product_ID) AS Count_Purchased
FROM products p
	JOIN product_orders po ON p.ID = po.Product_ID
GROUP BY p.ID, p.Name, p.Unit_Price
ORDER BY COUNT(po.Product_ID) DESC;
-- For male customers
WITH male_orders AS (
	SELECT c.ID AS cID, o.ID AS oID
	FROM customers c
		JOIN orders o ON c.ID = o.Customer_ID
	WHERE c.Gender = 'Male'
)
SELECT
	p.Name,
	p.Unit_Price,
	COUNT(po.Product_ID) AS Count_Purchased
FROM products p
	JOIN product_orders po ON p.ID = po.Product_ID
	JOIN male_orders mo ON po.Order_ID = mo.oID
GROUP BY p.ID, p.Name, p.Unit_Price
ORDER BY COUNT(po.Product_ID) DESC;
-- For female customers
WITH female_orders AS (
	SELECT c.ID AS cID, o.ID AS oID
	FROM customers c
		JOIN orders o ON c.ID = o.Customer_ID
	WHERE c.Gender = 'Female'
)
SELECT
	p.Name,
	p.Unit_Price,
	COUNT(po.Product_ID) AS Count_Purchased
FROM products p
	JOIN product_orders po ON p.ID = po.Product_ID
	JOIN female_orders fo ON po.Order_ID = fo.oID
GROUP BY p.ID, p.Name, p.Unit_Price
ORDER BY COUNT(po.Product_ID) DESC;

-- Which products are generating the highest revenue?
SELECT
	p.Name,
	p.Unit_Price,
	SUM(p.Unit_Price) AS Total_Sales
FROM products p
	JOIN product_orders po ON p.ID = po.Product_ID
GROUP BY p.ID, p.Name, p.Unit_Price
ORDER BY SUM(p.Unit_Price) DESC;

--What is the mean, median, and mode of ratings?
SELECT
	TOP 1 PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY Five_Star_Reviews) OVER() AS median_num_five_star_reviews
FROM sellers;

SELECT
	AVG(Five_Star_Reviews) AS avg_num_five_star_reviews
FROM sellers;

--Which sellers are selling the most in number of items sold, and sales total?
WITH count_sold AS (
	SELECT
		s.ID AS Seller_ID,
		s.First_Name,
		s.Last_Name,
		SUM(o.Number_of_Items) AS Items_Sold
	FROM sellers s
		JOIN orders o ON s.ID = o.Seller_ID
	GROUP BY s.ID, s.First_Name, s.Last_Name
)
SELECT 
	s.ID AS SellerID,
	s.First_Name,
	s.Last_Name,
	cs.Items_Sold,
	SUM(p.Unit_Price) AS Sales_Total
FROM sellers s
	JOIN orders o ON s.ID = o.Seller_ID
	JOIN product_orders po ON o.ID = po.Order_ID
	JOIN products p ON po.Product_ID = p.ID
	JOIN count_sold cs ON s.ID = cs.Seller_ID
GROUP BY 
	s.ID,
	s.First_Name,
	s.Last_Name,
	cs.Items_Sold
ORDER BY SUM(p.Unit_Price) DESC;

--Which sellers have the highest rate of items delivered on time?
WITH deliveries AS (
	SELECT
		s.ID AS SellerID,
		s.First_Name,
		s.Last_Name,
		o.Estimated_Delivery_Date,
		o.Date_delivered,
		CASE 
			WHEN DATEDIFF(day, o.Estimated_Delivery_Date, o.Date_delivered) <= 0
				THEN 'On Time'
			WHEN DATEDIFF(day, o.Estimated_Delivery_Date, o.Date_delivered) > 0
				THEN 'Late'
		END AS Delivery_Result
	FROM orders o
		JOIN sellers s ON o.Seller_ID = s.ID
)
SELECT
	deliveries.SellerID,
	First_Name,
	Last_Name,
	sub1.count_ontime AS ontime_count,
	sub2.count_late AS late_count,
	ROUND(CAST(sub1.count_ontime AS FLOAT) / (sub1.count_ontime + sub2.count_late), 4) AS ontime_ratio
FROM deliveries
	JOIN (
			SELECT SellerID, COUNT(SellerID) AS count_ontime
			FROM deliveries
			WHERE Delivery_Result = 'On Time'
			GROUP BY SellerID
		) AS sub1 ON sub1.SellerID = deliveries.SellerID
	JOIN (
			SELECT SellerID, COUNT(SellerID) AS count_late
			FROM deliveries
			WHERE Delivery_Result = 'Late'
			GROUP BY SellerID
		) AS sub2 ON sub2.SellerID = deliveries.SellerID
GROUP BY deliveries.SellerID, First_Name, Last_Name,
			sub1.count_ontime, sub2.count_late
ORDER BY ROUND(CAST(sub1.count_ontime AS FLOAT) / (sub1.count_ontime + sub2.count_late), 4) DESC;

-- What customers state address has better delivery status [on time, late] rate?
WITH deliveries AS (
	SELECT
		c.ID AS CustomerID,
		c.First_Name,
		c.Last_Name,
		c.State,
		o.ID AS OrderID,
		o.Estimated_Delivery_Date,
		o.Date_delivered,
		CASE 
			WHEN DATEDIFF(day, o.Estimated_Delivery_Date, o.Date_delivered) <= 0
				THEN 'On Time'
			WHEN DATEDIFF(day, o.Estimated_Delivery_Date, o.Date_delivered) > 0
				THEN 'Late'
		END AS Delivery_Result
	FROM orders o
		JOIN customers c ON o.Customer_ID = c.ID
)
SELECT
	c.State AS customers_state,
	sub1.count_ontime AS ontime_count,
	sub2.count_late AS late_count,
	ROUND(CAST(sub1.count_ontime AS FLOAT) / (sub1.count_ontime + sub2.count_late), 4) AS ontime_ratio
FROM customers c
	JOIN deliveries d ON c.ID = d.CustomerID
	JOIN (
			SELECT State, COUNT(State) AS count_ontime
			FROM deliveries
			WHERE Delivery_Result = 'On Time'
			GROUP BY State
		) AS sub1 ON sub1.State = d.State
	JOIN (
			SELECT State, COUNT(State) AS count_late
			FROM deliveries
			WHERE Delivery_Result = 'Late'
			GROUP BY State
		) AS sub2 ON sub2.State = d.State
GROUP BY c.State, sub1.count_ontime, sub2.count_late
ORDER BY ROUND(CAST(sub1.count_ontime AS FLOAT) / (sub1.count_ontime + sub2.count_late), 4) DESC;

--Which sellers have the highest average rating reviews?
--Does the ratio of delivery status have a visible impact on the average rating reviews?
WITH deliveries AS (
	SELECT
		s.ID AS SellerID,
		s.First_Name,
		s.Last_Name,
		s.Five_Star_Reviews,
		s.Four_Star_Reviews,
		s.Three_Star_Reviews,
		s.Two_Star_Reviews,
		s.One_Star_Reviews,
		o.Estimated_Delivery_Date,
		o.Date_delivered,
		CASE 
			WHEN DATEDIFF(day, o.Estimated_Delivery_Date, o.Date_delivered) <= 0
				THEN 'On Time'
			WHEN DATEDIFF(day, o.Estimated_Delivery_Date, o.Date_delivered) > 0
				THEN 'Late'
		END AS Delivery_Result
	FROM orders o
		JOIN sellers s ON o.Seller_ID = s.ID
)
SELECT
	deliveries.SellerID,
	First_Name,
	Last_Name,
	ROUND(CAST((Five_Star_Reviews * 5) + (Four_Star_Reviews * 4) + (Three_Star_Reviews * 3) + (Two_Star_Reviews * 2) + (One_Star_Reviews * 1) AS FLOAT) / 
	(Five_Star_Reviews + Four_Star_Reviews + Three_Star_Reviews + Two_Star_Reviews + One_Star_Reviews), 4) AS Avg_Review_Score,
	ROUND(CAST(sub1.count_ontime AS FLOAT) / (sub1.count_ontime + sub2.count_late), 4) AS ontime_ratio
FROM deliveries
	JOIN (
			SELECT SellerID, COUNT(SellerID) AS count_ontime
			FROM deliveries
			WHERE Delivery_Result = 'On Time'
			GROUP BY SellerID
		) AS sub1 ON sub1.SellerID = deliveries.SellerID
	JOIN (
			SELECT SellerID, COUNT(SellerID) AS count_late
			FROM deliveries
			WHERE Delivery_Result = 'Late'
			GROUP BY SellerID
		) AS sub2 ON sub2.SellerID = deliveries.SellerID
GROUP BY 
	deliveries.SellerID, First_Name, Last_Name,
	sub1.count_ontime, sub2.count_late,
	ROUND(CAST((Five_Star_Reviews * 5) + (Four_Star_Reviews * 4) + (Three_Star_Reviews * 3) + (Two_Star_Reviews * 2) + (One_Star_Reviews * 1) AS FLOAT) / 
	(Five_Star_Reviews + Four_Star_Reviews + Three_Star_Reviews + Two_Star_Reviews + One_Star_Reviews), 4)
ORDER BY 
	ROUND(CAST((Five_Star_Reviews * 5) + (Four_Star_Reviews * 4) + (Three_Star_Reviews * 3) + (Two_Star_Reviews * 2) + (One_Star_Reviews * 1) AS FLOAT) / 
	(Five_Star_Reviews + Four_Star_Reviews + Three_Star_Reviews + Two_Star_Reviews + One_Star_Reviews), 4) DESC,
	ROUND(CAST(sub1.count_ontime AS FLOAT) / (sub1.count_ontime + sub2.count_late), 4) DESC;