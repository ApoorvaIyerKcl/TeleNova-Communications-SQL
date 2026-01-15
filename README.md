# TeleNova Communications

## [Table Of Contents]
[Executive Summary]
[Problem Statement]
[Dataset Used]
[Business Objectives]
[Key Results & Insights]
[Business Recommendations]
[Next Steps]


# Executive Summary

TeleNova Communications is facing **ARPU stagnation**, **increasing churn**, and **inefficient plan performance** despite steady subscriber growth. This project analyses **revenue**, **data usage**, **market share**, and **churn behaviour** using cleaned telecom datasets. SQL-driven analysis was performed to identify **high-value circles**, **underutilised plans**, **revenue leakage**, and **competitor-driven churn**, enabling data-backed strategic decisions.


# Problem Statement

Despite having millions of active subscribers, TeleNova struggles with:

1. **Uneven ARPU across telecom circles**
2. **Plans with low data utilisation but high operational cost**
3. **High-revenue customers churning to competitors**
4. **Revenue leakage due to discounts and refunds**

The business lacks a **centralised, data-driven view** to understand where revenue is generated, lost, or under-optimised.

# Dataset Used

Below is a **GitHub-ready README backstory** written cleanly, formally, and in a **data-analyst style**, exactly aligned with your solved SQL questions and metrics.

No emojis.
All section titles use `# ` format.
All **keywords** are highlighted using `**word**`.
Written so you can directly paste this into **GitHub README.md**.

---

# Telecom Revenue, Usage, and Churn Analysis Project

## [Table of Contents]

* Executive Summary
* Problem Statement
* Dataset Used
* Business Objective
* Key Results and Insights
* Business Recommendations
* Next Steps

---

# Executive Summary

This project focuses on analysing a large-scale **telecom customer dataset** to understand **revenue performance**, **data usage behaviour**, **churn patterns**, and **plan sustainability** across different **telecom circles**, **customer segments**, and **pricing plans**.

Using **Structured Query Language (SQL)**, the analysis answers strategic business questions related to **Average Revenue Per User (ARPU)**, **market share gaps**, **revenue leakage**, and **competitor-driven churn**. The dataset was intentionally **unclean and unstructured**, allowing realistic practice of **data cleaning**, **business logic building**, and **metric-driven analysis**.


# Business Problem 

The telecom company is facing challenges in:

1. Identifying **high-value circles** and **low-performing regions**
2. Understanding **revenue loss due to churn**
3. Detecting **plans with poor utilisation or weak monetisation**
4. Analysing **customer segments** that generate revenue but under-utilise services
5. Evaluating **long-term operational sustainability** of data-heavy plans

The absence of consolidated insights makes it difficult for leadership teams to take **data-backed pricing**, **retention**, and **network investment decisions**.


# Dataset Used
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


# Business Objectives

* Identify **telecom circles with highest and lowest ARPU**
* Detect **plans with poor utilisation efficiency**
* Understand **high-revenue but low-usage customer segments**
* Measure **churn rate at circle and competitor level**
* Quantify **revenue leakage due to discounts and refunds**
* Flag **operationally unsustainable plans**


# Key Results & Insights

* Certain **telecom circles generate high ARPU** despite lower subscriber counts, indicating premium user concentration
* Multiple plans show **low data utilisation ratios**, suggesting over-provisioning
* Some customer segments contribute **high revenue with minimal data usage**, ideal for monetisation optimisation
* **Churn rates vary significantly by circle**, pointing to regional competition pressure
* A few competitors account for **revenue-weighted churn**, not just customer volume
* Specific plans have **high subscriber volume but weak ARPU**, hurting profitability
* Discounts and refunds create **significant revenue leakage** in select customer types


# Results & Business Recommendations

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
