USE DataWarehouse;


-- Check for NULLS or Duplicates in Primary Key
SELECT 
    cst_id,
    COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- SELECT
-- *
-- FROM bronze.crm_cust_info
-- WHERE cst_id = '29449'

-- ===============================
-- Checking 'silver.crm_prd_info'
-- ===============================

-- Check for NULLS or Duplicates in Primary Keys
-- Expect: No Results
SELECT
    prd_id,
    COUNT(*)
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

SELECT DISTINCT
    prd_line
FROM bronze.crm_prd_info;

-- Check unwanted spaces
SELECT
    prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- Check for NULLS or Negative Values in COST
SELECT
    prd_cost
FROM silver.crm_prd_info
WHERE prd_cost IS NULL OR prd_cost < 0;


-- Check invalid date orders. Must follow: Start Date > End Date
-- Excpet: No Results
SELECT
    *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

-- Data Standardization & Consistency
SELECT DISTINCT
    prd_line
FROM silver.crm_prd_info;

-- ====================================================================
-- Checking 'silver.crm_sales_details'
-- ====================================================================

-- Check for Invalid Dates
SELECT
    *
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0
OR LEN(sls_order_dt) != 8;

-- Check Data Consistency: Sales = Quantity * Price
SELECT DISTINCT
    sls_prd_key,
    sls_sales,
    sls_quantity,
    sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_price * sls_quantity
    OR sls_sales IS NULL
    OR sls_quantity IS NULL
    OR sls_price IS NULL
    OR sls_sales <= 0
    OR sls_quantity <= 0
    OR sls_price <= 0
ORDER BY sls_prd_key, sls_sales, sls_quantity, sls_price;

