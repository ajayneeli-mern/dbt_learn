with source as (

    select * from {{ source('raw_ecommerce', 'FACT_ORDERS') }}

),

renamed as (

    select
        order_line_id,
        order_id,
        date_id,
        order_date,
        customer_id,
        product_id,
        category,
        seller_id,
        seller_rating,
        location_id,
        delivery_person_id,
        payment_id,
        campaign_id,
        fulfillment_id,
        quantity,
        unit_price,
        discount_percentage,
        tax_percentage,
        shipping_fee,
        expected_delivery_date,
        actual_delivery_date,
        delivery_rating

    from source

)

select * from renamed
