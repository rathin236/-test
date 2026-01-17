with accounts_payable as (

    select

        gle.company as company_name,
        vend.id as vendor_id,
        --vend.name as Vendor Name, 
        vend.post_code as vendor_posting_group,
        gle.document_no_ as document_number,
        gle.document_type,
        gle.g_l_account_no_ as account_number,
        gla.name as account_name,
        glac.entry_no_ as account_category_number,
        glac.description as account_category_name,
        gle.description,
        vendle.open,
        gle.reversed,
        replace(vend.name, '|', '-') as vendor_name,
        coalesce(nullif(trim(vend.currency_code), ''), 'EUR') as currency_code,
        to_char(gle.document_date, 'YYYY-MM-DD') as document_date,
        to_char(gle.posting_date, 'YYYY-MM-DD') as posting_date,
        to_char(vendle.due_date, 'YYYY-MM-DD') as invoice_due_date,
        round(gle.debit_amount, 2) - round(gle.credit_amount, 2) as amount,
        to_char(vendle.closed_at_date, 'YYYY-MM-DD') as paid_off_date,
        round(vendle.closed_by_amount, 2) as paid_amount

    from {{ ref('stg_navision__gl_entry') }} as gle

    inner join {{ ref('stg_navision__vendor') }} as vend
        on gle.source_no_ = vend.no_
        and gle.company = vend.company

    inner join {{ ref('stg_navision__vend_ledger_entry') }} as vendle
        on gle.entry_no_ = vendle.entry_no_
        and gle.company = vendle.company

    inner join {{ ref('stg_navision__gl_account') }} as gla
        on gle.g_l_account_no_ = gla.no_
        and gle.company = gla.company

    left join {{ ref('stg_navision__gl_account_category') }} as glac
        on gla.account_subcategory_entry_no_ = glac.entry_no_
        and gla.company = glac.company

    where
        trim(replace(upper(vend.name), '|', '-')) != 'DNB PURCHASE REQUEST' --Requested by Marije Siebenga

)

select * from accounts_payable
