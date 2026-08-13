-- Quantities sold should never be negative for sales transactions.

select
    item_code,
    category,
    number_of_items_sold
from {{ ref('item_category_sales') }}
where number_of_items_sold < 0
