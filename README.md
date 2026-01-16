# TeleNova Communications

## Executive Summary

TeleNova Communications is facing **ARPU stagnation**, **increasing churn**, and **inefficient plan performance** despite steady subscriber growth. This project analyses **revenue**, **data usage**, **market share**, and **churn behaviour** using cleaned telecom datasets. SQL-driven analysis was performed to identify **high-value circles**, **underutilised plans**, **revenue leakage**, and **competitor-driven churn**, enabling data-backed strategic decisions.

## Business Problem 

The telecom company is facing challenges in:

1. Identifying **high-value circles** and **low-performing regions**
2. Understanding **revenue loss due to churn**
3. Detecting **plans with poor utilisation or weak monetisation**
4. Analysing **customer segments** that generate revenue but under-utilise services
5. Evaluating **long-term operational sustainability** of data-heavy plans

The absence of consolidated insights makes it difficult for leadership teams to take **data-backed pricing**, **retention**, and **network investment decisions**.


## Dataset Used
This project uses an **unclean and unstructured telecom dataset** comprising **8 relational tables**, sourced as independent CSV files and later connected using SQL joins.
The dataset contains **298,694 rows** and **67 columns** in total (excluding the metrics reference table).

### Dataset Overview

| Dataset Name    | Description                                                                                           |
| --------------- | --------------------------------------------------------------------------------------------------    |
| cities          | Contains **telecom circle** and **city-level information** used for regional analysis                 |
| customer_status | Stores **customer lifecycle status** such as Active and Churned, along with **competitor details**    |
| customers       | Customer-level attributes including **customer type**, **user segment**, and demographics             |
| daily_usage     | High-volume table capturing **daily data consumption (MB)** per customer                              |
| date            | Calendar reference table used for **month and time-based joins**                                      |
| market_share    | Monthly **market share percentage** by telecom circle                                                 |
| metrics_list    | Defines **business metrics**, **calculation logic**, and **interpretation rules** used across queries |
| plan            | Plan metadata including **plan category**, **data allowance**, and pricing attributes                 |
| plan_revenue    | Revenue-focused table containing **net revenue (INR)**, **discounts**, and **refund amounts**         |


## Key Results & Insights

1. Certain **telecom circles generate high ARPU** despite having lower subscriber counts, indicating a concentration of premium users.
2. Multiple plans exhibit **low data utilisation ratios**, highlighting over-provisioned data allowances.
3. Some customer segments contribute **high revenue with minimal data usage**, making them strong candidates for monetisation optimisation.
4. **Churn rates vary significantly across telecom circles**, reflecting uneven regional competition pressure.
5. A small number of competitors account for **revenue-weighted churn**, indicating higher financial impact beyond customer volume alone.
6. Several plans show **high subscriber volume but weak ARPU**, negatively affecting overall profitability.
7. Discounts and refunds result in **significant revenue leakage** for specific customer types.


## Results & Business Recommendations

1. Reprice or redesign **low-utilisation plans** to reduce cost pressure
2. Introduce **circle-specific pricing strategies** for high-ARPU regions
3. Launch **retention offers** for high-revenue, low-usage customer segments
4. Strengthen **competitive response strategies** in circles with high churn
5. Tighten **discount and refund governance** to control revenue leakage
6. Sunset or restructure **operationally unsustainable plans**

# Next Steps

1. Add **time-based trend analysis** for ARPU, churn, and usage
2. Integrate insights into **Power BI dashboards** for leadership reporting
3. Expand analysis to include **network cost and infrastructure data**
