-- Order activity aggregated by seller, campaign, channel, and product category.

{{ config(
    materialized='table',
    tags=['marts', 'ecommerce', 'sales']
) }}

with orders as (

    select
        campaign_id,
        seller_id,
        category,
        quantity,
        gross_amount,
        net_amount
    from {{ ref('FACT_ORDERS') }}

),

campaigns as (

    select
        campaign_id,
        channel_id
    from {{ ref('DIM_CAMPAIGN') }}

)

select
    orders.campaign_id,
    campaigns.channel_id,
    orders.seller_id,
    orders.category,
    count(*) as number_of_order_lines,
    sum(orders.quantity) as total_quantity,
    sum(orders.gross_amount) as gross_amount,
    sum(orders.net_amount) as net_amount

from orders
left join campaigns
    on orders.campaign_id = campaigns.campaign_id
group by
    orders.campaign_id,
    campaigns.channel_id,
    orders.seller_id,
    orders.category