with invoice_id as (
    select
        *,
        'D365' as sourcesystem,
        0 as sourcesystemcode
    from {{ ref('dim_invoice_d365') }}

    union all

    select
        *,
        'NORTHSCOPE' as sourcesystem,
        1 as sourcesystemcode
    from {{ ref('dim_invoice_ns') }}
),

invoice_id_date as (
    select
        md5(concat("Invoice ID", sourcesystem)) as sk_invoice_id_global,
        row_number() over (partition by md5(concat("Invoice ID", sourcesystem)) order by "Invoice ID", sourcesystem) as row_num,
        *
    from invoice_id
)

select * from invoice_id_date
where row_num = 1 and "Invoice ID" is not null
