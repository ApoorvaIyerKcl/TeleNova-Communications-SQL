USE telecom_industry;

---CREATE TABLE---

CREATE TABLE date(
date_key VARCHAR (50),
date_value VARCHAR (50),
year VARCHAR (50),
month_number INT,
month_name VARCHAR (50),
quarter INT,
week_of_year VARCHAR (50),
day_of_week_number INT,
day_of_week_name VARCHAR (50),
is_weekend_flag VARCHAR (50)
);

SHOW VARIABLES LIKE 'secure_file_priv';
LOAD DATA INFILE 'C:/Apoorva/Acciojob/SQL/TI-date.csv'
INTO TABLE date
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

CREATE TABLE cities(
city_id INT,
city_name VARCHAR (50),
telecom_circle_name VARCHAR (50),
region_name VARCHAR (50),
city_tier VARCHAR (50),
urban_rural_flag VARCHAR (50)
);

LOAD DATA INFILE "C:/Apoorva/Acciojob/SQL/TI-cities.csv"
INTO TABLE cities
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

CREATE TABLE customers (
    customer_identifier VARCHAR(20),
    customer_age INTEGER,
    customer_gender VARCHAR(30),
    city_identifier INTEGER,
    activation_date TEXT,
    customer_type VARCHAR(20),
    user_segment VARCHAR(50),
    kyc_status VARCHAR(20),
    sim_type VARCHAR(20)
);

ALTER TABLE customers
RENAME COLUMN customer_identifier TO customer_id,
RENAME COLUMN city_identifier TO city_id;

LOAD DATA INFILE "C:/Apoorva/Acciojob/SQL/TI-customers.csv"
INTO TABLE customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

DROP TABLE daily_usage;
CREATE TABLE daily_usage (
    date_key INTEGER,
    customer_id VARCHAR(20),
    plan_id INTEGER,
    data_allocated_mb INTEGER,
    data_carried_forward_mb INTEGER,
    data_consumed_mb INTEGER,
    voice_minutes_used INTEGER,
    sms_used INTEGER,
    network_type VARCHAR(10),
    usage_source VARCHAR(20)
);

LOAD DATA INFILE "C:/Apoorva/Acciojob/SQL/TI-daily_usage.csv"
INTO TABLE daily_usage
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(date_key, customer_id, plan_id, data_allocated_mb,@data_carried_forward_mb, @data_consumed_mb, voice_minutes_used,
sms_used,network_type, usage_source)
SET data_consumed_mb = NULLIF(@data_consumed_mb, ''),
data_carried_forward_mb = NULLIF(@data_carried_forward_mb, '');

CREATE TABLE market_share (
    month VARCHAR(7),
    telecom_circle_name VARCHAR(100),
    operator_name VARCHAR(50),
    market_share_percentage DECIMAL(6,2),
    active_subscribers INTEGER
);

CREATE TABLE plan (
   plan_id INT,
   plan_name VARCHAR (50),	
   customer_type VARCHAR (50),
   plan_validity_days INT,
   daily_data_limit_gb DECIMAL (10,2),
   monthly_data_allowance_gb INT,
   voice_unlimited_flag VARCHAR (50),
   rollover_allowed_flag VARCHAR (50),
   fair_usage_policy_limit_gb INT,
   plan_category VARCHAR (50),
   plan_launch_date VARCHAR (50),
   plan_discontinued_date VARCHAR (50)
);

ALTER TABLE plan
MODIFY monthly_data_allowance_gb INT NULL;

ALTER TABLE plan
MODIFY daily_data_limit_gb INT NULL;

LOAD DATA INFILE "C:/Apoorva/Acciojob/SQL/TI-plan.csv"
INTO TABLE plan
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
plan_id, plan_name,	customer_type, plan_validity_days, @daily_data_limit_gb, @monthly_data_allowance_gb, voice_unlimited_flag,
rollover_allowed_flag, fair_usage_policy_limit_gb, plan_category, plan_launch_date, plan_discontinued_date
)
SET
monthly_data_allowance_gb = NULLIF(@monthly_data_allowance_gb,''),
daily_data_limit_gb= NULLIF(@daily_data_limit_gb, '');

