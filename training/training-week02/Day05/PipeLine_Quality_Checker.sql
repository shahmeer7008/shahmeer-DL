-- =============================================================================
-- pipeline_quality_checker.sql
-- =============================================================================
-- PURPOSE:
--   A single-file data quality harness for validating pipeline output across
--   all tables loaded into this project. Run this immediately after any
--   pipeline execution to surface silent failures before they reach downstream
--   consumers.
--
-- TABLES COVERED:
--   amazon_sale_report          (source: Amazon_Sale_Report_Clean.csv)
--   international_sales   (source: International_sale_Report.csv)
--   sale_report           (source: Sale_Report.csv)
--   may_2022_pricing      (source: May-2022.csv)
--   pl_march_2021         (source: P__L_March_2021.csv)
--   expense_items         (source: Expense_Items.csv)
--   expense_received      (source: Expense_Received.csv)
--   cloud_warehouse       (source: Cloud_Warehouse_Compersion_Chart.csv)
--
-- HOW TO RUN:
--   Compatible with PostgreSQL, DuckDB, BigQuery (minor dialect tweaks noted).
--   To run on raw CSVs in DuckDB without loading first, replace table names
--   with read_csv_auto('path/to/file.csv') in each CTE.
--
--   psql -f pipeline_quality_checker.sql
--   duckdb   < pipeline_quality_checker.sql
--
-- CHECKS INCLUDED:
--   1. Duplicate Detection
--   2. Null Audit
--   3. Referential Integrity
--   4. Freshness Check
--   5. Summary CTE (all 4 checks in one query)
-- =============================================================================


-- =============================================================================
-- CHECK 1: DUPLICATE DETECTION
-- =============================================================================
-- WHY A DE CARES:
--   Idempotency is a core pipeline contract. If a DAG re-triggers or a Kafka
--   consumer replays a partition, rows must not be inserted twice. Duplicates
--   silently inflate revenue figures, order counts, and aggregated KPIs. This
--   check identifies exact key-level duplicates so you catch double-loads
--   before they reach your BI layer.
-- =============================================================================

-- amazon_sale_report: order_id + sku is the natural grain (one line-item per order)
SELECT
    'amazon_sale_report'          AS table_name,
    order_id,
    sku,
    COUNT(*)                AS duplicate_count
FROM amazon_sale_report
GROUP BY order_id, sku
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

-- international_sales: (date, customer, sku, size) identifies a single shipment
SELECT
    'international_sales'   AS table_name,
    date,
    customer,
    sku,
    size,
    COUNT(*)                AS duplicate_count
FROM international_sales
GROUP BY date, customer, sku, size
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

-- sale_report: sku_code + color + size is the inventory grain
SELECT
    'sale_report'           AS table_name,
    sku_code,
    color,
    size,
    COUNT(*)                AS duplicate_count
FROM sale_report
GROUP BY sku_code, color, size
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

-- may_2022_pricing & pl_march_2021: sku is the unique product key
SELECT
    'may_2022_pricing'      AS table_name,
    sku,
    COUNT(*)                AS duplicate_count
FROM may_2022_pricing
GROUP BY sku
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

SELECT
    'pl_march_2021'         AS table_name,
    sku,
    COUNT(*)                AS duplicate_count
FROM pl_march_2021
GROUP BY sku
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

-- expense_received: (date, received_amount) — no surrogate key, both columns form the grain
SELECT
    'expense_received'      AS table_name,
    date,
    received_amount,
    COUNT(*)                AS duplicate_count
FROM expense_received
GROUP BY date, received_amount
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;


-- =============================================================================
-- CHECK 2: NULL AUDIT
-- =============================================================================
-- WHY A DE CARES:
--   A null in a key or metric column is a silent failure — the row loaded,
--   no error was raised, but the data is incomplete. A null order_id in
--   amazon_sale_report means you cannot join to fulfilment. A null amount means
--   revenue is understated. This audit gives a per-column null count across
--   all tables so you can set a threshold alert: if null_count > 0 on a
--   NOT NULL column, the pipeline is broken.
-- =============================================================================

-- amazon_sale_report null audit (high-value columns only — extend as needed)
SELECT
    'amazon_sale_report'  AS table_name,
    'order_id'      AS column_name,
    COUNT(*)        FILTER (WHERE order_id     IS NULL) AS null_count,
    COUNT(*)        AS total_rows
