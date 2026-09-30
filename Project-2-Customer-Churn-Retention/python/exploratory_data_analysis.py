"""
=============================================================================
Project: Customer Retention & Churn Analytics
File: exploratory_data_analysis.py
Description: Python EDA for missing values, tenure distributions, & churn correlations.
=============================================================================
"""

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

# Set visual styling
sns.set_theme(style="whitegrid")
plt.rcParams["figure.figsize"] = (10, 6)

# 1. Load Data
# Replace path with your local dataset path
df = pd.read_csv('../data/raw_customer_data.csv')

print("--- DATASET OVERVIEW ---")
print(f"Total Rows: {df.shape[0]}, Total Columns: {df.shape[1]}\n")
print(df.info())
print("\n--- FIRST 5 ROWS ---")
print(df.head())

# 2. Data Cleaning & Type Formatting
# Clean TotalCharges space values and cast to float
df['TotalCharges'] = pd.to_numeric(df['TotalCharges'].replace(' ', np.nan), errors='coerce')
df['TotalCharges'].fillna(df['MonthlyCharges'] * df['tenure'], inplace=True)

# Encode Churn into binary numeric target
df['Churn_Numeric'] = df['Churn'].apply(lambda x: 1 if x == 'Yes' else 0)

# 3. Overall Churn Rate Baseline
overall_churn_rate = df['Churn_Numeric'].mean() * 100
print(f"\nOverall Customer Churn Rate: {overall_churn_rate:.2f}%")

# 4. Tenure vs. Churn Rate Distribution Analysis
plt.figure(figsize=(12, 5))
sns.kdeplot(data=df, x='tenure', hue='Churn', common_norm=False, fill=True, palette=['#2b5c8f', '#d9534f'])
plt.title('Tenure Distribution Density: Retained vs Churned Customers', fontsize=14, fontweight='bold')
plt.xlabel('Tenure (Months)')
plt.ylabel('Density')
plt.tight_layout()
plt.savefig('../dashboards/screenshots/tenure_density_distribution.png')
plt.show()

# 5. Contract Type Impact Analysis
contract_churn = df.groupby('Contract')['Churn_Numeric'].agg(['count', 'sum', 'mean']).reset_index()
contract_churn.columns = ['Contract Type', 'Total Customers', 'Churned Customers', 'Churn Rate']
contract_churn['Churn Rate'] = contract_churn['Churn Rate'] * 100

print("\n--- CHURN BY CONTRACT TYPE ---")
print(contract_churn.to_string(index=False))

plt.figure(figsize=(8, 5))
ax = sns.barplot(data=contract_churn, x='Contract Type', y='Churn Rate', palette='Blues_r')
plt.title('Churn Rate % by Contract Type', fontsize=14, fontweight='bold')
plt.ylabel('Churn Rate (%)')
for p in ax.patches:
    ax.annotate(f'{p.get_height():.1f}%', (p.get_x() + p.get_width() / 2., p.get_height()),
                ha='center', va='center', xytext=(0, 5), textcoords='offset points', fontweight='bold')
plt.tight_layout()
plt.savefig('../dashboards/screenshots/churn_by_contract.png')
plt.show()

# 6. Monthly Charges vs Churn Risk
plt.figure(figsize=(10, 5))
sns.boxplot(data=df, x='Churn', y='MonthlyCharges', palette=['#2b5c8f', '#d9534f'])
plt.title('Monthly Spend Distribution by Churn Status', fontsize=14, fontweight='bold')
plt.xlabel('Churn Status')
plt.ylabel('Monthly Charges ($)')
plt.tight_layout()
plt.savefig('../dashboards/screenshots/monthly_charges_boxplot.png')
plt.show()

print("\nEDA script execution complete. Visual plots saved to dashboards/screenshots/")