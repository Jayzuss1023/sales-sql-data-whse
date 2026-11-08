
-- Check For Duplicates In Join
SELECT
    cst_id,
    COUNT(*) AS duplicate_count
FROM (
    SELECT
        ci.cst_id,
        ci.cst_key,
        ci.cst_firstname,
        ci.cst_lastname,
        ci.cst_marital_status,
        ci.cst_gndr,
        ca.bdate,
        ca.gen,
        la.cntry
    FROM silver.crm_cust_info ci
    LEFT JOIN silver.erp_cust_az12 ca
        ON ci.cst_key = ca.cid
    LEFT JOIN silver.erp_loc_a101 la
        ON ci.cst_key = la.cid
) t
GROUP BY cst_id
HAVING COUNT(*) > 1;

SELECT DISTINCT
    ci.cst_gndr,
    ca.gen
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_loc_a101 la
ON ci.cst_key = la.cid
LEFT JOIN silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid
ORDER BY 1,2