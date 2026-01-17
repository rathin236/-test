{% macro so_pipeline_status(shipping_date) -%}
    case
            when to_char({{ shipping_date }}, 'YYYY-MM-DD') <= to_char(current_date() - 3, 'YYYY-MM-DD')
                then 'Backlog Orders'
            when to_char({{ shipping_date }}, 'YYYY-MM-DD') <= to_char(current_date(), 'YYYY-MM-DD')
                then 'Current Orders'
            when to_char({{ shipping_date }}, 'YYYY-MM-DD') > to_char(current_date(), 'YYYY-MM-DD')
                then 'Future Orders'
            else 'Pipeline Mismatch'
            end
{%- endmacro %}
