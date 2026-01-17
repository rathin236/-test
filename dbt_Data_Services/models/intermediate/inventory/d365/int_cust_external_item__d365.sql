with d365_cust_external_item as (
    select
        'D365' as sourcesystem,
        itemid,
        custvendrelation,
        externalitemid,
        externalitemtxt,
        upper(dataareaid) as "Company",
        md5(concat(trim(itemid), sourcesystem)) as sk_item_global,
        md5(concat(sourcesystem, dataareaid, itemid, custvendrelation)) as cust_external_item_pk
    from {{ ref('stg_d365__cust_vend_external_item') }}
    where moduletype = 4
),

cust_table as (
    select
        accountnum,
        party
    from {{ ref('stg_d365__cust_table') }}
),

dir_party_table as (
    select
        name,
        recid
    from {{ ref('stg_d365__dir_party_table') }}
),

cust_name as (
    select
        dir.name,
        cust.accountnum
    from cust_table as cust
    inner join dir_party_table as dir
        on cust.party = dir.recid
),

final as (
    select
        d365_cust_external_item.sourcesystem,
        d365_cust_external_item."Company",
        d365_cust_external_item.itemid as "Item ID",
        d365_cust_external_item.custvendrelation as "Customer Relation or Address",
        cust_name.name as "Customer Name",
        d365_cust_external_item.externalitemid as "Customer External Item ID",
        d365_cust_external_item.externalitemtxt as "Customer External Item Description",
        d365_cust_external_item.sk_item_global,
        d365_cust_external_item.cust_external_item_pk
    from d365_cust_external_item
    inner join cust_name
        on d365_cust_external_item.custvendrelation = cust_name.accountnum
)

select * from final
