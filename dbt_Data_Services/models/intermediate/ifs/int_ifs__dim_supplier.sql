with supplier_info as (
    select * from {{ ref('stg_ifs__supplier_info_tab') }}
),

supplier_address as (
    select
        *,
        count(*) over (partition by supplier_id order by supplier_id, address_id) as cnt
    from {{ ref('stg_ifs__supplier_info_address_tab') }}
)

select
    supplier_info.supplier_id,
    supplier_info.party,
    supplier_info.association_no,
    supplier_info.creation_date,
    supplier_info.name as suppier_name,
    supplier_info.party_type,
    supplier_address.address1 as address_1,
    supplier_address.address2 as address_2,
    supplier_address.city,
    supplier_address.state,
    supplier_address.zip_code,
    supplier_address.country,
    supplier_address.address as full_address

from supplier_info

left join supplier_address
    on supplier_info.supplier_id = supplier_address.supplier_id

where supplier_address.cnt = 1

group by all
