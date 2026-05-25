-- 假设分析日期为 2018-01-01（数据集最大订单日期 2017-12-30）
WITH customer_base AS (
  SELECT 
    `Customer ID`,
    MAX(`Order Date`) AS last_order_date,
    COUNT(DISTINCT `Order ID`) AS frequency,
    SUM(`Sales`) AS monetary,
    AVG(`Discount`) AS avg_discount,
    SUM(`Profit`) AS total_profit
  FROM `Sample - Superstore Source Data`
  GROUP BY `Customer ID`
),
rfm_raw AS (
  SELECT 
    `Customer ID`,
    DATEDIFF('2018-01-01', last_order_date) AS recency,
    frequency,
    monetary,
    avg_discount,
    total_profit,
    NTILE(4) OVER (ORDER BY DATEDIFF('2018-01-01', last_order_date) DESC) AS r_score,
    NTILE(4) OVER (ORDER BY frequency) AS f_score,
    NTILE(4) OVER (ORDER BY monetary) AS m_score
  FROM customer_base
)
SELECT 
  *,
  (r_score * 100 + f_score * 10 + m_score) AS rfm_score,
  CASE 
    WHEN r_score >= 3 AND f_score >= 3 AND m_score >= 3 THEN '高价值'
    WHEN r_score <= 2 AND f_score <= 2 AND m_score <= 2 THEN '低价值'
    ELSE '中价值'
  END AS customer_segment
FROM rfm_raw;