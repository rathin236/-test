{% macro cad_current_rate(curncyid, originating_amount, todays_rate) %}
    case
        when {{ curncyid }} = 'CAD' then {{ originating_amount }}
        else round({{ originating_amount }} / {{ todays_rate }}, 2)
    end
{% endmacro %}