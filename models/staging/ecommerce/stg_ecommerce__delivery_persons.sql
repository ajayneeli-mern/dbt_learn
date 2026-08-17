with source as (

    select * from {{ source('raw_ecommerce', 'DIM_DELIVERY_PERSON') }}

),

renamed as (

    select
        delivery_person_id,
        delivery_person_name,
        phone_number,
        gender,
        date_of_joining,
        employment_type,
        vehicle_type,
        location_id

    from source

)

select * from renamed
