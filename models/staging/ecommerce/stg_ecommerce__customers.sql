with source as (

    select * from {{ source('raw_ecommerce', 'DIM_CUSTOMER') }}

),

renamed as (

    select
        customer_id,
        first_name,
        last_name,
        email,
        phone_number,
        gender,
        date_of_birth,
        registration_date,
        income_bracket,
        marital_status,
        location_id,
        upi_id,
        credit_card_number

    from source

)

select * from renamed
