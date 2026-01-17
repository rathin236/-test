{% macro convert_to_lbs(unitid, physicalinvent, conversion_factor) -%}
    case
        when {{ unitid }} in ('KG', 'kg', 'Kg', 'kG') and {{ conversion_factor }} is null
            then {{ physicalinvent }} * 2.20462
        when {{ unitid }} in ('LB', 'lb', 'Lb', 'lB')
            then {{ physicalinvent }}
        when {{ unitid }} not in ('LB', 'lb', 'Lb', 'lB') and {{ conversion_factor }} is not null
            then {{ physicalinvent }} * {{ conversion_factor }}
        else 0
    end
{%- endmacro %}
