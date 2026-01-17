{% macro sscc_no_check_sum(pallet_header_id) -%}
    '00006767' || lpad(regexp_replace(nullif({{ pallet_header_id }}, ''), '[^0-9]', ''), 9, '0')
{%- endmacro %}