DROP TABLE plan_revenue;
CREATE TABLE plan_revenue (
    billing_id VARCHAR (50),
    billing_month VARCHAR (50),
    customer_id VARCHAR (50),
    plan_id VARCHAR (50),
    billed_amount_inr DECIMAL(12,2),
    discount_applied_inr DECIMAL(12,2),
    late_fee_inr DECIMAL(12,2),
    refund_amount_inr DECIMAL(12,2),
    net_revenue_inr INT NULL,
    billing_status VARCHAR(50)
);

LOAD DATA INFILE "C:/Apoorva/Acciojob/SQL/TI-plan_revenue.csv"
INTO TABLE plan_revenue
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(billing_id, billing_month, customer_id, plan_id, billed_amount_inr,
@discount_applied_inr, late_fee_inr, refund_amount_inr, @net_revenue_inr, billing_status
)
SET net_revenue_inr = NULLIF(@net_revenue_inr, ''),
discount_applied_inr = NULLIF(@discount_applied_inr, '');

CREATE TABLE customer_status(
status_date_key	INT NULL,
customer_id VARCHAR (50),
customer_status	VARCHAR (50) NULL,
churn_reason VARCHAR (50) NULL,
competitor_name VARCHAR (50) NULL
);

LOAD DATA INFILE "C:/Apoorva/Acciojob/SQL/TI-customer_status.csv"
INTO TABLE customer_status
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS ( @status_date_key, customer_id, customer_status, churn_reason, competitor_name)
SET status_date_key = NULLIF(@status_date_key, '');

 
---CREATE DUPLICATE TABLES---

CREATE TABLE cities_duplicate
LIKE cities;

INSERT cities_duplicate
SELECT * FROM  cities;

CREATE TABLE customer_status_duplicate
LIKE customer_status;

INSERT customer_status_duplicate
SELECT * FROM customer_status;

CREATE TABLE daily_usage_duplicate
LIKE daily_usage;

INSERT daily_usage_duplicate
SELECT * FROM daily_usage;

CREATE TABLE customers_duplicate
LIKE customers;

INSERT customers_duplicate
SELECT * FROM customers;

ALTER TABLE customers_duplicate
RENAME COLUMN city_identifier TO city_id
RENAME COLUMN customer_identifier TO customer_id;

CREATE TABLE customers_duplicate
LIKE customers;

INSERT customers_duplicate
SELECT * FROM customers;

CREATE TABLE date_duplicate
LIKE date;

INSERT date_duplicate
SELECT * FROM date;

CREATE TABLE market_share_duplicate
LIKE market_share;

INSERT market_share_duplicate
SELECT * FROM market_share;

CREATE TABLE plan_duplicate
LIKE plan;

INSERT plan_duplicate
SELECT * FROM plan;

CREATE TABLE plan_revenue_duplicate
LIKE plan_revenue;

INSERT plan_revenue_duplicate
SELECT * FROM plan_revenue;

---FINDIND AND REMOVING DUPLICATES---

---Finding and removing DUPLICATES from cities_duplicate---

SELECT * FROM cities_duplicate;

SELECT * FROM (SELECT *, ROW_NUMBER() OVER(PARTITION BY city_id, city_name, telecom_circle_name, region_name, city_tier, urban_rural_flag 
ORDER BY city_id) AS rank_value
FROM cities_duplicate) AS row_number_value
WHERE rank_value > 1;

WITH CTE AS ( SELECT city_id, city_name, telecom_circle_name, region_name, city_tier, urban_rural_flag, 
ROW_NUMBER() OVER ( PARTITION BY city_id, city_name,  telecom_circle_name, region_name, city_tier, urban_rural_flag 
ORDER BY city_id ) AS rank_value 
FROM cities_duplicate)
DELETE FROM cities_duplicate 
WHERE (city_id, city_name, telecom_circle_name, region_name, city_tier, urban_rural_flag) IN (
SELECT city_id, city_name, telecom_circle_name, region_name, city_tier, urban_rural_flag
FROM CTE
WHERE rank_value > 1
);

