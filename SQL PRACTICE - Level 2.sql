  --- question 1 
  SELECT book_title , year_of_publication 
  FROM books_schema.books1
  WHERE year_of_publication >=1997
  union 
  SELECT book_title , year_of_publication
  FROM books_schema.books2
  WHERE year_of_publication  BETWEEN 1997 AND 2005 
  ORDER BY year_of_publication DESC;

--- question 2 
SELECT DISTINCT publisher  from books_schema.books1
WHERE year_of_publication = 1990
INTERSECT
SELECT DISTINCT publisher from books_schema.books2
WHERE year_of_publication =2004 


---question 3 
SELECT DISTINCT publisher  from books_schema.books1
WHERE year_of_publication = 1990
EXCEPT  
SELECT DISTINCT publisher from books_schema.books2
WHERE year_of_publication =2004 


--- question 4
SELECT o.order_id , o.order_item_id , p.product_id ,p.product_category_name,o.price
FROM ecommerce_schema.order_items as o
INNER JOIN ecommerce_schema.products as p on o.product_id = p.product_id 
WHERE price > 3000
order BY 1 ,2 desc;  


--- question 5 
SELECT o.order_id  , oi.order_item_id ,p.product_id , p.product_category_name ,oi.price , o.order_status
FROM ecommerce_schema.orders as o 
left JOIN ecommerce_schema.order_items as oi ON oi.order_id = o.order_id
left JOIN ecommerce_schema.products as p on p.product_id = oi.product_id
WHERE o.order_status = 'shipped' AND price BETWEEN 50 AND 60 
order by 1,2; 

---question 6
select p.product_id ,o.order_id ,o.order_item_id , p.product_category_name , o.price
FROM ecommerce_schema.products as p 
left JOIN ecommerce_schema.order_items as o on p.product_id = o.product_id
WHERE p.product_category_name ='art';


---question 7 
SELECT product_id , product_category_name ,product_price 
FROM ecommerce_schema.products
WHERE product_category_name IN ('art', 'perfumery')
AND product_price < (SELECT avg(product_price)
FROM ecommerce_schema.products);

-- question 8 
SELECT customer_name 
FROM ecommerce_schema.customers
WHERE customer_id in
 (SELECT customer_id
FROM ecommerce_schema.orders
WHERE order_status='delivered'
AND order_id IN
(SELECT order_id 
FROM ecommerce_schema.order_items
WHERE price > 120
AND product_id IN
(SELECT product_id
FROM ecommerce_schema.products
WHERE product_category_name ='art')))




select  order_id
,CASE review_score
  WHEN '1' THEN 'Very Dissatisfied'
  WHEN '2' THEN 'Dissatisfied'
  WHEN '3' then 'Neutral'
  WHEN '4' THEN 'Satisfied' 
  ELSE 'Very Satisfied' 
END as review_score_test
 FROM ecommerce_schema.order_reviews;

 SELECT product_id ,product_category_name ,product_price
 ,CASE 
  WHEN product_price <= 50 THEN 'Low Price'
  WHEN product_price > 50 and product_price < 100 THEN 'Medium price'
  WHEN product_price >100 THEN 'High Price' 
  ELSE 'others' 
 END as product_price_j
 FROM ecommerce_schema.products;

--question 11
 SELECT  
CASE  
WHEN product_price<=50 THEN 'Low Price' 
WHEN product_price>50 AND product_price<100 THEN 'Medium Price' 
ELSE 'High Price' 
END AS price_category, count(distinct product_id) AS amount_products 
FROM ecommerce_schema.products 
GROUP BY 1 

--question 12
    SELECT product_id , product_price ,product_category_name ,avg(product_price) OVER (PARTITION BY product_category_name)
    FROM ecommerce_schema.products
    WHERE product_price is NOT NULL
    ORDER BY product_price DESC ;


--question 13
SELECT * 
FROM ( 
SELECT product_id, product_category_name, product_weight_g, ROW_NUMBER() 
OVER (PARTITION BY product_category_name ORDER BY product_weight_g DESC) as 
row_num 
FROM ecommerce_schema.products 
WHERE product_price IS NOT NULL 
) as t 
WHERE row_num <= 5;

--question 14
CREATE VIEW ecommerce_schema.customers_shipped_vw AS 
( 
SELECT c.customer_id, c.customer_name, c.customer_city, o.order_status 
FROM ecommerce_schema.customers as c 
INNER JOIN ecommerce_schema.orders as o ON c.customer_id = o.customer_id 
WHERE o.order_status = 'shipped' 
); 
SELECT * 
FROM ecommerce_schema.customers_shipped_vw;

--question 15
WITH product_category_CTE  
AS 
( 
SELECT product_id, product_category_name, product_price, ROW_NUMBER() OVER (PARTITION    
BY product_category_name ORDER BY product_price DESC) as row_num 
FROM ecommerce_schema.products 
WHERE product_price IS NOT NULL 
) 
SELECT *  
FROM product_category_CTE 
WHERE row_num <= 3