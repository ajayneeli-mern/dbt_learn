-- Total quantity sold by item and category.

{{ config(
    materialized='table',
    tags=['marts', 'sales', 'items']
) }}

with items as (

    select
        item_sk,
        item_code,
        category_name
    from {{ ref('int_items') }}

),

sales as (

    select
        item_code,
        quantity_sold
    from {{ ref('stg_sales') }}
    where lower(sale_or_return) = 'sale'

)

select
    items.item_sk,
    items.item_code,
    items.category_name as category,
    sum(sales.quantity_sold) as number_of_items_sold

from sales
inner join items
    on sales.item_code = items.item_code
group by
    items.item_sk,
    items.item_code,
    items.category_name
