-- Checking all the columns and the data in the dataset
SELECT *
FROM bright_coffee_shop.sales_analysis.coffee_sales_analysis;

Checking the operational hours of the shops
SELECT 
    MIN(transaction_time) AS opening_time,
    MAX(transaction_time) AS closing_time,
FROM bright_coffee_shop.sales_analysis.coffee_sales_analysis;

Checking the minimum and the maximum date of the data
SELECT 
    MIN(transaction_date) AS first_month,
    MAX(transaction_date) AS last_month,
FROM bright_coffee_shop.sales_analysis.coffee_sales_analysis;

SELECT
    --DATES - extracting the date to check the days on which the sales were made, the months and the time of the day
    TO_DATE(transaction_date) AS purchase_date,
    DAYOFMONTH(TO_DATE(transaction_date)) AS day_of_month,
    DAYNAME(TO_DATE(transaction_date)) AS day_name,
    MONTHNAME(TO_DATE(transaction_date)) AS month_name,
    TO_CHAR(TO_DATE(transaction_date),'YYYYMM') AS month_id,
    HOUR(transaction_time) AS hour,

    CASE 
        WHEN transaction_time BETWEEN '06:00:00' AND '11:59:59' THEN 'Morning'
        WHEN transaction_time BETWEEN '12:00:00' AND '16:59:59' THEN 'Afternoon'
        WHEN transaction_time BETWEEN '17:00:00' AND '19:59:59' THEN 'Evening'
        ELSE 'Night'
        END AS time_buckets,

    CASE
        WHEN DAYNAME(TO_DATE(transaction_date)) IN ('Sat', 'Sun') THEN 'Weekend'
        ELSE 'Weekday'
        END AS day_classification,

    CASE
        WHEN MONTHNAME(TO_DATE(transaction_date)) IN('Jan', 'Feb') THEN 'Summer'
        WHEN MONTHNAME(TO_DATE(transaction_date)) IN('Mar', 'Apr', 'May') THEN 'Autumn'
        ELSE 'Winter'
        END AS seasons_of_the_year,

        --SUM, calculating revenue
        ROUND(SUM(IFNULL(transaction_qty,0)*(IFNULL(unit_price,0))),0) AS Revenue,

    --COUNTS - To know how many shops we have, how many products are being sold and sales made within the time period
    COUNT (DISTINCT transaction_id) AS number_of_sales,
    COUNT (DISTINCT product_id) AS number_of_unique_products,
    COUNT (DISTINCT store_id) AS number_of_shops,

    --CATEGORIES
    product_category,
    product_detail,
    product_type,
    store_location,
FROM bright_coffee_shop.sales_analysis.coffee_sales_analysis
GROUP BY ALL;