FROM amazon_sale_report
UNION ALL
SELECT 'amazon_sale_report', 'date',       COUNT(*) FILTER (WHERE date      IS NULL), COUNT(*) FROM amazon_sale_report
UNION ALL
SELECT 'amazon_sale_report', 'sku',        COUNT(*) FILTER (WHERE sku       IS NULL), COUNT(*) FROM amazon_sale_report
UNION ALL
SELECT 'amazon_sale_report', 'amount',     COUNT(*) FILTER (WHERE amount    IS NULL), COUNT(*) FROM amazon_sale_report
UNION ALL
SELECT 'amazon_sale_report', 'status',     COUNT(*) FILTER (WHERE status    IS NULL), COUNT(*) FROM amazon_sale_report
UNION ALL
SELECT 'amazon_sale_report', 'qty',        COUNT(*) FILTER (WHERE qty       IS NULL), COUNT(*) FROM amazon_sale_report

UNION ALL
-- international_sales
SELECT 'international_sales', 'date',       COUNT(*) FILTER (WHERE date      IS NULL), COUNT(*) FROM international_sales
UNION ALL
SELECT 'international_sales', 'customer',   COUNT(*) FILTER (WHERE customer  IS NULL), COUNT(*) FROM international_sales
UNION ALL
SELECT 'international_sales', 'sku',        COUNT(*) FILTER (WHERE sku       IS NULL), COUNT(*) FROM international_sales
UNION ALL
SELECT 'international_sales', 'gross_amt',  COUNT(*) FILTER (WHERE gross_amt IS NULL), COUNT(*) FROM international_sales

UNION ALL
-- sale_report
SELECT 'sale_report', 'sku_code',  COUNT(*) FILTER (WHERE sku_code IS NULL), COUNT(*) FROM sale_report
UNION ALL
SELECT 'sale_report', 'stock',     COUNT(*) FILTER (WHERE stock    IS NULL), COUNT(*) FROM sale_report
UNION ALL
SELECT 'sale_report', 'category',  COUNT(*) FILTER (WHERE category IS NULL), COUNT(*) FROM sale_report

UNION ALL
-- may_2022_pricing
SELECT 'may_2022_pricing', 'sku',       COUNT(*) FILTER (WHERE sku       IS NULL), COUNT(*) FROM may_2022_pricing
UNION ALL
SELECT 'may_2022_pricing', 'mrp_old',   COUNT(*) FILTER (WHERE mrp_old   IS NULL), COUNT(*) FROM may_2022_pricing
UNION ALL
SELECT 'may_2022_pricing', 'amazon_mrp',COUNT(*) FILTER (WHERE amazon_mrp IS NULL), COUNT(*) FROM may_2022_pricing

UNION ALL
-- pl_march_2021
SELECT 'pl_march_2021', 'sku',        COUNT(*) FILTER (WHERE sku      IS NULL), COUNT(*) FROM pl_march_2021
UNION ALL
SELECT 'pl_march_2021', 'tp_1',       COUNT(*) FILTER (WHERE tp_1     IS NULL), COUNT(*) FROM pl_march_2021
UNION ALL
SELECT 'pl_march_2021', 'amazon_mrp', COUNT(*) FILTER (WHERE amazon_mrp IS NULL), COUNT(*) FROM pl_march_2021

UNION ALL
-- expense_items
SELECT 'expense_items', 'particular', COUNT(*) FILTER (WHERE particular IS NULL), COUNT(*) FROM expense_items
UNION ALL
SELECT 'expense_items', 'amount',     COUNT(*) FILTER (WHERE amount     IS NULL), COUNT(*) FROM expense_items

UNION ALL
-- expense_received
SELECT 'expense_received', 'date',            COUNT(*) FILTER (WHERE date            IS NULL), COUNT(*) FROM expense_received
UNION ALL
SELECT 'expense_received', 'received_amount', COUNT(*) FILTER (WHERE received_amount IS NULL), COUNT(*) FROM expense_received

ORDER BY null_count DESC;


