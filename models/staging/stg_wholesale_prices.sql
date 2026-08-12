with source as (

    select * from {{ ref('annex3') }}

),

renamed as (

    select
        date             as price_date,
        item_code        as item_code,
        wholesale_price  as wholesale_price

    from source

)

select * from renamed
