-- analyses/sales_performance_overview.sql
-- Purpose: Quick overview of daily sales performance by category
-- This is an exploratory query to understand sales trends across time and categories
-- Run with: dbt compile --select analyses.sales_performance_overview

with daily_sales as (
    select * from {{ ref('item_daily_sales') }}
),

category_stats as (
    select
        sales_date,
        category_name,
        count(distinct item_code) as unique_items_sold,
        sum(transaction_count) as total_transactions,
        sum(total_quantity_sold) as total_units_sold,
        sum(gross_sales_amount) as total_revenue,
        round(sum(gross_sales_amount) / sum(total_quantity_sold), 2) as avg_unit_price,
        min(sales_date) over (partition by category_name) as category_first_sale_date
    from daily_sales
    group by sales_date, category_name
)

select
    sales_date,
    category_name,
    unique_items_sold,
    total_transactions,
    total_units_sold,
    total_revenue,
    avg_unit_price,
    round(total_revenue / nullif(total_transactions, 0), 2) as revenue_per_transaction,
    datediff(day, category_first_sale_date, sales_date) as days_since_category_launch
from category_stats
order by sales_date desc, total_revenue desc
