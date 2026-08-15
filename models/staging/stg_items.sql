-- models/staging/stg_items.sql

{{ config(tags=['staging', 'items']) }}

with source as (

    select * from {{ ref('annex1') }}

),

renamed as (

    select
        Item_Code       as item_code,
        Item_Name       as item_name,
        Category_Code   as category_code,
        Category_Name   as category_name

    from source

)

select * from renamed