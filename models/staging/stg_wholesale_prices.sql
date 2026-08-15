{{ config(tags=['staging', 'pricing', 'items']) }}

with loss as (

    select * from {{ ref('annex3') }}

),

items as (
    select * from {{ ref('annex1') }}
)

select
    r.Date                  as price_date,
    r.Item_Code             as item_code,
    r.Wholesale_Price       as wholesale_price,
    i.Category_Name         as category_name
from loss r
left join items i on r.Item_Code = i.Item_Code
