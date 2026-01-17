with accountingdocument_customerid as (

    select distinct
        mandt,
        belnr,
        bukrs,
        gjahr,
        kunnr,
        koart,
        shkzg
    from {{ ref('stg_sap_sladegorton__bseg') }}
    where koart = 'D' and gjahr > '2021'

),

customermaster as (

    select * from {{ ref('stg_sap_sladegorton__kna1') }}

),

accountingdocument_vendorid as (

    select distinct
        mandt,
        belnr,
        bukrs,
        gjahr,
        lifnr,
        koart,
        shkzg
    from {{ ref('stg_sap_sladegorton__bseg') }}
    where koart = 'K' and gjahr > '2021'

),

vendormaster as (

    select * from {{ ref('stg_sap_sladegorton__lfa1') }}

),

accountingdocument_customermaster as (

    select

        cid.mandt,
        cid.belnr,
        cid.bukrs,
        cid.gjahr,
        cid.kunnr as omid,
        cid.koart,
        cid.shkzg,
        cma.name1

    from accountingdocument_customerid as cid
    left join customermaster as cma
        on cid.mandt = cma.mandt and cid.kunnr = cma.kunnr

),

accountingdocument_vendormaster as (

    select

        vid.mandt,
        vid.belnr,
        vid.bukrs,
        vid.gjahr,
        vid.lifnr as omid,
        vid.koart,
        vid.shkzg,
        vma.name1

    from accountingdocument_vendorid as vid
    left join vendormaster as vma
        on vid.mandt = vma.mandt and vid.lifnr = vma.lifnr

),

unioned_masterrecords as (

    select * from accountingdocument_customermaster

    union all

    select * from accountingdocument_vendormaster

),

final as (

    select
        *,
        row_number() over (partition by belnr order by belnr) as row_num
    from unioned_masterrecords

)

select * from final