-- =============================================================================
-- CHECK 3: REFERENTIAL INTEGRITY
-- =============================================================================
-- WHY A DE CARES:
--   In a relational pipeline, child tables reference parent tables via a shared
--   key (e.g., sku). If a product is deleted upstream or a join key changes,
--   child rows become orphaned — they exist in the DB but can never be joined
--   to their parent. Queries silently drop those rows or return wrong counts.
--   This check surfaces those orphans before they cause incorrect aggregations.
--
-- RELATIONSHIP MAP in this dataset:
--   amazon_sale_report.sku        → may_2022_pricing.sku  (price lookup)
--   amazon_sale_report.sku        → pl_march_2021.sku     (cost/P&L lookup)
--   international_sales.sku → may_2022_pricing.sku  (price lookup)
--   sale_report.sku_code    → may_2022_pricing.sku  (inventory ↔ pricing)
-- =============================================================================

-- Orphaned amazon_sale_report rows: sku exists in orders but not in the pricing table
SELECT
    'amazon_sale_report → may_2022_pricing'   AS relationship,
    a.sku                               AS orphaned_sku,
    COUNT(*)                            AS orphaned_row_count
FROM amazon_sale_report a
LEFT JOIN may_2022_pricing p ON a.sku = p.sku
WHERE p.sku IS NULL
GROUP BY a.sku
ORDER BY orphaned_row_count DESC;

-- Orphaned amazon_sale_report rows: sku exists in orders but not in P&L cost table
SELECT
    'amazon_sale_report → pl_march_2021'      AS relationship,
    a.sku                               AS orphaned_sku,
    COUNT(*)                            AS orphaned_row_count
FROM amazon_sale_report a
LEFT JOIN pl_march_2021 pl ON a.sku = pl.sku
WHERE pl.sku IS NULL
GROUP BY a.sku
ORDER BY orphaned_row_count DESC;

-- Orphaned international_sales rows: sku not found in pricing
SELECT
    'international_sales → may_2022_pricing' AS relationship,
    i.sku                                    AS orphaned_sku,
    COUNT(*)                                 AS orphaned_row_count
FROM international_sales i
LEFT JOIN may_2022_pricing p ON i.sku = p.sku
WHERE p.sku IS NULL
GROUP BY i.sku
ORDER BY orphaned_row_count DESC;

-- Orphaned sale_report rows: inventory sku not present in pricing master
SELECT
    'sale_report → may_2022_pricing'    AS relationship,
    s.sku_code                          AS orphaned_sku,
    COUNT(*)                            AS orphaned_row_count
FROM sale_report s
LEFT JOIN may_2022_pricing p ON s.sku_code = p.sku
WHERE p.sku IS NULL
GROUP BY s.sku_code
ORDER BY orphaned_row_count DESC;


-- =============================================================================
-- CHECK 4: FRESHNESS CHECK
-- =============================================================================
-- WHY A DE CARES:
--   A pipeline that silently stopped loading data is indistinguishable from a
--   healthy one until someone notices the numbers stopped moving. The freshness
--   check gives you the most recent and oldest record timestamp per table in
--   one glance. Set a monitoring threshold (e.g., max_date < CURRENT_DATE - 1)
--   and you have a pipeline heartbeat check.
-- =============================================================================

-- Tables with a date column
SELECT
    'amazon_sale_report'          AS table_name,
    MIN(date::DATE)         AS oldest_record,
    MAX(date::DATE)         AS newest_record,
    MAX(date::DATE) - MIN(date::DATE) AS date_range_days,
    CURRENT_DATE - MAX(date::DATE)    AS days_since_last_load
FROM amazon_sale_report

UNION ALL

SELECT
    'international_sales',
    MIN(date::DATE),
    MAX(date::DATE),
    MAX(date::DATE) - MIN(date::DATE),
    CURRENT_DATE - MAX(date::DATE)
FROM international_sales

UNION ALL

SELECT
    'expense_received',
    MIN(date::DATE),
    MAX(date::DATE),
    MAX(date::DATE) - MIN(date::DATE),
    CURRENT_DATE - MAX(date::DATE)
FROM expense_received

ORDER BY days_since_last_load DESC;

-- NOTE: sale_report, may_2022_pricing, pl_march_2021, expense_items, and
-- cloud_warehouse are dimension/reference tables with no date column.
-- Freshness for those is determined by pipeline run metadata (e.g., an
-- etl_load_timestamp column you should add to every table during ingestion).


