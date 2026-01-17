with ns_sp as (
    select distinct
        spp.salespersonname as salespersons_name,
        arc.createddatetime as create_date,
        'northscope' as sourcesystem,
        trim(arc.customerid) as invoicecustomer_number,
        case
            when
                row_number()
                    over (
                        partition by trim(arc.customerid)
                        order by arc.createddatetime desc
                    )
                = 1
                then 1
            else 0
        end as flag_most_recent

    from {{ ref('stg_northscope__erpx_ar_customer_address') }} as cad

    left join {{ ref('stg_northscope__erpx_ar_customer') }} as arc
        on trim(arc.customersk) = trim(cad.customersk)

    left join {{ ref('stg_northscope__erpx_so_salesperson') }} as spp
        on trim(cad.salespersonsk) = trim(spp.salespersonsk)

    where
        arc.customerid is not null
        and spp.isinactive = false
)

select * from ns_sp
