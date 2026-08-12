with source as (

    select * from {{ ref('annex2') }}

),

renamed as (

    select
        date                as sales_date,
        time                as sales_time,
        item_code           as item_code,
        sale_or_return      as sale_or_return,
        quantity_sold       as quantity_sold,
        unit_selling_price  as unit_selling_price,
        discount            as discount

    from source

)

select * from renamed
