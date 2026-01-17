{{ config(materialized='table') }}

with vend_trans as (
    select distinct
        voucher,
        createdtransactionid,
        summaryaccountid,
        accountnum,
        amountmst,
        invoice
    from {{ ref('stg_d365__vend_trans') }}
),

final as (
    select
        voucher,
        createdtransactionid,
        summaryaccountid,
        accountnum,
        amountmst,
        invoice,
        count(accountnum) over (partition by voucher) as repetition_count,
        row_number() over (partition by voucher order by voucher) as row_num
    from vend_trans
)

select * from final
