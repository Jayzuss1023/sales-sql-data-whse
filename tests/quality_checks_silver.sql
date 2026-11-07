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