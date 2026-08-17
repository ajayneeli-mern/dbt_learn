{{
    config(
        materialized='table',
        tags=['marts', 'ecommerce', 'deliveries']
    )
}}

with order_deliveries as (

    select * from {{ ref('int_ecommerce_orders_deliveries') }}

),

final as (

    select
        order_line_id,
        order_id,
        order_date,
        
        -- Customer information
        customer_id,
        customer_first_name,
        customer_last_name,
        concat(customer_first_name, ' ', customer_last_name) as customer_full_name,
        customer_email,
        customer_phone_number,

        -- Delivery Person information
        delivery_person_id,
        delivery_person_name,
        delivery_person_phone_number,
        delivery_person_vehicle_type,
        delivery_person_employment_type,

        -- Delivery Location details
        delivery_location_id,
        delivery_city,
        delivery_state,
        delivery_postal_code,
        delivery_region,
        delivery_latitude,
        delivery_longitude,
        delivery_area_type,
        delivery_location_category,

        -- Order financials
        quantity,
        unit_price,
        discount_percentage,
        tax_percentage,
        shipping_fee,
        net_item_amount,
        total_order_line_amount,

        -- Delivery SLAs & ratings
        expected_delivery_date,
        actual_delivery_date,
        delivery_rating,
        delivery_delay_days,
        is_delivery_delayed

    from order_deliveries

)

select * from final
