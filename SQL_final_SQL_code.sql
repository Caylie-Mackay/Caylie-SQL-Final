SELECT COUNT(DISTINCT si.retailer)
from Store_info si

-- Data was pulled from 12 different retailers.

SELECT COUNT(DISTINCT ti.transaction_id)
from Transaction_info ti

--Data contains 2341 unique transactions.

SELECT COUNT(DISTINCT pi.sku)
from Product_info pi

--There are 2314 unique sku numbers in this dataset.

SELECT retailer, ROUND(avg((ti.subtotal_before_discount - ti.total_after_discount)),2) as avg_discount
FROM Transaction_info ti
GROUP BY retailer 
ORDER BY avg_discount desc

--Top 3 retailers for best avg discount are 84 lumber, menards, Lowes.

SELECT ti.retailer , si.store_location , ti."bulk_discount_applied_%" , ti.subtotal_before_discount ,(ti.subtotal_before_discount - ti.total_after_discount) AS total_discount
FROM Transaction_info ti 
JOIN Store_info si 
	ON ti.transaction_id = si.transaction_id 
ORDER BY subtotal_before_discount  DESC

-- The store with the largest single order is 84 Lumber in New Rachel, MT, of 377,689 and a total discount of 75,537.80

--The Lowe's with the highest discount was in Petermouth, AK on an order of 210716.25.
--The total discount was 46357.57

SELECT ti.department, pi.brand, pi.sku, ti.unit_price 
FROM Transaction_info ti 
LEFT JOIN Product_info pi 
	ON ti.sku = pi.sku
WHERE ti.unit_price  > (SELECT AVG(ti2.unit_price) FROM Transaction_info ti2 )
	AND ti.department != '	'
ORder BY pi.unit_price DESC;

-- The top 3 brands with prodects most expensive above the average unit price are BOSCH, Ryobi, Samsung.

SELECT pi.brand, ROUND(AVG(ti."bulk_discount_applied_%"), 2) AS AVG_discount_percent
FROM Transaction_info ti 
RIGHT JOIN Product_info pi 
	ON ti.sku = pi.sku 
GROUP BY pi.brand 
HAVING ROUND(AVG(ti."bulk_discount_applied_%"), 2) > 7

--There are 4 brands that had an average bulk discount percent of 7% or higher.
--GE, LG, Milwaukee, Rust-Oleum.

SELECT ti.department, SUM(ti.quantity) AS Total_num_of_items, ROUND(AVG(ti."bulk_discount_applied_%"), 2) AS avg_bulk_discount_percent
FROM Transaction_info ti 
GROUP BY ti.department 
ORDER BY Total_num_of_items DESC

--The department with the highest number of items sold was flooring.
--This could be due to boxes of flooring being sold per peice.