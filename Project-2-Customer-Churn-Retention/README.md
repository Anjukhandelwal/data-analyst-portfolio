  📊 Customer Churn & Retention Analytics
Tools: SQL · Python (Pandas, Matplotlib, Seaborn) · Power BI

A complete churn‑retention case study analysing 7,043 customers from the public Telco Customer Churn dataset.
This project identifies where subscription revenue is being lost, which customer groups are most vulnerable, and which active customers resemble churned ones — enabling targeted retention strategies.

🖼️ Dashboard Preview
Executive Overview
<img width="100%" alt="Churn Dashboard" src="https://github.com/user-attachments/assets/6d8965a2-dd82-421f-9977-9cb19cb59053" />

Customer Risk Profiler
<img width="100%" alt="Risk Profiler" src="https://github.com/user-attachments/assets/b0211f86-98b7-4fc3-967c-83ea6b6d52bf" />

🧭 Executive Summary<br>
    The Subscription businesses lose significant recurring revenue when customers churn.<br>
    This analysis quantifies churn impact, identifies high‑risk segments, and recommends targeted actions to reduce churn and protect monthly recurring revenue (MRR).<br>
    The workflow combines SQL for data cleaning and segmentation, Python for exploratory analysis, and Power BI for executive‑level dashboards.<br>

❓ Business Questions<br>
    When and where do customers cancel?<br>
    Which customer groups and revenue segments are most vulnerable to churn?<br>
    Which active customers resemble churned customers?<br>
    How much monthly recurring revenue can be protected through targeted retention?<br>

🔍 Key Findings
    Overall churn is 26.5% — roughly 1 in 4 customers.<br>
    $139.1K of $456.1K monthly recurring revenue (30.5%) is lost due to churn.<br>
    Contract type is the strongest churn driver:<br>
      Month‑to‑month churn: ~43%<br>
      One‑year churn: ~11%<br>
      Two‑year churn: ~3%<br>
    Electronic‑check customers account for 60.6% of lost revenue ($84.3K).<br>
    Early‑tenure churn is high: Month‑to‑month customers in their first 12 months churn at X% (insert SQL result).<br>
    Customers lacking tech support or online security churn at significantly higher rates.<br>

🎯 Recommendations
1. Convert month‑to‑month customers to longer contracts<br>
      Reduces churn risk from 43% → 11%.<br>
      Target customers in tenure 0–12 months with upgrade incentives.<br>

2. Prioritise electronic‑check customers for retention<br>
    They represent 60.6% of lost revenue.<br>
    Introduce secure digital payment options and personalised outreach.<br>

3. Improve onboarding for new customers (tenure < 12 months)<br>
    Early churn is behaviour‑driven: unclear billing, service issues, unmet expectations.<br>
    Provide proactive support in the first 90 days.<br>

4. Bundle tech support & online security for high‑risk segments<br>
    Customers without these services churn at higher rates.<br>
    Offer discounted add‑on packages to reduce dissatisfaction.<br>

🛠️ Approach
1. SQL Data Cleaning (sql/01_data_cleaning.sql)
    Standardised column names<br>
    Trimmed and cast TotalCharges<br>
    Created binary churn flag<br>
    Built tenure buckets<br>
    Raw data remains untouched; all transformations are in SQL views<br>

2. Cohort & Contract Analysis (sql/02_cohort_analysis.sql)<br>
    Churn rate by tenure group<br>
    Lost monthly revenue by contract type<br>
    Churn by internet service, tech support, and online security combinations<br>

3. Customer Segmentation (sql/03_customer_segmentation.sql)<br>
    Segments customers by contract type, tenure, and monthly spend.<br>
    Example segment outputs :<br>
      Segment A: High‑value, low‑tenure, high churn risk<br>
      Segment B: Mid‑value, stable customers<br>
      Segment C: Low‑value, low churn risk<br>

4. Python EDA (python/exploratory_data_analysis.py)<br>
    Overall churn rate<br>
    Tenure distribution (retained vs churned)<br>
    Churn by contract type<br>
    Monthly charges by churn status<br>
    Visualisations for exploratory insights<br>
  
5. Power BI Dashboard (dashboards/)<br>
    Two‑page interactive dashboard:<br>
    Executive Overview: churn rate, lost vs active revenue, churn by contract, lost revenue by payment method<br>
    Customer Risk Profiler: segment‑level churn risk, high‑value at‑risk customers, tenure distribution<br>

## Repository contents
```
README.md
Telco-Customer-Churn.csv         raw dataset
sql/
  01_data_cleaning.sql
  02_cohort_analysis.sql
  03_customer_segmentation.sql
python/
  exploratory_data_analysis.py
dashboards/                      Power BI file and screenshots
```
▶️ How to Run<br>
    Import Telco-Customer-Churn.csv into a SQL table named raw_customer_data.
    Run the SQL scripts in order (01 → 02 → 03).<br>
    Install Python libraries: pandas, numpy, matplotlib, seaborn.<br>
    Run exploratory_data_analysis.py.<br>
    Open the Power BI file in dashboards/.<br>

📝 Dataset Notes & Limitations<br>
    One row per customer; no sign‑up or purchase dates.<br>
    True RFM analysis and calendar‑month cohorts are not possible; tenure buckets are used instead.<br>
    Monthly recurring revenue (MRR) = sum of MonthlyCharges.<br>
    Lost revenue = monthly charges of churned customers.<br>
    Churn drivers are associations, not proven causal factors.<br>
    Eleven customers with tenure 0 have blank TotalCharges; SQL keeps them as NULL, Python fills them with 0.<br>
    
    
    This is a public sample dataset, not real company data.<br>
