{% macro usd_current_rate(curncyid, originating_amount, todays_rate) %}
    case
        when {{ curncyid }} = 'USD' then {{ originating_amount }}
        when {{ curncyid }} = 'CAD' then round({{ originating_amount }} * {{ todays_rate }}, 2)
    end
{% endmacro %}