-- Used to calculate the first 17 digits of an SSCC code for EDI 856.
-- The 18th digit is a checksum calculated via Python script in the next step downstream
{% macro sscc_header_item(pallet_header_id) -%}
    '00006767' || lpad(regexp_replace(nullif(right({{ pallet_header_id }}, 9), ''), '[^0-9]', ''), 9, '0')
{%- endmacro %}