-- SELECT ALL COLUMNS AND ROWS FROM THE PRODUCTS TABLE

SELECT *
FROM products;



-- SELECT the product name, brand name and category name for all products

SELECT p.product_name,b.brand_name,c.category_name
FROM brands b
JOIN products p
ON b.brand_id = p.brand_id
JOIN categories c
ON c.category_id = p.category_id;



-- COUNT THE NUMBER OF PRODUCTS 

SELECT  DISTINCT COUNT(*)
FROM products
ORDER BY 1;



-- SELECT PRICE RANGE FROM THE PRODUCTS TABLE

SELECT (MAX(list_price) - MIN(list_price)) AS Price_Range
FROM products;



-- WHAT IS THE AVERAGE PRICE FOR EACH CATEGORY?

SELECT category_name, AVG(list_price) AS 'Average Price'
FROM categories c
RIGHT JOIN products p
ON c.category_id = p.category_id
GROUP BY c.category_name
ORDER BY 2 DESC;



-- SELECT THE BRAND NAME AND THE NUMBER OF PRODUCTS FOR EACH BRAND

SELECT brand_name, COUNT(*) 'No of Products'
FROM brands b
LEFT JOIN products p
ON p.brand_id = b.brand_id
GROUP BY brand_name
ORDER BY 2 DESC;



-- WHAT IS THE MOST EXPENSIVE PRODUCT IN EACH CATEGORY
CREATE TEMPORARY TABLE product AS
(SELECT product_name,category_name, list_price,p.category_id,
ROW_NUMBER() OVER (PARTITION BY p.category_id ORDER BY list_price DESC) RN
FROM products p
LEFT JOIN categories c
ON p.category_id = c.category_id)

SELECT product_name,category_name,list_price
FROM product
WHERE RN = 1
ORDER BY list_price DESC;



-- BRANDS THAT HAVE MORE THAN 20 PRODUCTS
SELECT brand_name, AVG(list_price) AS 'Average Price'
FROM brands b
LEFT JOIN products p
ON b. brand_id = p.brand_id
GROUP BY brand_name
HAVING COUNT(*) > 20
ORDER BY 2 DESC;



/* AVERAGE PRICE FOR PRODUCTS IN EACH CATEGORY, 
 WITH AN AVERAGE PRICE LESS THAN 1000 */

SELECT category_name,
	product_name, 
		AVG(list_price) 
			OVER (PARTITION BY category_name) AS 'Average Price'
FROM categories c
LEFT JOIN products p
ON c.category_id = p.category_id
GROUP BY product_name
HAVING AVG(list_price) < 1000;



/* SELECT THE BRAND NAME, CATEGORY NAME AND NUMBER OF PRODUCTS FOR EACH COMBINATION OF BRAND AND PRODUCT */

SELECT brand_name,
	COALESCE(category_name,null,'None') AS category,
		COUNT(*) 'No of Products'
FROM brands
LEFT  JOIN categories
LEFT JOIN products
ON products.category_id = categories.category_id
ON brands.brand_id = categories.category_id
GROUP BY brand_name,category_name;



--  BRAND NAME AND THE NUMBER OF PRODUCTS, COMPARED TO THE TOTAL NUMBER OF PRODUCTS

SELECT brand_name, 
	COUNT(*) AS No_of_Products, 
		CONCAT((COUNT(*) / (SELECT COUNT(*) FROM products)) * 100,'%')  AS Percentage_of_products
FROM brands
LEFT JOIN products
ON brands.brand_id = products.brand_id
GROUP BY brand_name
ORDER BY 2 DESC;



-- THE TOP 3 MOST EXPENSIVE PRODUCTS IN EACH CATEGORY

CREATE TEMPORARY TABLE CTE3 AS
(SELECT product_name,category_name, list_price,p.category_id,
ROW_NUMBER() OVER (PARTITION BY p.category_id ORDER BY list_price DESC) RN
FROM products p
LEFT JOIN categories c
ON p.category_id = c.category_id)

SELECT product_name,list_price
FROM CTE3
WHERE RN <= 3;



-- COMPARE EACH YEAR'S AVERAGE PRICE
SELECT model_year, ROUND(AVG(list_price)) AS Average_Price
FROM products
GROUP BY model_year
ORDER BY 2 DESC;



-- BRANDS THAT HAVE MORE THAN 15% OF THE TOTAL AMOUNT OF PRODUCTS 

CREATE TEMPORARY TABLE Percent AS
(SELECT *,COUNT(*) AS No_of_Products, 
		(COUNT(*) / (SELECT COUNT(*) FROM products)) * 100  AS Percentage_of_products
FROM brands b
LEFT JOIN products p
USING(brand_id)
GROUP BY brand_name
)
SELECT brand_name, SUM(list_price) Total_Price
FROM Percent
WHERE Percentage_of_products > 15
GROUP BY brand_name;



-- HOW MUCH REVENUE EACH BRAND MADE EACH YEAR

SELECT brand_name, model_year, 
	SUM(list_price) 
		OVER(PARTITION BY model_year ORDER BY list_price DESC) Revenue
FROM brands
LEFT JOIN products
ON brands.brand_id = products.brand_id
GROUP BY brand_name,model_year
ORDER BY 2 DESC,3 DESC


