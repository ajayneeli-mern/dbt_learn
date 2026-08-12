with sales as (

    select * from {{ ref('item_daily_sales') }}

),

wholesale_prices as (

    select * from {{ ref('stg_wholesale_prices') }}

),

loss_rates as (

    select * from {{ ref('stg_item_loss_rates') }}

)

select
    sales.sales_date,
    sales.category_code,
    sales.category_name,
    sales.item_code,
    sales.item_name,
    sales.total_quantity_sold,
    sales.gross_sales_amount,
    wholesale_prices.wholesale_price,
    loss_rates.loss_rate,
    sales.total_quantity_sold * wholesale_prices.wholesale_price as estimated_cost_amount,
    sales.gross_sales_amount
        - (sales.total_quantity_sold * wholesale_prices.wholesale_price) as estimated_margin_amount

from sales
left join wholesale_prices
    on sales.item_code = wholesale_prices.item_code
    and sales.sales_date = wholesale_prices.price_date
left join loss_rates
    on sales.item_code = loss_rates.item_code
