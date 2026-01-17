with freight_terms as (
    select *
    from {{ ref('stg_northscope__erpx_so_freight_terms') }}
)

select * from freight_terms
