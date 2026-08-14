with loss as (

    select * from {{ ref('annex3') }}

),

items as (
    select * from {{ ref('annex1') }}
)

select
    r.price_date,
    r.item_code,
    r.wholesale_price,
    i.Category_Name as category_name
from loss r
left join items i on r.item_code = i.Item_Code
