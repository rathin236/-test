with

source as (

    select * from {{ source('metaviewer_dbo', 'mvpm_apmodel_porecdata') }}

),

renamed as (

    select
        id,
        refdocid,
        ponumber,
        transactiontype,
        description,
        rowindex,
        taxdetailid,
        creditamount,
        sys_lastchangedate,
        creator,
        shprcplnno,
        variance,
        receiptlinenumber,
        taxamount,
        itemnumber,
        extendedprice,
        sys_createdate,
        taxrate,
        relatedlink,
        receiptnumber,
        revalueinventory,
        locationcode,
        quantity,
        accountnumber,
        landedcost,
        uom,
        distref,
        unitprice,
        noninventory,
        itemtaxschedule,
        polinenumber,
        quantityordered,
        sitetaxschedule,
        originalunitprice,
        debitamount,
        quantityavailable,
        taxable,
        _fivetran_deleted,
        _fivetran_synced

    from source
    where coalesce(_fivetran_deleted, 'false') = 'false'

)

select * from renamed
