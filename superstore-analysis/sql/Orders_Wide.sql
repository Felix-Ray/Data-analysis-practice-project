SELECT 
    `Order ID`,
    `Order Date`,
    `Customer ID`,
    Region,
    Category,
    `Sub-Category`,
    Sales,
    Quantity,
    Discount,
    Profit,
    CASE WHEN Profit < 0 THEN 1 ELSE 0 END AS is_loss,
    Discount * Sales AS discount_amount,
    IF(MONTH(`Order Date`) IN (11, 12), 1, 0) AS is_holiday_season
FROM `Sample - Superstore Source Data`;