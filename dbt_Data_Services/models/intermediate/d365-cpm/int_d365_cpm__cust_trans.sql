-- models/ct.sql

{{ config(materialized='table') }}

with cust_trans as (
    select distinct
        accountnum,
        invoice,
        voucher,
        createdtransactionid,
        amountmst
    from {{ ref('stg_d365__cust_trans') }}
),

final as (
    select
        accountnum,
        invoice,
        voucher,
        createdtransactionid,
        amountmst,
        count(accountnum) over (partition by voucher) as repetition_count,
        row_number() over (partition by voucher order by voucher) as row_num
    from cust_trans
)

select * from final
