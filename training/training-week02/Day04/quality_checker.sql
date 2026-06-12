/*
=========================================================
PIPELINE QUALITY CHECKER (FINAL - FULL OBSERVABILITY)
=========================================================

Each check has TWO outputs:
1. DETAIL QUERY → actual bad rows
2. SUMMARY QUERY → count of issues

Tables:
- sales
- products
- sales_reps

=========================================================
*/


/*
=========================================================
1. DUPLICATE DETECTION
=========================================================
*/

/* DETAIL: actual duplicate rows */
SELECT *
FROM sales
WHERE (product_id, sale_date, sales_rep_id) IN (
    SELECT product_id, sale_date, sales_rep_id
    FROM sales
    GROUP BY product_id, sale_date, sales_rep_id
    HAVING COUNT(*) > 1
);

/* SUMMARY: number of duplicate groups */
SELECT COUNT(*) AS duplicate_issue_count
FROM (
    SELECT product_id, sale_date, sales_rep_id
    FROM sales
    GROUP BY product_id, sale_date, sales_rep_id
    HAVING COUNT(*) > 1
) d;



/*
=========================================================
2. NULL VALUE CHECK
=========================================================
*/

/* DETAIL: rows containing nulls */
SELECT *
FROM sales
WHERE product_id IS NULL
   OR sale_date IS NULL
   OR sales_rep_id IS NULL
   OR sales_amount IS NULL
   OR quantity_sold IS NULL;

/* SUMMARY: total null occurrences */
SELECT
    SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) +
    SUM(CASE WHEN sale_date IS NULL THEN 1 ELSE 0 END) +
    SUM(CASE WHEN sales_rep_id IS NULL THEN 1 ELSE 0 END) +
    SUM(CASE WHEN sales_amount IS NULL THEN 1 ELSE 0 END) +
    SUM(CASE WHEN quantity_sold IS NULL THEN 1 ELSE 0 END)
    AS null_issue_count
FROM sales;



/*
=========================================================
3. REFERENTIAL INTEGRITY CHECK
=========================================================
*/

/* DETAIL: orphan product_ids */
SELECT s.*
FROM sales s
LEFT JOIN products p
    ON s.product_id = p.product_id
WHERE p.product_id IS NULL;

/* DETAIL: orphan sales_rep_id */
SELECT s.*
FROM sales s
LEFT JOIN sales_reps r
    ON s.sales_rep_id = r.sales_rep_id
WHERE r.sales_rep_id IS NULL;

/* SUMMARY: total orphan rows */
SELECT COUNT(*) AS referential_issue_count
FROM (
    SELECT s.product_id
    FROM sales s
    LEFT JOIN products p
        ON s.product_id = p.product_id
    WHERE p.product_id IS NULL

    UNION ALL

    SELECT s.sales_rep_id
    FROM sales s
    LEFT JOIN sales_reps r
        ON s.sales_rep_id = r.sales_rep_id
    WHERE r.sales_rep_id IS NULL
) x;



/*
=========================================================
4. FRESHNESS CHECK
=========================================================
*/

/* DETAIL: stale rows (older than 3 days) */
SELECT *
FROM sales
WHERE sale_date < CURRENT_DATE - INTERVAL '3 days';

/* SUMMARY: freshness flag */
SELECT
    CASE
        WHEN MAX(sale_date) < CURRENT_DATE - INTERVAL '3 days'
        THEN 1 ELSE 0
    END AS freshness_issue
FROM sales;



/*
=========================================================
5. FINAL PIPELINE HEALTH DASHBOARD (CTE)
=========================================================
*/

WITH duplicate_check AS (
    SELECT COUNT(*) AS issue_count
    FROM (
        SELECT product_id, sale_date, sales_rep_id
        FROM sales
        GROUP BY product_id, sale_date, sales_rep_id
        HAVING COUNT(*) > 1
    ) d
),

null_check AS (
    SELECT
        SUM(
            CASE WHEN product_id IS NULL THEN 1 ELSE 0 END +
            CASE WHEN sale_date IS NULL THEN 1 ELSE 0 END +
            CASE WHEN sales_rep_id IS NULL THEN 1 ELSE 0 END +
            CASE WHEN sales_amount IS NULL THEN 1 ELSE 0 END +
            CASE WHEN quantity_sold IS NULL THEN 1 ELSE 0 END
        ) AS issue_count
    FROM sales
),

referential_check AS (
    SELECT COUNT(*) AS issue_count
    FROM (
        SELECT s.product_id
        FROM sales s
        LEFT JOIN products p
            ON s.product_id = p.product_id
        WHERE p.product_id IS NULL

        UNION ALL

        SELECT s.sales_rep_id
        FROM sales s
        LEFT JOIN sales_reps r
            ON s.sales_rep_id = r.sales_rep_id
        WHERE r.sales_rep_id IS NULL
    ) x
),

freshness_check AS (
    SELECT
        CASE
            WHEN MAX(sale_date) < CURRENT_DATE - INTERVAL '3 days'
            THEN 1 ELSE 0
        END AS issue_count
    FROM sales
)

SELECT 'Duplicate Issues' AS check_name, issue_count FROM duplicate_check
UNION ALL
SELECT 'Null Issues', issue_count FROM null_check
UNION ALL
SELECT 'Referential Issues', issue_count FROM referential_check
UNION ALL
SELECT 'Freshness Issue', issue_count FROM freshness_check;