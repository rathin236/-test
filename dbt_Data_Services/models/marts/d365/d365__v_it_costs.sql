with d365_it_costs as (

    SELECT DISTINCT
        gje.*,
        (exr.exchangerate / 100) AS "Exchange Rate (USD-CAD)",
        exr.validfrom AS "Valid From (USD-CAD)",
        exr.validto AS "Valid To (USD-CAD)",

        CASE
            WHEN exr.exchangerate is not null and gje.accounting_currency_amount < 0 then
                round(abs(gje.accounting_currency_amount) / (exr.exchangerate / 100), 2)
            WHEN exr.exchangerate is null and gje.accounting_currency_amount < 0 then
                round(abs(gje.accounting_currency_amount), 2)
            ELSE
                round(0,2)
        END AS total_journal_credit_CAD,

        CASE
            WHEN exr.exchangerate is not null and gje.accounting_currency_amount >= 0 then
                round(gje.accounting_currency_amount / (exr.exchangerate / 100), 2)
            WHEN exr.exchangerate is null and gje.accounting_currency_amount >= 0 then
                round(gje.accounting_currency_amount, 2)
            ELSE
                round(0,2)
        END AS total_journal_debit_CAD     

    FROM {{ref('int_d365__general_journal_entries_it_costs')}} AS gje

    LEFT JOIN {{ref('stg_d365__exchange_rate_currency_pair')}} AS curp
        ON gje.general_journal_entry_currency = curp.tocurrencycode
            AND curp.fromcurrencycode = 'CAD'

    LEFT JOIN {{ref('stg_d365__exchange_rate')}} AS exr
        ON curp.recid = exr.exchangeratecurrencypair
            AND to_varchar(
                COALESCE(gje.invoice_date, gje.create_date_time),
                'yyyy-mm-dd'
            ) BETWEEN date(exr.validfrom) AND date(exr.validto)

)

select * from d365_it_costs
