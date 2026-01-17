{% macro concur_r_id(ledger_name, report_id, payment_type_code, transaction_date, posted_date, payment_type_name, currency_code) -%}
    {{ report_id }} ||
        month(case
                when {{ payment_type_code }} = 'CASH'
                    then max({{ transaction_date }})
                else max({{ posted_date }})
                end) ||
        year(case
                when {{ payment_type_code }} = 'CASH'
                    then max({{ transaction_date }})
                else max({{ posted_date }}) end)
                || (case
                        when {{ ledger_name }} != 'LATAM' then ''
                        when {{ ledger_name }} = 'LATAM' then (upper(replace({{ payment_type_name }}, ' ', '')) || {{ currency_code }})
                        else 'UNDEFINED'
                    end)
{%- endmacro %}
