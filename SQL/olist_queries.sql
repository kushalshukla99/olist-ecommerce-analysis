
-- Q1: Revenue Trends Over Time

SELECT 
    substr(o.order_purchase_timestamp, 1, 7) AS order_month,
    SUM(oi.price) AS total_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY order_month
ORDER BY order_month;


-- Q2: Top-Selling Categories

SELECT 
    t.product_category_name_english AS category,
    SUM(oi.price) AS total_revenue,
    COUNT(oi.order_id) AS total_items_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN category_translation t ON p.product_category_name = t.product_category_name
GROUP BY category
ORDER BY total_revenue DESC
LIMIT 10;


-- Q3: State-wise Order Distribution

SELECT 
    c.customer_state AS state,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY state
ORDER BY total_orders DESC
LIMIT 10;


-- Q4: Delivery Delay Impact on Reviews

SELECT 
    CASE 
        WHEN julianday(o.order_delivered_customer_date) > julianday(o.order_estimated_delivery_date) 
        THEN 'Delayed'
        ELSE 'On Time'
    END AS delivery_status,
    ROUND(AVG(r.review_score), 2) AS avg_review_score,
    COUNT(*) AS total_orders
FROM orders o
JOIN order_reviews r ON o.order_id = r.order_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY delivery_status;


-- Q5: Top-Performing Sellers

SELECT 
    oi.seller_id,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    SUM(oi.price) AS total_revenue
FROM order_items oi
GROUP BY oi.seller_id
ORDER BY total_revenue DESC
LIMIT 10;
