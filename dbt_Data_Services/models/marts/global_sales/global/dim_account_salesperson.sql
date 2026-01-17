with d365_ns as (
    select

        cust.customerid as invoicecustomer_number,
        s_per.salespersonname as "Salespersons Name",
        cust.createddatetime as "Create Date",
        'NORTHSCOPE' as sourcesystem,
        case
            when row_number() over (
                    partition by cust.customerid
                    order by cust_addr.lastupdated desc
                ) = 1
                then 1
            else 0
        end as "flag_most_recent"

    from {{ ref('stg_northscope__erpx_ar_customer_address') }} as cust_addr

    left join {{ ref('stg_northscope__erpx_ar_customer') }} as cust
        on cust_addr.customersk = cust.customersk

    left join {{ ref('stg_northscope__erpx_so_salesperson') }} as s_per
        on cust_addr.salespersonsk = s_per.salespersonsk

    where cust.customerid is not null
        and s_per.isinactive = false
),

d365_sp as (
    select * from {{ ref('dim_account_salesperson_d365') }}
),

final as (
    select
        invoicecustomer_number,
        "Salespersons Name",
        "Create Date",
        sourcesystem
    from d365_sp
    where flag_most_recent = 1

    union all

    select
        invoicecustomer_number,
        "Salespersons Name",
        "Create Date",
        sourcesystem
    from d365_ns
    where "flag_most_recent" = 1
)

select
    invoicecustomer_number,
    "Salespersons Name",
    "Create Date",
    sourcesystem
from final
