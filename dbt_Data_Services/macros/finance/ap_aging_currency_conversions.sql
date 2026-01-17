{# macros/ap_currency_conversion.sql #}
{% macro ap_currency_conversion(doctype, curncyid, curtrxam, rate, funlcurr) %}
case
  /* same-currency path: just sign the amount by doctype */
  when upper(trim({{ funlcurr }})) = upper(trim({{ curncyid }})) then
    case when {{ doctype }} < 4 then {{ curtrxam }} else -{{ curtrxam }} end

  /* fx path: sign the amount, then apply rate (round to 2) */
  else
    case
      when {{ rate }} is null then null
      else round(
        (case when {{ doctype }} < 4 then {{ curtrxam }} else -{{ curtrxam }} end) / {{ rate }},
        2
      )
    end
end
{% endmacro %}
