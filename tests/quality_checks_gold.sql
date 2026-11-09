
-- ====================================================================
-- Checking 'gold.dim_customers'
-- ====================================================================
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


-- Comparing Gender info between erp_cust_az12 and crm_cust_info
SELECT DISTINCT
    ci.cst_gndr,
    ca.gen
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_loc_a101 la
ON ci.cst_key = la.cid
LEFT JOIN silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid
ORDER BY 1,2;

SELECT
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;


-- ====================================================================
-- Checking 'gold.dim_products'
-- ====================================================================
-- Check for Duplicates in JOIN
SELECT product_number, COUNT(*) FROM
(
SELECT
    ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key, -- Surrogate Key
    pn.prd_id           AS product_id,
    pn.prd_key          AS product_number,
    pn.prd_nm           AS product_name,
    pn.cat_id           AS category_id,
    pc.cat              AS category,
    pc.subcat           AS subcategory,
    pc.maintenance      AS maintenance,
    pn.prd_cost         AS cost,
    pn.prd_line         AS product_line,
    pn.prd_start_dt     AS start_date
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
    ON pn.cat_id = pc.id
WHERE pn.prd_end_dt IS NULL
)t GROUP BY product_number
HAVING COUNT(*) > 1;

SELECT
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'gold.fact_sales'
-- ====================================================================
-- Check Data Model connectivity between fact and dimensions
SELECT *
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON f.customer_key = c.customer_key
LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
WHERE p.product_key IS NULL OR c.customer_key IS NULL;