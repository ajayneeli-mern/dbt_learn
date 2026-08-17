with orders as (

    select * from {{ ref('stg_ecommerce__orders') }}

),

customers as (

    select * from {{ ref('stg_ecommerce__customers') }}

),

delivery_persons as (

    select * from {{ ref('stg_ecommerce__delivery_persons') }}

),

locations as (

    select * from {{ ref('stg_ecommerce__locations') }}

),

joined as (

    select
        -- Order identifiers & details
        orders.order_line_id,
        orders.order_id,
        orders.order_date,
        orders.product_id,
        orders.category,
        orders.quantity,
        orders.unit_price,
        orders.discount_percentage,
        orders.tax_percentage,
        orders.shipping_fee,

        -- Calculated order amount
        (orders.quantity * orders.unit_price) * (1 - coalesce(orders.discount_percentage, 0) / 100.0) as net_item_amount,
        ((orders.quantity * orders.unit_price) * (1 - coalesce(orders.discount_percentage, 0) / 100.0)) * (1 + coalesce(orders.tax_percentage, 0) / 100.0) + coalesce(orders.shipping_fee, 0) as total_order_line_amount,

        -- Customer attributes
        orders.customer_id,
        customers.first_name as customer_first_name,
        customers.last_name as customer_last_name,
        customers.email as customer_email,
        customers.phone_number as customer_phone_number,

        -- Delivery Person attributes
        orders.delivery_person_id,
        delivery_persons.delivery_person_name,
        delivery_persons.phone_number as delivery_person_phone_number,
        delivery_persons.vehicle_type as delivery_person_vehicle_type,
        delivery_persons.employment_type as delivery_person_employment_type,

        -- Delivery Location attributes
        orders.location_id as delivery_location_id,
        locations.city as delivery_city,
        locations.state as delivery_state,
        locations.postal_code as delivery_postal_code,
        locations.region as delivery_region,
        locations.latitude as delivery_latitude,
        locations.longitude as delivery_longitude,
        locations.area_type as delivery_area_type,
        locations.location_category as delivery_location_category,

        -- Delivery performance & tracking
        orders.expected_delivery_date,
        orders.actual_delivery_date,
        orders.delivery_rating,
        case
            when orders.actual_delivery_date is not null and orders.expected_delivery_date is not null
            then datediff('day', orders.expected_delivery_date, orders.actual_delivery_date)
            else null
        end as delivery_delay_days,
        case
            when orders.actual_delivery_date is not null and orders.expected_delivery_date is not null and orders.actual_delivery_date > orders.expected_delivery_date
            then true
            else false
        end as is_delivery_delayed

    from orders
    left join customers
        on orders.customer_id = customers.customer_id
    left join delivery_persons
        on orders.delivery_person_id = delivery_persons.delivery_person_id
    left join locations
        on orders.location_id = locations.location_id

)

select * from joined
