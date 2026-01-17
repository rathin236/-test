with ar as (
    select * from {{ ref('int_d365__account_recievables') }}
),

enum as (
    select 
        enumvalue,
        enumid,
        enumvaluename,
        enumvaluelabel
    from {{ ref('stg_d365__fds_enum_table') }}
    where enumid = 2715
),

final as (
    select 
        ar.recid as RecID,
        ar.accountnum as customer_number,
        ar.amountcur,
        ar.amountmst,
        ar.closed,
        ar.currencycode,
        ar.custexchadjustmentrealized,
        ar.custexchadjustmentunrealized,
        ar.trans_status,
        ar.days_outstanding,
        cast(ar.transdate as date) as transaction_date,
        cast(ar.documentdate as date) as documentdate,
        ar.documenttransdate,
        ar.duedate,
        ar.document_group,
        ar.voucher,
        ar.voucher_type,
        enum.enumvaluelabel as transaction_type
    
    from ar
    left join enum on enum.enumvalue = ar.transtype

)

select * from final