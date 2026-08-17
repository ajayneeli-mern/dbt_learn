{{ config(tags=['staging', 'loss', 'items']) }}

with source as (

    select * from {{ source('raw_supermarkets','annex4') }}

),

renamed as (

    select
        item_code  as item_code,
        item_name  as item_name,
        loss_rate  as loss_rate

    from source

)

select * from renamed
