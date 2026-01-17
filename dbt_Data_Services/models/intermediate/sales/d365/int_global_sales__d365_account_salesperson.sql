with d365_sp as (
    select distinct
        workerinfo.name as salespersons_name,
        workerinfo.createddatetime as create_date,
        'd365' as sourcesystem,
        trim(cust.accountnum) as invoicecustomer_number,
        case
            when row_number() over (partition by trim(cust.accountnum) order by workerinfo.createddatetime desc) = 1 then 1
            else 0
        end as flag_most_recent
    from {{ ref('stg_d365__cust_table') }} as cust

    left join {{ ref('stg_d365__dir_party_table') }} as custparty
        on cust.party = custparty.recid

    left join {{ ref('stg_d365__hcm_worker') }} as worker
        on cust.maincontactworker = worker.recid

    left join {{ ref('stg_d365__dir_party_table') }} as workerinfo
        on worker.person = workerinfo.recid

    where cust.accountnum is not null
)

select * from d365_sp
