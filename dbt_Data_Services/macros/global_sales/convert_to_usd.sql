{% macro convert_to_usd(exchange_rate, currency_code, amount) -%}
    case
            when  {{ currency_code }} = 'USD'
                then {{ amount }}
            when {{ exchange_rate }} is null
                then {{ amount }}
            else {{ amount }} * ({{ exchange_rate }} / 100)
            end
{%- endmacro %}
