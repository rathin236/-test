{# macros/forex_convert.sql #}
{% macro forex_convert(from_ccy, to_ccy, amount, rate, scale=2) %}
case
  when upper(trim({{ from_ccy }})) = upper(trim({{ to_ccy }})) then {{ amount }}
  when {{ rate }} is null then null
  else round({{ amount }} * {{ rate }}, {{ scale }})
end
{% endmacro %}
