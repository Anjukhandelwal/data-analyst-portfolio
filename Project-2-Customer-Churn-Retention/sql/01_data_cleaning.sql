-- =============================================================================
-- Project: Customer Retention & Churn Analytics
-- File: 01_data_cleaning.sql
-- Description: Data cleaning, NULL handling, type casting, and feature staging.
-- Target Dataset: Telco Customer Churn Data
-- =============================================================================

-- 1. Create a cleaned staging table/view to avoid modifying raw data
CREATE OR REPLACE VIEW vw_cleaned_customer_data AS
SELECT
    -- Primary Identifiers
    CustomerID AS customer_id,
    
    -- Demographics
    Gender AS gender,
    SeniorCitizen AS is_senior_citizen,
    Partner AS has_partner,
    Dependents AS has_dependents,
    
    -- Account Information
    tenure AS tenure_months,
    Contract AS contract_type,
    PaperlessBilling AS paperless_billing,
    PaymentMethod AS payment_method,
    
    -- Financial Metrics (Handling potential space/empty string NULLs in TotalCharges)
    CAST(MonthlyCharges AS DECIMAL(10,2)) AS monthly_charges,
    CAST(
        NULLIF(TRIM(TotalCharges), '') AS DECIMAL(10,2)
    ) AS total_charges,
    
    -- Service Features
    PhoneService AS phone_service,
    MultipleLines AS multiple_lines,
    InternetService AS internet_service,
    OnlineSecurity AS online_security,
    OnlineBackup AS online_backup,
    DeviceProtection AS device_protection,
    TechSupport AS tech_support,
    StreamingTV AS streaming_tv,
    StreamingMovies AS streaming_movies,
    
    -- Target Variable
    CASE 
        WHEN Churn = 'Yes' THEN 1 
        ELSE 0 
    END AS is_churned,
    
    -- Engineered Tenure Buckets
    CASE 
        WHEN tenure <= 6 THEN '01. 0-6 Months'
        WHEN tenure <= 12 THEN '02. 6-12 Months'
        WHEN tenure <= 24 THEN '03. 1-2 Years'
        WHEN tenure <= 48 THEN '04. 2-4 Years'
        ELSE '05. 4+ Years'
    END AS tenure_cohort

FROM raw_customer_data
WHERE CustomerID IS NOT NULL;

-- Data Audit Query: Verify clean output and missing value counts
SELECT 
    COUNT(*) AS total_records,
    COUNT(customer_id) AS valid_ids,
    SUM(CASE WHEN total_charges IS NULL THEN 1 ELSE 0 END) AS missing_total_charges
FROM vw_cleaned_customer_data;