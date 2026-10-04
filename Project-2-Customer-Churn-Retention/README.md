# Customer Churn & Retention Analytics

**Tools:** SQL · Python (Pandas, Matplotlib, Seaborn) · Power BI

A portfolio case study using the public Telco Customer Churn dataset (https://www.kaggle.com/datasets/akimthaav/telecommunication-customer-churn): 7,043 customers, 21 columns, one row per customer. It asks where a subscription business is losing customers and how much revenue that costs.

## Business questions
1. When and where do customers cancel?
2. Which customer groups and revenue segments are most vulnerable to churn?
3. Which high-value customers are still active but look like the ones who left?

## Key findings
- **Overall churn is 26.5%** (about 1 in 4 of the 7,043 customers).
- **$139.1K of $456.1K monthly recurring revenue (30.5%) is lost to churned customers.** Active customers bring in $317.0K a month.
- **Contract type matters most:** month-to-month customers churn at about 43%, against about 11% on one-year and about 3% on two-year contracts.
- **Electronic-check payers account for 60.6% of lost revenue** ($84.3K), well ahead of bank transfer, credit card and mailed check.
- Month-to-month customers in their first 12 months churn at [X%]: [run the query in the SQL section below and add the number].

## Recommendations
[Add 2 or 3 recommendations, each tied to a number above. For example: how you would encourage month-to-month customers to move to longer contracts, and what you would do about the electronic-check group.]

## Approach
1. **SQL cleaning** (`sql/01_data_cleaning.sql`): a view with standardised column names, trimmed and cast `TotalCharges`, a binary churn flag and tenure buckets. The raw data is never modified.
2. **Tenure and contract analysis** (`sql/02_cohort_analysis.sql`): churn rate and lost monthly revenue by tenure group and contract type, plus churn by combination of internet service, tech support and online security.
3. **Customer segmentation** (`sql/03_customer_segmentation.sql`): groups customers by contract type, tenure and monthly spend to find high-value customers at risk. [Add the segment results here after running the script.]
4. **Python EDA** (`python/exploratory_data_analysis.py`): overall churn rate, tenure distribution for retained vs churned customers, churn by contract type, and monthly charges by churn status.
5. **Power BI dashboard** (`dashboards/`): an executive overview page (churn rate, lost and active revenue, churn by contract, lost revenue by payment method) and a customer risk profiler page.

## Dataset notes and limitations
- The dataset has one row per customer, with tenure in months and monthly charges but **no purchase dates or sign-up dates**. That means true RFM (recency, frequency, monetary) analysis and calendar-month cohorts are not possible, so I used tenure groups and spend tiers instead.
- Monthly recurring revenue here means the sum of `MonthlyCharges`. Lost revenue is the monthly charge of customers who churned.
- Churn drivers shown are associations, not proven causes.
- Eleven customers with tenure 0 have a blank `TotalCharges`. The SQL view keeps these as NULL, and the Python script fills them with 0 (monthly charges × tenure).
- This is a public sample dataset, not data from a real company.

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

## How to run
1. Import `Telco-Customer-Churn.csv` into a SQL table called `raw_customer_data`, then run the SQL files in order.
2. For Python, install pandas, numpy, matplotlib and seaborn, then run `exploratory_data_analysis.py` from the `python` folder.
3. Open the Power BI file in `dashboards/`.

## Check the first-12-months figure
<img width="1461" height="860" alt="image" src="https://github.com/user-attachments/assets/6d8965a2-dd82-421f-9977-9cb19cb59053" />

<img width="1460" height="884" alt="image" src="https://github.com/user-attachments/assets/b0211f86-98b7-4fc3-967c-83ea6b6d52bf" />

