with d365_vend_external_item as (
    select
        'D365' as sourcesystem,
        itemid,
        custvendrelation,
        externalitemid,
        externalitemtxt,
        upper(dataareaid) as "Company",
        md5(concat(trim(itemid), sourcesystem)) as sk_item_global,
        md5(concat(sourcesystem, dataareaid, itemid, custvendrelation)) as vend_external_item_pk
    from {{ ref('stg_d365__cust_vend_external_item') }}
    where moduletype = 3
),

vend_table as (
    select
        accountnum,
        party
    from {{ ref('stg_d365__vend_table') }}
),

dir_party_table as (
    select
        name,
        recid
    from {{ ref('stg_d365__dir_party_table') }}
),

vend_name as (
    select
        dir.name,
        vend.accountnum
    from vend_table as vend
    inner join dir_party_table as dir
        on vend.party = dir.recid
),

final as (
    select
        d365_vend_external_item.sourcesystem,
        d365_vend_external_item."Company",
        d365_vend_external_item.itemid as "Item ID",
        d365_vend_external_item.custvendrelation as "Vendor Relation",
        vend_name.name as "Vendor Name",
        d365_vend_external_item.externalitemid as "Vendor External Item ID",
        d365_vend_external_item.externalitemtxt as "Vendor External Item Description",
        d365_vend_external_item.sk_item_global,
        d365_vend_external_item.vend_external_item_pk
    from d365_vend_external_item
    inner join vend_name
        on d365_vend_external_item.custvendrelation = vend_name.accountnum
)

select *
from final