---Finding and removing DUPLICATES from customer_status_duplicate---

SELECT * FROM customer_status_duplicate;

SELECT status_date_key, customer_id, customer_status, churn_reason, competitor_name, rank_value
FROM (SELECT status_date_key, customer_id, customer_status, churn_reason, competitor_name,
ROW_NUMBER() OVER (PARTITION BY status_date_key, customer_id, customer_status, churn_reason, competitor_name ORDER BY status_date_key) AS rank_value
FROM customer_status_duplicate) AS row_number_value
WHERE rank_value > 1;

WITH CTE AS (SELECT status_date_key, customer_id, customer_status, churn_reason, competitor_name,
ROW_NUMBER() OVER (PARTITION BY status_date_key, customer_id, customer_status, churn_reason, competitor_name ORDER BY status_date_key) AS rank_value
FROM customer_status_duplicate
)
DELETE FROM customer_status_duplicate
WHERE (status_date_key, customer_id, customer_status, churn_reason, competitor_name)
IN (SELECT status_date_key, customer_id, customer_status, churn_reason, competitor_name
FROM CTE
WHERE rank_value > 1
);


---Finding and removing DUPLICATES from customers_duplicate---

SELECT * FROM (SELECT*, ROW_NUMBER() OVER (PARTITION BY customer_id, customer_age, customer_gender, city_id, activation_date, customer_type,
user_segment, kyc_status, sim_type) AS rank_value FROM customers_duplicate ORDER BY customer_id) AS row_number_value
WHERE rank_value > 1;

WITH CTE AS (SELECT *, ROW_NUMBER() OVER (PARTITION BY customer_id, customer_age, customer_gender, city_id, activation_date, customer_type, user_segment, 
kyc_status, sim_type ORDER BY customer_id) AS rank_value 
FROM customers_duplicate
) 
DELETE FROM customers_duplicate 
WHERE (customer_id, customer_age, customer_gender, city_id, activation_date, customer_type, user_segment, kyc_status, sim_type) 
IN (SELECT customer_id, customer_age, customer_gender, city_id, activation_date, customer_type, user_segment, kyc_status, sim_type 
FROM CTE 
WHERE rank_value > 1
);


---Finding and removing DUPLICATES from daily_usage_duplicate---

SELECT * FROM ( SELECT *, ROW_NUMBER() OVER(PARTITION BY date_key, customer_id, plan_id, data_allocated_mb,
data_carried_forward_mb, data_consumed_mb, voice_minutes_used, sms_used, network_type, usage_source ORDER BY date_key) AS rank_value FROM daily_usage_duplicate)
AS row_number_value
WHERE rank_value>1;

WITH CTE AS (
SELECT *, ROW_NUMBER() OVER(PARTITION BY date_key, customer_id, plan_id, data_allocated_mb, data_carried_forward_mb, data_consumed_mb, 
voice_minutes_used, sms_used, network_type, usage_source ORDER BY date_key) AS rank_value
FROM daily_usage_duplicate
)
SELECT COUNT(*)
FROM CTE
WHERE rank_value > 1;

