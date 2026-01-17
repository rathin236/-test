{% macro convert_to_usd_adjusted(exchange_rate, currency_code, amount) -%}
    case
            when {{ exchange_rate }} is null and {{ currency_code }} = 'USD'
                then {{ amount }}
            else {{ amount }} * ({{ exchange_rate }} / 100)
            end
{%- endmacro %}
