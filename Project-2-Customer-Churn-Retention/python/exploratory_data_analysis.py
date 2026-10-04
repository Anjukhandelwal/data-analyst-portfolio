"""
=============================================================================
Project: Customer Retention & Churn Analytics
File: exploratory_data_analysis.py
Description: Python EDA for missing values, tenure distributions, & churn correlations.
Run from the python/ folder:  py exploratory_data_analysis.py
Needs: pandas, numpy, matplotlib, seaborn
=============================================================================
"""

from pathlib import Path

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

# Set visual styling
sns.set_theme(style="whitegrid")
plt.rcParams["figure.figsize"] = (10, 6)

DATA_PATH = Path("../Telco-Customer-Churn.csv")
OUT_DIR = Path("../dashboards/screenshots")
OUT_DIR.mkdir(parents=True, exist_ok=True)

# 1. Load Data
df = pd.read_csv(DATA_PATH)

print("--- DATASET OVERVIEW ---")
print(f"Total Rows: {df.shape[0]}, Total Columns: {df.shape[1]}\n")
print(df.info())
print("\n--- FIRST 5 ROWS ---")
print(df.head())

# 2. Data Cleaning & Type Formatting
# TotalCharges has blank strings (customers with tenure 0). Convert to numeric,
# then fill the blanks with MonthlyCharges * tenure (which is 0 for these customers).
df["TotalCharges"] = pd.to_numeric(df["TotalCharges"].replace(" ", np.nan), errors="coerce")
df["TotalCharges"] = df["TotalCharges"].fillna(df["MonthlyCharges"] * df["tenure"])

# Encode Churn into binary numeric target
df["Churn_Numeric"] = df["Churn"].apply(lambda x: 1 if x == "Yes" else 0)

# 3. Overall Churn Rate and Revenue Baseline
overall_churn_rate = df["Churn_Numeric"].mean() * 100
lost_mrr = df.loc[df["Churn_Numeric"] == 1, "MonthlyCharges"].sum()
total_mrr = df["MonthlyCharges"].sum()
print(f"\nOverall Customer Churn Rate: {overall_churn_rate:.2f}%")
print(f"Monthly revenue lost to churn: ${lost_mrr:,.2f} of ${total_mrr:,.2f} ({100 * lost_mrr / total_mrr:.1f}%)")

# 4. Tenure vs. Churn Rate Distribution Analysis
plt.figure(figsize=(12, 5))
sns.kdeplot(data=df, x="tenure", hue="Churn", common_norm=False, fill=True, palette=["#2b5c8f", "#d9534f"])
plt.title("Tenure Distribution Density: Retained vs Churned Customers", fontsize=14, fontweight="bold")
plt.xlabel("Tenure (Months)")
plt.ylabel("Density")
plt.tight_layout()
plt.savefig(OUT_DIR / "tenure_density_distribution.png")
plt.show()

# 5. Contract Type Impact Analysis
contract_churn = df.groupby("Contract")["Churn_Numeric"].agg(["count", "sum", "mean"]).reset_index()
contract_churn.columns = ["Contract Type", "Total Customers", "Churned Customers", "Churn Rate"]
contract_churn["Churn Rate"] = contract_churn["Churn Rate"] * 100

print("\n--- CHURN BY CONTRACT TYPE ---")
print(contract_churn.to_string(index=False))

plt.figure(figsize=(8, 5))
ax = sns.barplot(data=contract_churn, x="Contract Type", y="Churn Rate",
                 hue="Contract Type", palette="Blues_r", legend=False)
plt.title("Churn Rate % by Contract Type", fontsize=14, fontweight="bold")
plt.ylabel("Churn Rate (%)")
for p in ax.patches:
    ax.annotate(f"{p.get_height():.1f}%", (p.get_x() + p.get_width() / 2., p.get_height()),
                ha="center", va="center", xytext=(0, 5), textcoords="offset points", fontweight="bold")
plt.tight_layout()
plt.savefig(OUT_DIR / "churn_by_contract.png")
plt.show()

# 6. Monthly Charges vs Churn Risk
plt.figure(figsize=(10, 5))
sns.boxplot(data=df, x="Churn", y="MonthlyCharges", hue="Churn",
            palette=["#2b5c8f", "#d9534f"], legend=False)
plt.title("Monthly Spend Distribution by Churn Status", fontsize=14, fontweight="bold")
plt.xlabel("Churn Status")
plt.ylabel("Monthly Charges ($)")
plt.tight_layout()
plt.savefig(OUT_DIR / "monthly_charges_boxplot.png")
plt.show()

print("\nEDA script execution complete. Visual plots saved to dashboards/screenshots/")
