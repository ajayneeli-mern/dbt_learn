-- models/marts/supermarkets/category_loss.sql
-- Item-level category + loss from seeds: annex1 (items/categories) + annex4 (loss rates)

{{ config(
    materialized='table',
    tags=['marts', 'loss', 'items']
) }}

with items as (

    select * from {{ ref('stg_items') }}

),

loss_rates as (

    select * from {{ ref('stg_item_loss_rates') }}

)

select
    items.category_code,
    items.category_name,
    items.item_code,
    items.item_name,
    loss_rates.loss_rate

from items
inner join loss_rates
    on items.item_code = loss_rates.item_code
order by items.category_name, loss_rates.loss_rate desc
