with art as (

    select * from {{ ref('int_accounts_receivable_gl_transactions') }}

)

select
	art.company_name,
	art.customer_id,
	art.customer_posting_group,
	art.document_number,
	art.document_type,
	art.account_number,
	art.account_name,
	art.account_category_number,
	art.account_category_name,
	art.description,
	art.open,
	art.reversed,
	art.customer_name,
	art.currency_code,
	art.document_date,
	art.posting_date,
	art.invoice_due_date,
	art.amount,
	art.paid_off_date,
	art.paid_amount,
	{{ dbt_utils.generate_surrogate_key([
        'art.DOCUMENT_NUMBER',
        'row_number() over (
            partition by 
                art.DOCUMENT_NUMBER 
            order by art.DOCUMENT_NUMBER
        )']) }} as document_number_sequence_sk
from art
where art.open = 0

and (art.paid_off_date >= add_months(date_trunc('MONTH', current_date), -1)
      and art.paid_off_date < date_trunc('MONTH', current_date))
order by art.paid_off_date asc

/*Historic data*/
/*
and ar.paid_off_date >= date_trunc('year', dateadd('year', -2, current_date))
and ar.paid_off_date < current_date
order by ar.paid_off_date asc
*/
