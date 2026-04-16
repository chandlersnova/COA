-- Repro for Tracker #39-style parser collapse (complex multi-CTE → single column "1").
-- Usage: In Coalesce, create a new SQL node (or paste into an existing one) and replace
-- the @id line below with your node's UUID from the editor. Keep @nodeType matching your SQL Node type.
-- Refs use only nodes present in this repo: SRC LINEITEM, ORDERS, CUSTOMER, PARTSUPP, SUPPLIER.

@id("00000000-0000-4000-8000-000000000001")
@nodeType("1c9353bd-990e-4876-b895-5f0aa885314c")
WITH time_periods AS (
    SELECT DISTINCT
        DATE_TRUNC('month', o.O_ORDERDATE) AS period_month,
        DATE_TRUNC('quarter', o.O_ORDERDATE) AS period_quarter,
        EXTRACT(YEAR FROM o.O_ORDERDATE) AS period_year
    FROM {{ ref('SRC', 'ORDERS') }} o
),
monthly_order_metrics AS (
    SELECT
        DATE_TRUNC('month', o.O_ORDERDATE) AS period_month,
        c.C_NATIONKEY AS region_key,
        c.C_MKTSEGMENT AS market_segment,
        COUNT(DISTINCT o.O_ORDERKEY) AS order_count,
        COUNT(DISTINCT c.C_CUSTKEY) AS active_customers,
        SUM(l.L_EXTENDEDPRICE * (1 - l.L_DISCOUNT)) AS total_revenue,
        SUM(l.L_EXTENDEDPRICE * (1 - l.L_DISCOUNT) * 0.1) AS total_margin,
        AVG(l.L_DISCOUNT) AS avg_discount,
        SUM(l.L_QUANTITY) AS total_units,
        SUM(CASE WHEN l.L_LINENUMBER = 1 THEN 1 ELSE 0 END) AS first_line_orders,
        SUM(CASE WHEN c.C_ACCTBAL > 0 THEN l.L_EXTENDEDPRICE * (1 - l.L_DISCOUNT) ELSE 0 END) AS positive_balance_revenue,
        SUM(CASE WHEN l.L_DISCOUNT < 0.05 THEN l.L_EXTENDEDPRICE * (1 - l.L_DISCOUNT) ELSE 0 END) AS low_discount_revenue
    FROM {{ ref('SRC', 'LINEITEM') }} l
    INNER JOIN {{ ref('SRC', 'ORDERS') }} o ON l.L_ORDERKEY = o.O_ORDERKEY
    INNER JOIN {{ ref('SRC', 'CUSTOMER') }} c ON o.O_CUSTKEY = c.C_CUSTKEY
    GROUP BY DATE_TRUNC('month', o.O_ORDERDATE), c.C_NATIONKEY, c.C_MKTSEGMENT
),
monthly_supplier_metrics AS (
    SELECT
        DATE_TRUNC('month', o.O_ORDERDATE) AS period_month,
        s.S_NATIONKEY AS supplier_region,
        COUNT(DISTINCT l.L_SUPPKEY) AS active_suppliers,
        SUM(l.L_EXTENDEDPRICE * (1 - l.L_DISCOUNT)) AS supplier_revenue,
        AVG(ps.PS_SUPPLYCOST) AS avg_supply_cost,
        SUM(CASE WHEN ps.PS_AVAILQTY > 10 THEN l.L_EXTENDEDPRICE ELSE 0 END) AS high_availability_revenue,
        SUM(CASE WHEN s.S_ACCTBAL < 0 THEN l.L_EXTENDEDPRICE * (1 - l.L_DISCOUNT) ELSE 0 END) AS negative_balance_supplier_revenue
    FROM {{ ref('SRC', 'LINEITEM') }} l
    INNER JOIN {{ ref('SRC', 'ORDERS') }} o ON l.L_ORDERKEY = o.O_ORDERKEY
    INNER JOIN {{ ref('SRC', 'PARTSUPP') }} ps ON l.L_PARTKEY = ps.PS_PARTKEY AND l.L_SUPPKEY = ps.PS_SUPPKEY
    INNER JOIN {{ ref('SRC', 'SUPPLIER') }} s ON ps.PS_SUPPKEY = s.S_SUPPKEY
    GROUP BY DATE_TRUNC('month', o.O_ORDERDATE), s.S_NATIONKEY
),
profitability_summary AS (
    SELECT
        DATE_TRUNC('month', o.O_ORDERDATE) AS period_month,
        c.C_NATIONKEY AS region_key,
        COUNT(*) AS total_lines,
        SUM(CASE WHEN l.L_EXTENDEDPRICE * (1 - l.L_DISCOUNT) > 1000 THEN 1 ELSE 0 END) AS high_value_lines,
        SUM(CASE WHEN l.L_EXTENDEDPRICE * (1 - l.L_DISCOUNT) <= 100 THEN 1 ELSE 0 END) AS low_value_lines,
        SUM(CASE WHEN l.L_EXTENDEDPRICE * (1 - l.L_DISCOUNT) BETWEEN 100 AND 1000 THEN 1 ELSE 0 END) AS mid_value_lines,
        AVG(l.L_DISCOUNT) AS avg_discount_rate,
        SUM(l.L_EXTENDEDPRICE * l.L_TAX) AS total_tax_component,
        SUM(l.L_QUANTITY * l.L_EXTENDEDPRICE) AS qty_price_product
    FROM {{ ref('SRC', 'LINEITEM') }} l
    INNER JOIN {{ ref('SRC', 'ORDERS') }} o ON l.L_ORDERKEY = o.O_ORDERKEY
    INNER JOIN {{ ref('SRC', 'CUSTOMER') }} c ON o.O_CUSTKEY = c.C_CUSTKEY
    GROUP BY DATE_TRUNC('month', o.O_ORDERDATE), c.C_NATIONKEY
),
customer_cohort_metrics AS (
    SELECT
        DATE_TRUNC('month', o.O_ORDERDATE) AS cohort_month,
        c.C_NATIONKEY AS region_key,
        COUNT(DISTINCT c.C_CUSTKEY) AS cohort_size,
        AVG(o.O_TOTALPRICE) AS avg_order_price,
        AVG(c.C_ACCTBAL) AS avg_acct_bal
    FROM {{ ref('SRC', 'ORDERS') }} o
    INNER JOIN {{ ref('SRC', 'CUSTOMER') }} c ON o.O_CUSTKEY = c.C_CUSTKEY
    GROUP BY DATE_TRUNC('month', o.O_ORDERDATE), c.C_NATIONKEY
),
aggregated_metrics AS (
    SELECT
        mom.period_month,
        mom.region_key,
        mom.market_segment,
        mom.order_count,
        mom.active_customers,
        mom.total_units,
        mom.total_revenue,
        mom.total_margin,
        mom.avg_discount,
        ROUND((mom.total_margin / NULLIF(mom.total_revenue, 0)) * 100, 2) AS gross_margin_percent,
        mom.first_line_orders,
        ROUND((mom.first_line_orders::FLOAT / NULLIF(mom.order_count, 0)) * 100, 2) AS first_line_rate,
        mom.positive_balance_revenue,
        ROUND((mom.positive_balance_revenue / NULLIF(mom.total_revenue, 0)) * 100, 2) AS positive_balance_pct,
        mom.low_discount_revenue,
        ps.high_value_lines,
        ps.low_value_lines,
        ps.mid_value_lines,
        ROUND((ps.high_value_lines + ps.low_value_lines)::FLOAT / NULLIF(ps.total_lines, 0) * 100, 2) AS line_mix_pct,
        ps.avg_discount_rate,
        ps.total_tax_component,
        ps.qty_price_product,
        msm.active_suppliers,
        msm.supplier_revenue,
        msm.avg_supply_cost,
        msm.high_availability_revenue,
        msm.negative_balance_supplier_revenue,
        ccm.cohort_size,
        ccm.avg_order_price AS cohort_avg_order_price,
        ccm.avg_acct_bal AS cohort_avg_acct_bal,
        LAG(mom.total_revenue, 1) OVER (PARTITION BY mom.region_key, mom.market_segment ORDER BY mom.period_month) AS prev_month_revenue,
        LAG(mom.order_count, 1) OVER (PARTITION BY mom.region_key, mom.market_segment ORDER BY mom.period_month) AS prev_month_orders,
        SUM(mom.total_revenue) OVER (
            PARTITION BY mom.region_key, mom.market_segment, EXTRACT(YEAR FROM mom.period_month)
            ORDER BY mom.period_month
            ROWS UNBOUNDED PRECEDING
        ) AS ytd_revenue,
        SUM(mom.total_margin) OVER (
            PARTITION BY mom.region_key, mom.market_segment, EXTRACT(YEAR FROM mom.period_month)
            ORDER BY mom.period_month
            ROWS UNBOUNDED PRECEDING
        ) AS ytd_margin
    FROM monthly_order_metrics mom
    LEFT JOIN profitability_summary ps ON mom.period_month = ps.period_month AND mom.region_key = ps.region_key
    LEFT JOIN monthly_supplier_metrics msm ON mom.period_month = msm.period_month AND mom.region_key = msm.supplier_region
    LEFT JOIN customer_cohort_metrics ccm ON mom.period_month = ccm.cohort_month AND mom.region_key = ccm.region_key
)
SELECT
    period_month,
    region_key,
    market_segment,
    order_count,
    active_customers,
    total_units,
    ROUND(total_units::FLOAT / NULLIF(order_count, 0), 2) AS avg_units_per_order,
    ROUND(total_revenue / NULLIF(order_count, 0), 2) AS avg_order_value,
    total_revenue,
    total_margin,
    avg_discount,
    gross_margin_percent,
    ytd_revenue,
    ytd_margin,
    prev_month_revenue,
    prev_month_orders,
    ROUND(((total_revenue - prev_month_revenue) / NULLIF(prev_month_revenue, 0)) * 100, 2) AS revenue_mom_growth_pct,
    ROUND(((order_count - prev_month_orders) / NULLIF(prev_month_orders, 0)) * 100, 2) AS orders_mom_growth_pct,
    first_line_orders,
    first_line_rate,
    positive_balance_revenue,
    positive_balance_pct,
    low_discount_revenue,
    high_value_lines,
    low_value_lines,
    mid_value_lines,
    line_mix_pct,
    avg_discount_rate,
    total_tax_component,
    qty_price_product,
    active_suppliers,
    supplier_revenue,
    avg_supply_cost,
    high_availability_revenue,
    negative_balance_supplier_revenue,
    cohort_size,
    cohort_avg_order_price,
    cohort_avg_acct_bal,
    CASE
        WHEN avg_supply_cost <= 500 AND line_mix_pct >= 50 THEN 'EXCELLENT'
        WHEN avg_supply_cost <= 800 AND line_mix_pct >= 30 THEN 'GOOD'
        WHEN avg_supply_cost <= 1200 THEN 'ACCEPTABLE'
        ELSE 'NEEDS_IMPROVEMENT'
    END AS operational_health,
    high_availability_revenue - negative_balance_supplier_revenue AS net_premium_impact,
    ROUND(
        (COALESCE(line_mix_pct, 0) * 0.3)
        + (COALESCE(avg_supply_cost, 0) * 0.0003)
        + ((100 - COALESCE(avg_discount_rate, 0) * 100) * 0.2)
        + (LEAST(COALESCE(revenue_mom_growth_pct, 0) + 50, 100) * 0.2),
        2
    ) AS supply_chain_health_score,
    CURRENT_TIMESTAMP::TIMESTAMP AS loaded_at
FROM aggregated_metrics
WHERE
    order_count > 0
    AND period_month IN (SELECT period_month FROM time_periods)
ORDER BY period_month DESC, region_key, market_segment;
