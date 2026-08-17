with source as (

    select * from {{ source('raw_ecommerce', 'DIM_LOCATION') }}

),

renamed as (

    select
        location_id,
        state,
        city,
        postal_code,
        region,
        latitude,
        longitude,
        area_type,
        location_category

    from source

)

select * from renamed
