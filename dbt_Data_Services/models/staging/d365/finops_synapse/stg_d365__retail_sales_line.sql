with

source as (

    select * from {{ source('finops_synapse', 'retailsalesline') }}

),

renamed as (

    select
        id,
        sink_created_on,
        sink_modified_on,
        ispriceoverridden,
        fulfillmentstatus,
        ispricekeyedin,
        quantitycolumnsversion,
        ispricelocked,
        priceadjustment_custom,
        sysdatastatecode,
        catalog,
        linedscamount,
        linemanualdiscountamount,
        linemanualdiscountpercentage,
        linepercentagediscount,
        listingid,
        periodicdiscount,
        periodicpercentagediscount,
        totaldiscount,
        totalpctdiscount,
        salesline,
        fulfillmentstoreid,
        inventtransid,
        returnreasoncodeid,
        originalprice,
        pickupstarttime,
        pickupendtime,
        priceoverridereasoncode,
        quantitypicked,
        quantitypacked,
        quantityinvoiced,
        infocodeid,
        information,
        subinfocodeid,
        tenderdiscount,
        tenderdiscountpercentage,
        taxexemptpriceinclusiveoriginalprice,
        taxexemptpriceinclusivereductionamount,
        quantitynotprocessed,
        quantityphysicallyreserved,
        retailproductlistlineupdateid,
        modifieddatetime,
        modifiedby,
        modifiedtransactionid,
        createddatetime,
        createdby,
        createdtransactionid,
        dataareaid,
        recversion,
        partition,
        sysrowversion,
        recid,
        tableid,
        versionnumber,
        createdon,
        modifiedon,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
