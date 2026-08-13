{% snapshot items_snapshot %}

{{
    config(
        target_schema='snapshots',
        unique_key='item_code',
        strategy='check',
        check_cols=['item_name', 'category_code', 'category_name']
    )
}}

select
    item_code,
    item_name,
    category_code,
    category_name
from {{ ref('stg_items') }}

{% endsnapshot %}
