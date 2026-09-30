-- =============================================================================
-- Project: Customer Retention & Churn Analytics
-- File: 03_rfm_segmentation.sql
-- Description: Recency, Frequency, & Monetary (RFM) scoring and customer risk profiling.
-- =============================================================================

-- Step 1: Base RFM Calculation (using Tenure as proxy for Frequency/Loyalty)
WITH rfm_base AS (
    SELECT 
        customer_id,
        tenure_months,
        monthly_charges,
        total_charges,
        is_churned,
        contract_type,
        
        -- Score proxies:
        -- Recency: Shorter tenure or month-to-month contracts equal higher recency risk
        tenure_months AS recency_days,
        tenure_months AS frequency_count,
        COALESCE(total_charges, monthly_charges * tenure_months) AS monetary_val
    FROM vw_cleaned_customer_data
),

-- Step 2: Quintile Scoring (1-5) using Window Functions
rfm_scores AS (
    SELECT 
        customer_id,
        is_churned,
        contract_type,
        monthly_charges,
        monetary_val,
        
        NTILE(5) OVER (ORDER BY recency_days ASC) AS r_score,
        NTILE(5) OVER (ORDER BY frequency_count ASC) AS f_score,
        NTILE(5) OVER (ORDER BY monetary_val ASC) AS m_score
    FROM rfm_base
),

-- Step 3: Segment Mapping
segmented_customers AS (
    SELECT 
        customer_id,
        is_churned,
        contract_type,
        monthly_charges,
        monetary_val,
        r_score, f_score, m_score,
        CASE 
            WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Champions'
            WHEN r_score >= 3 AND f_score >= 3 THEN 'Loyal Customers'
            WHEN r_score <= 2 AND f_score >= 3 AND m_score >= 4 THEN 'At Risk (High Value)'
            WHEN r_score <= 2 AND f_score <= 2 THEN 'Lost Accounts'
            ELSE 'Needs Attention'
        END AS rfm_segment
    FROM rfm_scores
)

-- Step 4: Executive Segment Summary
SELECT 
    rfm_segment,
    COUNT(customer_id) AS total_accounts,
    SUM(is_churned) AS churned_accounts,
    ROUND(100.0 * SUM(is_churned) / COUNT(customer_id), 2) AS segment_churn_rate_pct,
    ROUND(SUM(monthly_charges), 2) AS total_mrr_value,
    ROUND(SUM(CASE WHEN is_churned = 1 THEN monthly_charges ELSE 0 END), 2) AS mrr_at_risk
FROM segmented_customers
GROUP BY rfm_segment
ORDER BY mrr_at_risk DESC;