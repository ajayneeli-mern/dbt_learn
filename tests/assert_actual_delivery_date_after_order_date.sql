-- Singular Test:
-- Asserts that actual delivery date cannot be before the order date.
-- Returns failing records (if any row is returned, the test fails).

select
    order_line_id,
    order_id,
    order_date,
    actual_delivery_date
from {{ ref('fct_order_deliveries') }}
where actual_delivery_date is not null
  and actual_delivery_date < order_date
