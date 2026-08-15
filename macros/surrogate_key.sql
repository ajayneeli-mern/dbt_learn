{# Project-local surrogate key — avoids dbt_utils adapter.dispatch issues in the VS Code language server. #}
{% macro surrogate_key(field_list) -%}
{%- set parts = [] -%}
{%- for field in field_list -%}
    {%- do parts.append("coalesce(cast(" ~ field ~ " as varchar), '_surrogate_key_null_')") -%}
{%- endfor -%}
md5(cast({{ parts | join(" || '-' || ") }} as varchar))
{%- endmacro %}
