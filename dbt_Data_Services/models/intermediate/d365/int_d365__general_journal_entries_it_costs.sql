with general_journal_entries_it_costs as (

    select distinct
        mac.chart_of_accounts,
        mac.main_account_id,
        mac.main_account_name,
        mac.main_account_type,
        mac.account_category,
        van.name_description,
        van.vendor_id,
        van.bank_account,
        van.pay_mode,
        van.tax_group,
        van.vendor_group,
        van.w_9,
        gje.createddatetime as create_date_time,
        vij.invoicedate as invoice_date,
        gje.accountingdate as posted_date_time,
        ljt.approved,
        ljta.posted,
        ljta.journalname as journal_name,
        ljt.journalnum as ledger_journal_number,
        gje.journalnumber as general_journal_number,
        ljt.voucher,
        vij.ledgervoucher as ledger_voucher,
        gje.subledgervoucher as sub_ledger_voucher,
        vij.costledgervoucher as cost_ledger_voucher,
        ljta.journaltotalcredit as total_journal_credit,
        ljta.journaltotaldebit as total_journal_debit,
        ljta.journaltotaloffsetbalance as journal_offset,
        van.line_of_business,
        ljta.name as journal_description,
        ljt.paymreference as payment_reference,
        vij.invoiceaccount as invoice_account,
        vij.payment,
        vij.invoiceid as invoice_id,
        vij.invoiceamount as invoice_amount,
        vij.salesbalance as sales_balance,
        pt.enum_label as posting_type,
        glae.transactioncurrencyamount as amount,
        glae.accountingcurrencyamount as accounting_currency_amount,
        glae.transactioncurrencycode as general_journal_entry_currency,
        glae.ledgeraccount as ledger_account,
        glae.text as description,
        year(gje.accountingdate) as posted_year,
        upper(gje.subledgervoucherdataareaid) as company

    from {{ ref('stg_d365__general_journal_entry') }} as gje

    left join {{ ref('stg_d365__general_journal_account_entry') }} as glae
        on gje.recid = glae.generaljournalentry

    left join {{ ref('stg_d365__ledger_journal_trans') }} as ljt
        on gje.subledgervoucher = ljt.voucher and glae.ledgerdimension = ljt.ledgerdimension

    left join {{ ref('stg_d365__vend_invoice_jour') }} as vij
        on ljt.voucher = vij.ledgervoucher

    left join {{ ref('stg_d365__ledger_journal_table') }} as ljta
        on ljt.journalnum = ljta.journalnum

    left join {{ ref('int_d365__main_account_table') }} as mac
        on glae.mainaccount = mac.recid

    left join {{ ref('stg_d365__dimension_attribute_value_combination') }} as avc
        on ljt.ledgerdimension = avc.recid

    left join {{ ref('int_d365__vendor_account_name') }} as van
        on vij.invoiceaccount = van.vendor_id

    left join {{ ref('int_d365__posting_type') }} as pt
        on pt.enum_value = postingtype

    where main_account_id in ('525000', '525010', '526210', '530000', '530030',
                              '603110', '603300', '604000', '604010', '604020',
                              '604030', '604040', '605600',
                              '150020', '180410', '184010', '525020')

)

select * from general_journal_entries_it_costs
