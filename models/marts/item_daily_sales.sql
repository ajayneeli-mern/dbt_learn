with sales as (

    select * from {{ ref('stg_sales') }}

),

items as (

    select * from {{ ref('stg_items') }}

)

select
    sales.sales_date,
    items.category_code,
    items.category_name,
    sales.item_code,
    items.item_name,
    count(*) as transaction_count,
    sum(sales.quantity_sold) as total_quantity_sold,
    sum(sales.quantity_sold * sales.unit_selling_price) as gross_sales_amount

from sales
inner join items
    on sales.item_code = items.item_code
where sales.sale_or_return = 'SALE'
group by
    sales.sales_date,
    items.category_code,
    items.category_name,
    sales.item_code,
    items.item_name
