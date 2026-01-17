with kcs_transactions as (
    select *
    from {{ ref("int_kcs__gl_transactions") }}
),

tns_transactions as (
    select *
    from {{ ref("int_tns__gl_transactions") }}
),

cpqln_transactions as (
    select *
    from {{ ref('int_cpqln__gl_transactions') }}
),

tfc_transactions as (
    select *
    from {{ ref('int_tfc__gl_transactions') }}
),

all_transactions as (
    select * from tns_transactions
    union all
    select * from kcs_transactions
    union all
    select * from cpqln_transactions
    union all
    select * from tfc_transactions
)

select * from all_transactions
where document_date > '2019-12-31'
