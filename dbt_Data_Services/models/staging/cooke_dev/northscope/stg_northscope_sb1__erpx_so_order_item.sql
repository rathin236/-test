with source as (

    select * from {{ source('northscope_sb1', 'erpx_soorderitem') }}

),

renamed as (

    select
        inventoryweight,
        lastupdated,
        orderedunits,
        inventoryunits,
        discountmethodsk,
        scheduledshipdate,
        createdby,
        pricelistprice,
        contractitemsk,
        createddate,
        discountrate,
        unitsuomsk,
        imitemactualcost,
        originitemtypeen,
        priceoverridedate,
        lastuser,
        origintransactionitemsk,
        isautoaddeditem,
        orderedamount,
        itemsalesinvoicedescription,
        returnisdamaged,
        orderitemactualcost,
        iscontractline,
        itemsort,
        allocatedamount,
        priceoverrideby,
        itemprice,
        discountamount,
        invoicedamount,
        hostlinenumber,
        orderedweight,
        allocatedweight,
        allocatedunits,
        priceoptionsk,
        _fivetran_deleted,
        _fivetran_synced,
        trim(orderheadersk) as orderheadersk,
        trim(sitesk) as sitesk,
        trim(weightuomsk) as weightuomsk,
        trim(contractheadersk) as contractheadersk,
        trim(originorderitemsk) as originorderitemsk,
        trim(itemsk) as itemsk,
        trim(orderstatussk) as orderstatussk,
        trim(dataentitycompanysk) as dataentitycompanysk,
        trim(carriersk) as carriersk,
        trim(pricelistheadersk) as pricelistheadersk,
        trim(itemtypesk) as itemtypesk,
        trim(imitemactualcostuomsk) as imitemactualcostuomsk,
        trim(orderitemsk) as orderitemsk

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
