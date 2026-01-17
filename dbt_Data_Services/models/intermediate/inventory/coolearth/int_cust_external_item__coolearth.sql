with ns_cust_favorite as (
    select
        customerfavoritesk,
        itemsk,
        dataentitycompanysk,
        customerentitysk,
        customeritemid,
        customeritemdescription
    from {{ ref('stg_northscope__erpx_ar_customer_favorite') }}
    where dataentitycompanysk = 1
),

ns_item as (
    select
        itemsk,
        itemid
    from {{ ref('stg_northscope__erpx_im_item') }}
),

ns_cust_address as (
    select
        customeraddresssk,
        addressid,
        city,
        state,
        addressname,
        customersk
    from {{ ref('stg_northscope__erpx_ar_customer_address') }}
),

ns_data_entity_company as (
    select
        dataentitycompanysk,
        companyid
    from {{ ref('stg_northscope__erpx_mf_data_entity_company') }}
),

ns_customer as (
    select
        customername,
        customersk
    from {{ ref('stg_northscope__erpx_ar_customer') }}
),

ns_cust_external_item as (
    select
        'NORTHSCOPE' as sourcesystem,
        ns_cust_fav.customerfavoritesk,
        ns_item.itemid,
        ns_comp.companyid,
        ns_cust_fav.customeritemid,
        ns_cust_fav.customeritemdescription,
        ns_cust.customername,
        concat(
            coalesce(trim(ns_cust_addr.addressid), ' '),
            ' - ',
            coalesce(trim(ns_cust_addr.city), ' '),
            ', ',
            coalesce(trim(ns_cust_addr.state), ' '),
            ' - ',
            coalesce(trim(ns_cust_addr.addressname), ' ')
        ) as "Customer Relation or Address",
        md5(concat(trim(ns_item.itemid), sourcesystem)) as sk_item_global,
        md5(concat(sourcesystem, trim(ns_comp.companyid),
         ns_item.itemid, ns_cust_fav.customerfavoritesk)) as cust_external_item_pk
    from ns_cust_favorite as ns_cust_fav

    left join ns_item
        on trim(ns_cust_fav.itemsk) = trim(ns_item.itemsk)

    inner join ns_cust_address as ns_cust_addr
        on trim(ns_cust_fav.customerentitysk) = trim(ns_cust_addr.customeraddresssk)

    inner join ns_customer as ns_cust
        on trim(ns_cust_addr.customersk) = trim(ns_cust.customersk)

    left join ns_data_entity_company as ns_comp
        on trim(ns_cust_fav.dataentitycompanysk) = trim(ns_comp.dataentitycompanysk)
),

final as (
    select
        sourcesystem,
        companyid as "Company",
        itemid as "Item ID",
        "Customer Relation or Address",
        customername as "Customer Name",
        customeritemid as "Customer External Item ID",
        customeritemdescription as "Customer External Item Description",
        sk_item_global,
        cust_external_item_pk
    from ns_cust_external_item
)

select * from final
