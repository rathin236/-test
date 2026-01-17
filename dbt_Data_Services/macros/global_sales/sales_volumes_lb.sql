{% macro sales_volumes_lb(sales_unit, sales_qty, conversion_factor) -%}
    case
            when {{ sales_unit }} = 'kg' and {{ conversion_factor }} is null
                then {{ sales_qty }} * 2.20462
            when {{ sales_unit }} = 'lb'
                then {{ sales_qty }}
            when {{ sales_unit }} != 'lb'
                then {{ sales_qty }} * {{ conversion_factor }}
            else 0
            end
{%- endmacro %}
