with accounts_receivable as (

    select

        gle.company as company_name,
        cust.id as customer_id,
        --cust.name as Customer Name, 
        cust.post_code as customer_posting_group,
        gle.document_no_ as document_number,
        gle.document_type,
        gle.g_l_account_no_ as account_number,
        gla.name as account_name,
        glac.entry_no_ as account_category_number,
        glac.description as account_category_name,
        gle.description,
        custle.open,
        gle.reversed,
        replace(cust.name, '|', '-') as customer_name,
        coalesce(nullif(trim(cust.currency_code), ''), 'EUR') as currency_code,
        to_char(gle.document_date, 'YYYY-MM-DD') as document_date,
        to_char(gle.posting_date, 'YYYY-MM-DD') as posting_date,
        to_char(custle.due_date, 'YYYY-MM-DD') as invoice_due_date,
        round(gle.debit_amount, 2) - round(gle.credit_amount, 2) as amount,
        to_char(custle.closed_at_date, 'YYYY-MM-DD') as paid_off_date,
        round(custle.closed_by_amount, 2) as paid_amount

    from {{ ref('stg_navision__gl_entry') }} as gle

    inner join {{ ref('stg_navision__customer') }} as cust
        on gle.source_no_ = cust.no_
        and gle.company = cust.company

    inner join {{ ref('stg_navision__cust_ledger_entry') }} as custle
        on gle.entry_no_ = custle.entry_no_
        and gle.company = custle.company

    inner join {{ ref('stg_navision__gl_account') }} as gla
        on gle.g_l_account_no_ = gla.no_
        and gle.company = gla.company

    left join {{ ref('stg_navision__gl_account_category') }} as glac
        on gla.account_subcategory_entry_no_ = glac.entry_no_
        and gla.company = glac.company
)

select * from accounts_receivable
