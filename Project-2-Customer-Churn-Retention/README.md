\# Executive Customer Retention \& Churn Analytics



\[!\[Domain: Customer Analytics](https://img.shields.io/badge/Domain-Customer\_Analytics-blue.svg)](#)

\[!\[Tools: SQL | Power BI | Python](https://img.shields.io/badge/Tools-SQL\_%7C\_Power\_BI\_%7C\_Python-orange.svg)](#)

\[!\[Methodology: Cohort \& RFM Analysis](https://img.shields.io/badge/Methodology-Cohort\_%26\_RFM\_Analysis-green.svg)](#)



\## 📌 Executive Summary

This project provides an end-to-end analytical framework to diagnose customer attrition, model subscriber retention cohorts, and quantify monthly recurring revenue (MRR) at risk for a subscription service provider. 



By analyzing over 7,000 customer accounts using \*\*PostgreSQL\*\*, \*\*Power BI\*\*, and \*\*RFM (Recency, Frequency, Monetary) segmentation\*\*, this project identified that \*\*42.7% of month-to-month subscribers churn within their first 12 months\*\*, contributing to \*\*$14.2K in lost monthly recurring revenue\*\*. The findings led to three high-impact retention strategies targeted at high-value at-risk customer segments.



\---



\## 🎯 Business Problem & Objectives

High customer acquisition costs (CAC) make customer retention the primary driver of subscription profitability. Leadership lacked visibility into:

1\. \*\*When and why\*\* customers cancel their subscriptions.

2\. \*\*Which revenue segments\*\* are most vulnerable to churn.

3\. \*\*Who\*\* the high-value at-risk customers are so Customer Success teams can intervene proactively.



\*\*Core Objectives:\*\*

\* Clean and transform raw unstructured customer records into normalized analytics-ready SQL views.

\* Model customer tenure into cohort grids to calculate drop-off velocity.

\* Build an RFM segmentation script to isolate high-value accounts at immediate risk of churn.

\* Deliver an interactive 2-page executive Power BI dashboard for strategy and operations.



\---



\## 🛠 Tech Stack \& Tools

\* \*\*SQL (PostgreSQL / MySQL):\*\* Common Table Expressions (CTEs), Window Functions (`NTILE`, `RANK`), Aggregate Functions, View Creation, Data Cleaning.

\* \*\*Power BI / DAX:\*\* Custom calculated columns, dynamic measures, field parameters, matrix visual hierarchies, visual interactivity.

\* \*\*Python (Pandas, Seaborn, Matplotlib):\*\* Exploratory Data Analysis (EDA) and distribution testing.

\* \*\*Git / GitHub:\*\* Version control and portfolio documentation.



\---



\## 📂 Repository Structure



```text

Project-2-Customer-Churn-Retention/

├── README.md

├── data/

│   ├── raw\_customer\_data.csv

│   └── cleaned\_customer\_data.csv

├── sql/

│   ├── 01\_data\_cleaning.sql

│   ├── 02\_cohort\_analysis.sql

│   └── 03\_rfm\_segmentation.sql

├── python/

│   └── exploratory\_data\_analysis.ipynb

└── dashboards/

&#x20;   ├── customer\_churn\_dashboard.pbix

&#x20;   └── screenshots/

&#x20;       ├── 01\_executive\_summary.png

&#x20;       └── 02\_customer\_risk\_profiler.png

