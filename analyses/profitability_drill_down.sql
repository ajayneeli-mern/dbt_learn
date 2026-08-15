-- analyses/profitability_drill_down.sql
-- Purpose: Detailed profitability analysis with drill-down by item and category
-- Useful for identifying high/low margin products
-- Run with: dbt compile --select analyses.profitability_drill_down

with profitability as (
    select * from {{ ref('item_profitability') }}
),

with_metrics as (
    select
        sales_date,
        category_code,
        category_name,
        item_code,
        item_name,
        total_quantity_sold,
        gross_sales_amount,
        wholesale_price,
        estimated_cost_amount,
        estimated_margin_amount,
        loss_rate,
        case
            when estimated_margin_amount is null then null
            else round(100.0 * estimated_margin_amount / gross_sales_amount, 2)
        end as margin_percentage,
        round(wholesale_price * loss_rate / 100.0, 4) as shrink_cost_per_unit,
        round(
            (estimated_margin_amount - (total_quantity_sold * wholesale_price * loss_rate / 100.0))
            / nullif(gross_sales_amount, 0),
            4
        ) as net_margin_after_shrink_pct
    from profitability
)

select
    sales_date,
    category_code,
    category_name,
    item_code,
    item_name,
    total_quantity_sold,
    gross_sales_amount,
    estimated_cost_amount,
    estimated_margin_amount,
    margin_percentage,
    loss_rate as loss_rate_percent,
    shrink_cost_per_unit,
    net_margin_after_shrink_pct,
    case
        when net_margin_after_shrink_pct > 0.15 then 'High Margin'
        when net_margin_after_shrink_pct > 0.05 then 'Medium Margin'
        when net_margin_after_shrink_pct > 0 then 'Low Margin'
        else 'Loss'
    end as margin_category
from with_metrics
where total_quantity_sold > 0
order by sales_date desc, net_margin_after_shrink_pct desc
