{{ config(
    materialized='ephemeral',
    tags=['intermediate', 'items']
) }}

-- Ephemeral: compiled as a CTE when referenced — no table/view in Snowflake.
-- Adds a durable surrogate key derived from the natural item_code.

with items as (

    select * from {{ ref('stg_items') }}

)

select
    {{ dbt_utils.generate_surrogate_key(['item_code']) }} as item_sk,
    item_code,
    item_name,
    category_code,
    category_name
from items
