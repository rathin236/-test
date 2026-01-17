with apay as (

    select * from {{ ref('int_accounts_payable_gl_transactions') }}

)

select
	apay.company_name,
	apay.vendor_id,
	apay.vendor_posting_group,
	apay.document_number,
	apay.document_type,
	apay.account_number,
	apay.account_name,
	apay.account_category_number,
	apay.account_category_name,
	apay.description,
	apay.open,
	apay.reversed,
	apay.vendor_name,
	apay.currency_code,
	apay.document_date,
	apay.posting_date,
	apay.invoice_due_date,
	apay.amount,
	apay.paid_off_date,
	apay.paid_amount,
	{{ dbt_utils.generate_surrogate_key([
        'apay.document_number',
        'row_number() over (
            partition by 
                apay.document_number 
            order by apay.document_number
        )']) }} as document_number_sequence_sk
from apay
where apay.open = 1
