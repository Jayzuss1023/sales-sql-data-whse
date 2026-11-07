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


-- Check invalid date orders. Must follow: Start Date > End Date
-- Excpet: No Results
SELECT
    *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;