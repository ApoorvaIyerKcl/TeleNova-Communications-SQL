1. Which telecom circles generate the highest ARPU?

SELECT ms.telecom_circle_name,
ROUND(SUM(pr.net_revenue_inr) / NULLIF(SUM(ms.active_subscribers), 0), 2) AS arpu
FROM market_share ms
JOIN plan_revenue pr
ON ms.month = pr.billing_month
GROUP BY ms.telecom_circle_name
ORDER BY arpu DESC;

2. Which plans have the lowest data utilisation ratio?

SELECT d.plan_id,
ROUND(AVG(d.data_consumed_mb) / NULLIF(AVG(p.monthly_data_allowance_gb * 1024), 0), 3) AS utilisation_ratio
FROM daily_usage_duplicate1 d
JOIN plan_duplicate p
ON d.plan_id = p.plan_id
GROUP BY d.plan_id
ORDER BY utilisation_ratio ASC;

3. Which customer segments generate high revenue but low data usage?

SELECT c.user_segment, SUM(pr.net_revenue_inr) AS total_revenue, AVG(d.data_consumed_mb) AS avg_data_usage
FROM customers_duplicate c
JOIN plan_revenue pr ON c.customer_id = pr.customer_id
JOIN daily_usage_duplicate1 d ON c.customer_id = d.customer_id
GROUP BY c.user_segment
ORDER BY total_revenue DESC;

4. What is the churn rate by telecom circle?

SELECT ci.telecom_circle_name,
ROUND(COUNT(
CASE WHEN cs.customer_status = 'Churned' THEN 1 
END) * 1.0/ COUNT(*), 3
) AS churn_rate
FROM customer_status_duplicate cs
JOIN cities_duplicate ci
ON cs.customer_id IS NOT NULL
GROUP BY ci.telecom_circle_name
ORDER BY churn_rate DESC;

5. Which competitors are gaining the highest revenue-weighted churn?

SELECT cs.competitor_name,
SUM(pr.net_revenue_inr) AS revenue_lost
FROM customer_status_duplicate cs
JOIN plan_revenue pr
ON cs.customer_id = pr.customer_id
WHERE cs.customer_status = 'Churned'
GROUP BY cs.competitor_name
ORDER BY revenue_lost DESC;

6. Which plans show high subscriber volume but low ARPU?

SELECT pr.plan_id,
COUNT(DISTINCT pr.customer_id) AS subscriber_count,
ROUND(SUM(pr.net_revenue_inr) / NULLIF(COUNT(DISTINCT pr.customer_id), 0), 2) AS arpu
FROM plan_revenue pr
GROUP BY pr.plan_id
ORDER BY subscriber_count DESC;

7. How does data usage differ across plan categories?

SELECT p.plan_category, ROUND(AVG(d.data_consumed_mb), 2) AS avg_data_usage
FROM daily_usage_duplicate1 d
JOIN plan_duplicate p
ON d.plan_id = p.plan_id
GROUP BY p.plan_category
ORDER BY avg_data_usage DESC;

8. Which customer types cause the highest revenue leakage?

SELECT c.customer_type,
SUM(pr.discount_applied_inr + pr.refund_amount_inr) AS revenue_leakage
FROM customers_duplicate c
JOIN plan_revenue pr
ON c.customer_id = pr.customer_id
GROUP BY c.customer_type
ORDER BY revenue_leakage DESC;

9. Which telecom circles show high usage but weak market share?

SELECT ms.telecom_circle_name,
ROUND(AVG(ms.market_share_percentage), 2) AS avg_market_share,
ROUND(AVG(d.data_consumed_mb), 2) AS avg_data_usage
FROM market_share ms
JOIN daily_usage_duplicate1 d
ON ms.month = d.date_key
GROUP BY ms.telecom_circle_name;

10. Which plans are operationally unsustainable long-term?

SELECT d.plan_id,
ROUND(AVG(d.data_consumed_mb), 2) AS avg_data_usage,
SUM(pr.net_revenue_inr) AS total_revenue
FROM daily_usage_duplicate1 d
JOIN plan_revenue pr
ON d.customer_id = pr.customer_id
GROUP BY d.plan_id
ORDER BY avg_data_usage DESC;