-- =============================================================================
-- CHECK 5: SUMMARY CTE — ALL CHECKS IN ONE QUERY
-- =============================================================================
-- WHY A DE CARES:
--   In production, you need a single query that outputs a health scorecard.
--   A Airflow sensor, dbt test, or Grafana panel can call this one query and
--   flag any row where status = 'FAIL'. Each CTE mirrors a check above but
--   collapses the result to a single status row per table, so the output is
--   dashboardable and alert-friendly.
-- =============================================================================

WITH

-- ── 1. Duplicate counts per table ─────────────────────────────────────────────
dup_amazon AS (
    SELECT COUNT(*) AS dup_groups
    FROM (
        SELECT order_id, sku
        FROM amazon_sale_report
        GROUP BY order_id, sku
        HAVING COUNT(*) > 1
    ) d
),
dup_intl AS (
    SELECT COUNT(*) AS dup_groups
    FROM (
        SELECT date, customer, sku, size
        FROM international_sales
        GROUP BY date, customer, sku, size
        HAVING COUNT(*) > 1
    ) d
),
dup_sale AS (
    SELECT COUNT(*) AS dup_groups
    FROM (
        SELECT sku_code, color, size
        FROM sale_report
        GROUP BY sku_code, color, size
        HAVING COUNT(*) > 1
    ) d
),

-- ── 2. Null counts on the most critical columns ────────────────────────────────
null_summary AS (
    SELECT
        SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS amazon_null_order_id,
        SUM(CASE WHEN amount   IS NULL THEN 1 ELSE 0 END) AS amazon_null_amount,
        SUM(CASE WHEN sku      IS NULL THEN 1 ELSE 0 END) AS amazon_null_sku
    FROM amazon_sale_report
),
null_intl AS (
    SELECT
        SUM(CASE WHEN gross_amt IS NULL THEN 1 ELSE 0 END) AS intl_null_gross_amt,
        SUM(CASE WHEN customer  IS NULL THEN 1 ELSE 0 END) AS intl_null_customer
    FROM international_sales
),

-- ── 3. Referential integrity: orphan counts ───────────────────────────────────
orphan_amazon_pricing AS (
    SELECT COUNT(*) AS orphan_count
    FROM amazon_sale_report a
    LEFT JOIN may_2022_pricing p ON a.sku = p.sku
    WHERE p.sku IS NULL
),
orphan_amazon_pl AS (
    SELECT COUNT(*) AS orphan_count
    FROM amazon_sale_report a
    LEFT JOIN pl_march_2021 pl ON a.sku = pl.sku
    WHERE pl.sku IS NULL
),
orphan_intl_pricing AS (
    SELECT COUNT(*) AS orphan_count
    FROM international_sales i
    LEFT JOIN may_2022_pricing p ON i.sku = p.sku
    WHERE p.sku IS NULL
),

-- ── 4. Freshness: days since last load ────────────────────────────────────────
freshness AS (
    SELECT
        CURRENT_DATE - MAX(date::DATE) AS amazon_days_stale
    FROM amazon_sale_report
),
freshness_intl AS (
    SELECT
        CURRENT_DATE - MAX(date::DATE) AS intl_days_stale
    FROM international_sales
),