CREATE TABLE `daily_usage_duplicate1` (
  `date_key` int DEFAULT NULL,
  `customer_id` varchar(20) DEFAULT NULL,
  `plan_id` int DEFAULT NULL,
  `data_allocated_mb` int DEFAULT NULL,
  `data_carried_forward_mb` int DEFAULT NULL,
  `data_consumed_mb` int DEFAULT NULL,
  `voice_minutes_used` int DEFAULT NULL,
  `sms_used` int DEFAULT NULL,
  `network_type` varchar(10) DEFAULT NULL,
  `usage_source` varchar(20) DEFAULT NULL,
  `row_number_value` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO daily_usage_duplicate1
SELECT *, ROW_NUMBER() OVER(PARTITION BY date_key, customer_id, plan_id, data_allocated_mb,
data_carried_forward_mb, data_consumed_mb, voice_minutes_used, sms_used, network_type, usage_source ORDER BY date_key) AS row_number_value
FROM daily_usage_duplicate;

SELECT * FROM daily_usage;
SELECT * FROM daily_usage_duplicate;
SELECT * FROM daily_usage_duplicate1;

SELECT COUNT(*)
FROM daily_usage_duplicate1
WHERE row_number_value > 1;

DELETE FROM daily_usage_duplicate1
WHERE row_number_value > 1;

---Finding and removing DUPLICATES from date_duplicate---

SELECT * FROM date_duplicate;

SELECT * FROM (SELECT *, ROW_NUMBER () OVER (PARTITION BY date_key, date_value, year, month_number, month_name,
quarter, week_of_year, day_of_week_number, day_of_week_name, is_weekend_flag) AS rank_value FROM date_duplicate)
AS row_number_value
WHERE rank_value > 1;

---Finding and removing DUPLICATES from market_share_duplicate---

SELECT * FROM market_share_duplicate;

SELECT * FROM ( SELECT *, ROW_NUMBER () OVER(PARTITION BY month, telecom_circle_name, operator_name, market_share_percentage, active_subscribers)
AS rank_value FROM market_share_duplicate ORDER BY month) AS row_number_value
WHERE rank_value > 1;

---Finding and removing DUPLICATES from plan_duplicate---

SELECT * FROM plan_duplicate;
SELECT * FROM plan;

SELECT * FROM ( SELECT *, ROW_NUMBER () OVER(PARTITION BY plan_id, plan_name, customer_type, plan_validity_days, daily_data_limit_gb, 
monthly_data_allowance_gb, voice_unlimited_flag, rollover_allowed_flag, fair_usage_policy_limit_gb, plan_category, plan_launch_date, plan_discontinued_date
ORDER BY plan_id) AS rank_value FROM plan_duplicate) AS row_number_value
WHERE rank_value > 1;

ALTER TABLE plan_duplicate
ADD COLUMN plan_row_id BIGINT AUTO_INCREMENT PRIMARY KEY;

WITH CTE AS ( SELECT plan_row_id,
ROW_NUMBER() OVER (PARTITION BY plan_id, plan_name, customer_type, plan_validity_days, daily_data_limit_gb, 
monthly_data_allowance_gb, voice_unlimited_flag, rollover_allowed_flag, fair_usage_policy_limit_gb, plan_category, plan_launch_date, plan_discontinued_date
ORDER BY plan_row_id) AS rn
FROM plan_duplicate
) 
DELETE FROM plan_duplicate
WHERE plan_row_id IN (SELECT plan_row_id FROM cte WHERE rn > 1);



---Finding and removing DUPLICATES from plan_revenue_duplicate---

SELECT * FROM plan_revenue_duplicate;

SELECT * FROM ( SELECT *, ROW_NUMBER () OVER(PARTITION BY billing_id, billing_month, customer_id, plan_id, billed_amount_inr,
discount_applied_inr, late_fee_inr, refund_amount_inr, net_revenue_inr, billing_status) AS rank_value FROM plan_revenue_duplicate)
AS row_number_value
WHERE rank_value >1;

WITH CTE AS ( SELECT billing_id, ROW_NUMBER () OVER(PARTITION BY billing_id, billing_month, customer_id, plan_id, billed_amount_inr,
discount_applied_inr, late_fee_inr, refund_amount_inr, net_revenue_inr, billing_status ORDER BY billing_id) AS rank_value
FROM plan_revenue_duplicate)

DELETE FROM plan_revenue_duplicate
WHERE billing_id 
IN ( SELECT billing_id 
FROM CTE
WHERE rank_value > 1
);

WITH CTE AS ( SELECT *, ROW_NUMBER () OVER(PARTITION BY billing_id, billing_month, customer_id, plan_id, billed_amount_inr,
discount_applied_inr, late_fee_inr, refund_amount_inr, net_revenue_inr, billing_status ORDER BY billing_id) AS rank_value
FROM plan_revenue_duplicate)
SELECT COUNT(*)
FROM CTE
WHERE rank_value > 1;

---STANDARDISING DATA---

--- Standardising data for cities_duplicate ---
SELECT * FROM cities_duplicate;
UPDATE cities_duplicate
SET city_id = COALESCE(city_id, 0),
city_name = COALESCE(NULLIF(TRIM(city_name), ''), 'Not Available'),
telecom_circle_name = COALESCE(NULLIF(TRIM(telecom_circle_name),' '), 'Not Available'),
region_name = COALESCE(NULLIF(TRIM(region_name), ''), 'Not Available'),
city_tier = COALESCE(NULLIF(TRIM(city_tier), ''), 'Not Available'),
urban_rural_flag = COALESCE(NULLIF(TRIM(urban_rural_flag), ''), 'Not Available');

--- Standardising data for customer_status_duplicate ---
SELECT * FROM customer_status_duplicate;
UPDATE customer_status_duplicate
SET status_date_key = COALESCE(status_date_key, 0),
customer_id = COALESCE(customer_id, 0),
customer_status = COALESCE(NULLIF(TRIM(customer_status), ''), 'Not Available'),
churn_reason = COALESCE(NULLIF(TRIM(churn_reason), ''), 'Not Available'),
competitor_name = COALESCE(NULLIF(TRIM(competitor_name), ''), 'Not Available');

--- Standardising data for customers_duplicate ---
SELECT * FROM customers_duplicate;
UPDATE customers_duplicate
SET customer_id = COALESCE(customer_id,0),
customer_age = COALESCE(customer_age, 0),
customer_gender = COALESCE(NULLIF(TRIM(customer_gender), ''), 'Not Available'),
city_id = COALESCE(city_id, 0),
activation_date = COALESCE(activation_date, '1900-11-01'),
customer_type = COALESCE(NULLIF(TRIM(customer_type), ''), 'Not Available'),
user_segment = COALESCE(NULLIF(TRIM(user_segment), ''), 'Not Available'),
kyc_status = COALESCE(NULLIF(TRIM(kyc_status), ''), 'Not Available'),
sim_type = COALESCE(NULLIF(TRIM(sim_type), ''), 'Not Available');

--- Standardising data for daily_usage_duplicate ---
SELECT * FROM daily_usage_duplicate;
UPDATE daily_usage_duplicate
SET date_key = COALESCE(date_key, 0),
customer_id = COALESCE(customer_id, 0),
plan_id = COALESCE(plan_id, 0),
data_allocated_mb = COALESCE(data_allocated_mb, 0),
data_carried_forward_mb = COALESCE(data_carried_forward_mb, 0),
data_consumed_mb = COALESCE(data_consumed_mb, 0),
voice_minutes_used = COALESCE(voice_minutes_used, 0),
sms_used = COALESCE(sms_used, 0),
network_type = COALESCE(NULLIF(TRIM(network_type), ''), 'Not Available'),
usage_source = COALESCE(NULLIF(TRIM(usage_source), ''), 'Not Available');

--- Standardising data for date_duplicate ---
SELECT * FROM date_duplicate;
UPDATE date_duplicate
SET date_key = COALESCE(date_key, 0),
date_value = COALESCE(date_value, '1900-11-01'),
year = COALESCE(year, 0000),
month_number = COALESCE(month_number, 0),
month_name = COALESCE(NULLIF(TRIM(month_name), ''), 'Not Available'),
quarter = COALESCE(quarter, 0),
week_of_year = COALESCE(week_of_year, 00),
day_of_week_number = COALESCE(day_of_week_number, 0),
day_of_week_name = COALESCE(NULLIF(TRIM(day_of_week_name), ''), 'Not Available'),
is_weekend_flag = COALESCE(is_weekend_flag, 'Not Available');

--- Standardising data for market_share_duplicate ---
SELECT * FROM market_share_duplicate;
UPDATE market_share_duplicate
SET month = COALESCE(month, 0000-00),
telecom_circle_name = COALESCE(NULLIF(TRIM(telecom_circle_name), ''), 'Not Available'),
operator_name = COALESCE(NULLIF(TRIM(operator_name), ''), 'Not Available'),
market_share_percentage = COALESCE(market_share_percentage, 0.0),
active_subscribers = COALESCE(active_subscribers, 0);

--- Standardising data for plan_duplicate ---
SELECT * FROM plan_duplicate;
UPDATE plan_duplicate
SET plan_id = COALESCE(plan_id, 0),
plan_name = COALESCE(NULLIF(TRIM(plan_name), ''), 'Not Available'),
customer_type = COALESCE(NULLIF(TRIM(customer_type), ''), 'Not Available'),
plan_validity_days = COALESCE(plan_validity_days, 0),
daily_data_limit_gb = COALESCE(daily_data_limit_gb, 0),
monthly_data_allowance_gb = COALESCE(monthly_data_allowance_gb, 0),
voice_unlimited_flag = COALESCE(NULLIF(TRIM(voice_unlimited_flag), ''), 'Not Available'),
rollover_allowed_flag = COALESCE(NULLIF(TRIM(rollover_allowed_flag), ''), 'Not Available'),
fair_usage_policy_limit_gb = COALESCE(fair_usage_policy_limit_gb, 0),
plan_category = COALESCE(NULLIF(TRIM(plan_category), ''), 'Not Available'),
plan_launch_date = COALESCE(NULLIF(TRIM(plan_launch_date), ''), '1900-11-01'),
plan_discontinued_date = COALESCE(NULLIF(TRIM(plan_discontinued_date), ''), '1900-11-01');

--- Standardising data for plan_revenue_duplicate ---
SELECT * FROM plan_revenue_duplicate;
UPDATE plan_revenue_duplicate
SET billing_id = COALESCE(billing_id, 0),
billing_month = COALESCE(billing_month, 0),
customer_id = COALESCE(customer_id, 0),
plan_id = COALESCE(plan_id, 0),
billed_amount_inr = COALESCE(billed_amount_inr, 0),
discount_applied_inr = COALESCE(discount_applied_inr, 0),
late_fee_inr = COALESCE(late_fee_inr, 0),
refund_amount_inr = COALESCE(refund_amount_inr, 0),
net_revenue_inr = COALESCE(net_revenue_inr, 0),
billing_status = COALESCE(NULLIF(TRIM(billing_status), ''), 'Not Available');

SELECT * FROM cities_duplicate;
SELECT * FROM customer_status_duplicate;
SELECT * FROM customers_duplicate;
SELECT * FROM daily_usage_duplicate1;
SELECT * FROM date_duplicate;
SELECT * FROM market_share;
SELECT * FROM market_share_duplicate;
SELECT * FROM plan_duplicate;
SELECT * FROM plan;
SELECT * FROM plan_revenue_duplicate;

---Verifying NULLS and EMPTY SPACES in all tables---

--- Verification for cities_duplicate ---
SELECT * FROM cities_duplicate;
SELECT COUNT(*) AS rows_with_issues
FROM cities_duplicate
WHERE city_id IS NULL
OR city_name IS NULL OR TRIM(city_name) = ''
OR telecom_circle_name IS NULL OR TRIM(telecom_circle_name) = ''
OR region_name IS NULL OR TRIM(region_name) = ''
OR city_tier IS NULL OR TRIM(city_tier) = ''
OR urban_rural_flag IS NULL OR TRIM(urban_rural_flag) = '';

--- Verification for customer_status_duplicate ---
SELECT * FROM customer_status_duplicate;
SELECT COUNT(*) AS rows_with_issues
FROM customer_status_duplicate
WHERE status_date_key IS NULL
OR customer_id IS NULL OR TRIM(customer_id) = ''
OR customer_status IS NULL OR TRIM(customer_status) = ''
OR churn_reason IS NULL OR TRIM(churn_reason) = ''
OR competitor_name IS NULL OR TRIM(competitor_name) = '';

--- Verification for customers_duplicate ---
SELECT * FROM customers_duplicate;
SELECT COUNT(*) AS rows_with_issues
FROM customers_duplicate
WHERE customer_id IS NULL OR TRIM(customer_id) = ''
OR customer_age IS NULL
OR customer_gender IS NULL OR TRIM(customer_gender) = ''
OR city_id IS NULL
OR activation_date IS NULL 
OR customer_type IS NULL OR TRIM(customer_type) = ''
OR user_segment IS NULL OR TRIM(user_segment) = ''
OR kyc_status IS NULL OR TRIM(kyc_status) = ''
OR sim_type IS NULL OR TRIM(sim_type) = '';

--- Verification for daily_usage_duplicate ---
SELECT * FROM daily_usage_duplicate1;
SELECT COUNT(*) AS rows_with_issues
FROM daily_usage_duplicate1
WHERE date_key IS NULL
OR customer_id IS NULL OR TRIM(customer_id) = ''
OR plan_id IS NULL
OR data_allocated_mb IS NULL
OR data_carried_forward_mb IS NULL
OR data_consumed_mb IS NULL
OR voice_minutes_used IS NULL
OR sms_used IS NULL
OR network_type IS NULL OR TRIM(network_type) = ''
OR usage_source IS NULL OR TRIM(usage_source) = '';

--- Verification for date_duplicate ---
SELECT * FROM date_duplicate;
SELECT COUNT(*) AS rows_with_issues
FROM date_duplicate
WHERE date_key IS NULL 
OR date_value IS NULL 
OR year IS NULL 
OR month_number IS NULL
OR month_name IS NULL OR TRIM(month_name) = ''
OR quarter IS NULL
OR week_of_year IS NULL OR TRIM(week_of_year) = ''
OR day_of_week_number IS NULL
OR day_of_week_name IS NULL OR TRIM(day_of_week_name) = ''
OR is_weekend_flag IS NULL OR TRIM(is_weekend_flag) = '';


--- Verification for market_share_duplicate ---
SELECT * FROM market_share_duplicate;
SELECT COUNT(*) AS rows_with_issues
FROM market_share_duplicate
WHERE month IS NULL 
OR telecom_circle_name IS NULL OR TRIM(telecom_circle_name) = ''
OR operator_name IS NULL OR TRIM(operator_name) = ''
OR market_share_percentage IS NULL
OR active_subscribers IS NULL;

--- Verification for plan_duplicate ---
SELECT * FROM plan_duplicate;
SELECT COUNT(*) AS rows_with_issues
FROM plan_duplicate
WHERE plan_id IS NULL
OR plan_name IS NULL OR TRIM(plan_name) = ''
OR customer_type IS NULL OR TRIM(customer_type) = ''
OR plan_validity_days IS NULL
OR daily_data_limit_gb IS NULL
OR monthly_data_allowance_gb IS NULL
OR voice_unlimited_flag IS NULL OR TRIM(voice_unlimited_flag) = ''
OR rollover_allowed_flag IS NULL OR TRIM(rollover_allowed_flag) = ''
OR fair_usage_policy_limit_gb IS NULL
OR plan_category IS NULL OR TRIM(plan_category) = ''
OR plan_launch_date IS NULL 
OR plan_discontinued_date IS NULL;

--- Verification for plan_revenue_duplicate ---
SELECT * FROM plan_revenue_duplicate;
SELECT COUNT(*) AS rows_with_issues
FROM plan_revenue_duplicate
WHERE billing_id IS NULL OR TRIM(billing_id) = ''
OR billing_month IS NULL 
OR customer_id IS NULL OR TRIM(customer_id) = ''
OR plan_id IS NULL 
OR billed_amount_inr IS NULL
OR discount_applied_inr IS NULL
OR late_fee_inr IS NULL
OR refund_amount_inr IS NULL
OR net_revenue_inr IS NULL
OR billing_status IS NULL OR TRIM(billing_status) = '';


---UPDATING DATE COLUMNS---

ALTER plan_revenue_duplicate
MODIFY billing_month DATE;

UPDATE plan_revenue_duplicate
SET billing_month = STR_TO_DATE(CONCAT(billing_month, '-01'), '%Y-%m-%d');

ALTER TABLE date
MODIFY date_value DATE;

UPDATE date
SET date_value = STR_TO_DATE(date_value, '%d-%m-%Y');

ALTER TABLE date
MODIFY date_value DATE;

