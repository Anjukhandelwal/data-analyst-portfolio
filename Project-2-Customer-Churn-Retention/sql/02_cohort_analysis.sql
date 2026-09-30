-- =============================================================================
-- Project: Customer Retention & Churn Analytics
-- File: 02_cohort_analysis.sql
-- Description: Tenure cohort analysis, churn rate calculation, and MRR loss.
-- =============================================================================

-- 1. Churn and Lost Recurring Revenue by Tenure Cohort & Contract Type
SELECT 
    tenure_cohort,
    contract_type,
    COUNT(customer_id) AS total_customers,
    SUM(is_churned) AS churned_customers,
    
    -- Churn Rate %
    ROUND(100.0 * SUM(is_churned) / COUNT(customer_id), 2) AS churn_rate_pct,
    
    -- Retention Rate %
    ROUND(100.0 * (1 - (SUM(is_churned) * 1.0 / COUNT(customer_id))), 2) AS retention_rate_pct,
    
    -- Financial Risk Metrics
    ROUND(SUM(monthly_charges), 2) AS total_mrr,
    ROUND(SUM(CASE WHEN is_churned = 1 THEN monthly_charges ELSE 0 END), 2) AS mrr_lost_to_churn,
    ROUND(AVG(monthly_charges), 2) AS avg_monthly_spend

FROM vw_cleaned_customer_data
GROUP BY tenure_cohort, contract_type
ORDER BY tenure_cohort ASC, mrr_lost_to_churn DESC;

-- 2. Service Combination Churn Breakdown
-- Highlighting which add-on services correlate with higher retention
SELECT 
    internet_service,
    tech_support,
    online_security,
    COUNT(customer_id) AS total_customers,
    SUM(is_churned) AS churned_customers,
    ROUND(100.0 * SUM(is_churned) / COUNT(customer_id), 2) AS churn_rate_pct
FROM vw_cleaned_customer_data
GROUP BY internet_service, tech_support, online_security
ORDER BY churned_customers DESC;