-- ── 5. Final scorecard — one row per check ────────────────────────────────────
scorecard AS (

    SELECT
        'DUPLICATES'                    AS check_name,
        'amazon_sale_report'                  AS table_name,
        (SELECT dup_groups FROM dup_amazon)::TEXT AS metric_value,
        CASE WHEN (SELECT dup_groups FROM dup_amazon) = 0
             THEN 'PASS' ELSE 'FAIL'   END AS status,
        'Duplicate (order_id, sku) groups found. Pipeline may have loaded twice.'
                                        AS description

    UNION ALL SELECT
        'DUPLICATES', 'international_sales',
        (SELECT dup_groups FROM dup_intl)::TEXT,
        CASE WHEN (SELECT dup_groups FROM dup_intl) = 0 THEN 'PASS' ELSE 'FAIL' END,
        'Duplicate (date, customer, sku, size) groups found.'

    UNION ALL SELECT
        'DUPLICATES', 'sale_report',
        (SELECT dup_groups FROM dup_sale)::TEXT,
        CASE WHEN (SELECT dup_groups FROM dup_sale) = 0 THEN 'PASS' ELSE 'FAIL' END,
        'Duplicate (sku_code, color, size) inventory rows found.'

    UNION ALL SELECT
        'NULL AUDIT', 'amazon_sale_report.order_id',
        (SELECT amazon_null_order_id FROM null_summary)::TEXT,
        CASE WHEN (SELECT amazon_null_order_id FROM null_summary) = 0 THEN 'PASS' ELSE 'FAIL' END,
        'Null order_id — rows that can never be joined to fulfilment or returns.'

    UNION ALL SELECT
        'NULL AUDIT', 'amazon_sale_report.amount',
        (SELECT amazon_null_amount FROM null_summary)::TEXT,
        CASE WHEN (SELECT amazon_null_amount FROM null_summary) = 0 THEN 'PASS' ELSE 'FAIL' END,
        'Null amount — revenue will be understated in any SUM aggregation.'

    UNION ALL SELECT
        'NULL AUDIT', 'international_sales.gross_amt',
        (SELECT intl_null_gross_amt FROM null_intl)::TEXT,
        CASE WHEN (SELECT intl_null_gross_amt FROM null_intl) = 0 THEN 'PASS' ELSE 'FAIL' END,
        'Null gross_amt in international sales — P&L calculations will be wrong.'

    UNION ALL SELECT
        'REFERENTIAL INTEGRITY', 'amazon_sale_report → may_2022_pricing',
        (SELECT orphan_count FROM orphan_amazon_pricing)::TEXT,
        CASE WHEN (SELECT orphan_count FROM orphan_amazon_pricing) = 0 THEN 'PASS' ELSE 'FAIL' END,
        'Orders with a sku that has no matching price record. Price joins will produce NULLs.'

    UNION ALL SELECT
        'REFERENTIAL INTEGRITY', 'amazon_sale_report → pl_march_2021',
        (SELECT orphan_count FROM orphan_amazon_pl)::TEXT,
        CASE WHEN (SELECT orphan_count FROM orphan_amazon_pl) = 0 THEN 'PASS' ELSE 'FAIL' END,
        'Orders with no cost/P&L record. Margin calculations will drop these rows.'

    UNION ALL SELECT
        'REFERENTIAL INTEGRITY', 'international_sales → may_2022_pricing',
        (SELECT orphan_count FROM orphan_intl_pricing)::TEXT,
        CASE WHEN (SELECT orphan_count FROM orphan_intl_pricing) = 0 THEN 'PASS' ELSE 'FAIL' END,
        'International orders whose sku is missing from the pricing master table.'

    UNION ALL SELECT
        'FRESHNESS', 'amazon_sale_report',
        (SELECT amazon_days_stale FROM freshness)::TEXT || ' days',
        CASE WHEN (SELECT amazon_days_stale FROM freshness) <= 1 THEN 'PASS' ELSE 'FAIL' END,
        'Days since the most recent order date. >1 day may indicate a stalled pipeline.'

    UNION ALL SELECT
        'FRESHNESS', 'international_sales',
        (SELECT intl_days_stale FROM freshness_intl)::TEXT || ' days',
        CASE WHEN (SELECT intl_days_stale FROM freshness_intl) <= 1 THEN 'PASS' ELSE 'FAIL' END,
        'Days since the most recent international sale date.'

)

-- ── Final output ──────────────────────────────────────────────────────────────
SELECT
    check_name,
    table_name,
    metric_value,
    status,
    description
FROM scorecard
ORDER BY
    CASE status WHEN 'FAIL' THEN 0 ELSE 1 END,  -- FAILs float to the top
    check_name,
    table_name;

-- =============================================================================
-- END OF PIPELINE QUALITY CHECKER
-- =============================================================================
-- NEXT STEPS FOR THE DE:
--   • Add etl_load_timestamp to every table during ingestion so dimension
--     tables (sale_report, may_2022_pricing) also get a freshness check.
--   • Wrap the scorecard CTE in a view: CREATE VIEW pipeline_health AS ...
--   • In Airflow, add a PythonOperator after each pipeline run that calls:
--       SELECT COUNT(*) FROM pipeline_health WHERE status = 'FAIL'
--     and raises an exception if the count > 0.
--   • For BigQuery: replace FILTER (WHERE ...) with COUNTIF(...),
--     replace ::DATE with CAST(... AS DATE), replace ::TEXT with CAST(... AS STRING).
-- =============================================================================
