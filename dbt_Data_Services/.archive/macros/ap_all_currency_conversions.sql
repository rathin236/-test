{% macro ap_all_currency_conversion(doctype, funlcurr, curncyid, curtrxam, rate) %}
    case    
        when ({{ doctype }} < 4 and {{ funlcurr }} = {{ curncyid }}) then {{ curtrxam }}
        when ({{ doctype }} > 3 and {{ funlcurr }} = {{ curncyid }}) then {{ curtrxam }} * -1
        when ({{ doctype }} < 4 and {{ funlcurr }} != {{ curncyid }}) then round({{ curtrxam }} * {{ rate }}, 2)
        when ({{ doctype }} > 3 and {{ funlcurr }} != {{ curncyid }}) then round({{ curtrxam }} * -1 * {{ rate }}, 2)
        else {{ curtrxam }}
    end
{% endmacro %}