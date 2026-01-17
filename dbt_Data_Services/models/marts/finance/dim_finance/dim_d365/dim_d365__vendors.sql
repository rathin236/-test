with d365_vendors as (
    select
        *,
        case 
            when vendor_type = 'Trade' then 1
            when vendor_type = 'Related Party' then 2
            when vendor_type = 'Inter Company' then 3
            when vendor_type =  'SCF Vendor' then 4
        end as vendor_type_sort
    from {{ ref('int_global_ap__d365_tnsf_vendors') }}
)

select * from d365_vendors

