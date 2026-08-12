-- models/marts/category_item_counts.sql

{{ config(materialized='table') }}

with items as (

    select * from {{ ref('stg_items') }}

)

select
    category_code,
    category_name,
    count(*) as item_count

from items
group by category_code, category_name
order by item_count desc