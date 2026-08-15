-- models/marts/category_loss_by_year.sql
-- Returned (lost) quantity by category per year from sales transactions.

{{ config(
    materialized='table',
    tags=['marts', 'loss', 'sales']
) }}

with sales as (

    select * from {{ ref('stg_sales') }}

),

items as (

    select * from {{ ref('stg_items') }}

)

select
    extract(year from sales.sales_date) as loss_year,
    items.category_code,
    items.category_name,
    count(*) as loss_transaction_count,
    sum(sales.quantity_sold) as loss_quantity

from sales
inner join items
    on sales.item_code = items.item_code
where lower(sales.sale_or_return) = 'return'
group by
    extract(year from sales.sales_date),
    items.category_code,
    items.category_name
order by loss_year, loss_quantity desc
