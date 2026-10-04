📊 Customer Churn & Retention Analytics
Tools: SQL · Python (Pandas, Matplotlib, Seaborn) · Power BI

A complete churn‑retention case study analysing 7,043 customers from the public Telco Customer Churn dataset.
This project identifies where subscription revenue is being lost, which customer groups are most vulnerable, and which active customers resemble churned ones — enabling targeted retention strategies.

🖼️ Dashboard Preview
Executive Overview
<img width="100%" alt="Churn Dashboard" src="https://github.com/user-attachments/assets/6d8965a2-dd82-421f-9977-9cb19cb59053" />

Customer Risk Profiler
<img width="100%" alt="Risk Profiler" src="https://github.com/user-attachments/assets/b0211f86-98b7-4fc3-967c-83ea6b6d52bf" />

🧭 Executive Summary
Subscription businesses lose significant recurring revenue when customers churn.
This analysis quantifies churn impact, identifies high‑risk segments, and recommends targeted actions to reduce churn and protect monthly recurring revenue (MRR).
The workflow combines SQL for data cleaning and segmentation, Python for exploratory analysis, and Power BI for executive‑level dashboards.

❓ Business Questions
When and where do customers cancel?
Which customer groups and revenue segments are most vulnerable to churn?
Which active customers resemble churned customers?
How much monthly recurring revenue can be protected through targeted retention?

🔍 Key Findings
Overall churn is 26.5% — roughly 1 in 4 customers.
$139.1K of $456.1K monthly recurring revenue (30.5%) is lost due to churn.
Contract type is the strongest churn driver:
Month‑to‑month churn: ~43%
One‑year churn: ~11%
Two‑year churn: ~3%
Electronic‑check customers account for 60.6% of lost revenue ($84.3K).
Early‑tenure churn is high: Month‑to‑month customers in their first 12 months churn at X% (insert SQL result).
Customers lacking tech support or online security churn at significantly higher rates.

🎯 Recommendations
1. Convert month‑to‑month customers to longer contracts
Reduces churn risk from 43% → 11%.
Target customers in tenure 0–12 months with upgrade incentives.

2. Prioritise electronic‑check customers for retention
They represent 60.6% of lost revenue.
Introduce secure digital payment options and personalised outreach.

3. Improve onboarding for new customers (tenure < 12 months)
Early churn is behaviour‑driven: unclear billing, service issues, unmet expectations.
Provide proactive support in the first 90 days.

4. Bundle tech support & online security for high‑risk segments
Customers without these services churn at higher rates.
Offer discounted add‑on packages to reduce dissatisfaction.

🛠️ Approach
1. SQL Data Cleaning (sql/01_data_cleaning.sql)
Standardised column names
Trimmed and cast TotalCharges
Created binary churn flag
Built tenure buckets
Raw data remains untouched; all transformations are in SQL views

2. Cohort & Contract Analysis (sql/02_cohort_analysis.sql)
Churn rate by tenure group
Lost monthly revenue by contract type
Churn by internet service, tech support, and online security combinations

3. Customer Segmentation (sql/03_customer_segmentation.sql)
Segments customers by contract type, tenure, and monthly spend.
Example segment outputs (replace with your actual results):
Segment A: High‑value, low‑tenure, high churn risk
Segment B: Mid‑value, stable customers
Segment C: Low‑value, low churn risk

4. Python EDA (python/exploratory_data_analysis.py)
Overall churn rate
Tenure distribution (retained vs churned)
Churn by contract type
Monthly charges by churn status
Visualisations for exploratory insights

5. Power BI Dashboard (dashboards/)
Two‑page interactive dashboard:
Executive Overview: churn rate, lost vs active revenue, churn by contract, lost revenue by payment method
Customer Risk Profiler: segment‑level churn risk, high‑value at‑risk customers, tenure distribution

📁 Repository Structure
Code
README.md
Telco-Customer-Churn.csv         raw dataset
sql/
  01_data_cleaning.sql
  02_cohort_analysis.sql
  03_customer_segmentation.sql
python/
  exploratory_data_analysis.py
dashboards/                      Power BI file and screenshots
▶️ How to Run
Import Telco-Customer-Churn.csv into a SQL table named raw_customer_data.

Run the SQL scripts in order (01 → 02 → 03).
Install Python libraries: pandas, numpy, matplotlib, seaborn.
Run exploratory_data_analysis.py.
Open the Power BI file in dashboards/.

📝 Dataset Notes & Limitations
One row per customer; no sign‑up or purchase dates.
True RFM analysis and calendar‑month cohorts are not possible; tenure buckets are used instead.
Monthly recurring revenue (MRR) = sum of MonthlyCharges.
Lost revenue = monthly charges of churned customers.
Churn drivers are associations, not proven causal factors.

Eleven customers with tenure 0 have blank TotalCharges; SQL keeps them as NULL, Python fills them with 0.
This is a public sample dataset, not real company data.
