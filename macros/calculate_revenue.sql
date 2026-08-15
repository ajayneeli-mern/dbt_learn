{% macro calculate_revenue(quantity_col, price_col, discount_col) -%}

    sum(
        {{ quantity_col }}
        * {{ price_col }}
        * (1 - coalesce({{ discount_col }}, 0))
    )

{%- endmacro %}