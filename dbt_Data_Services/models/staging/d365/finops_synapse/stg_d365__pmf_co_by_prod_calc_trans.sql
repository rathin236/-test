with

source as (

    select * from {{ source('finops_synapse', 'pmfcobyprodcalctrans') }}

),

renamed as (

    select
        id,
        sink_created_on,
        sink_modified_on,
        bom,
        calctype,
        consumptype,
        costpricemodelused,
        derivedreference,
        pmfcostallocation,
        production,
        salespricemodelused,
        transreftype,
        sysdatastatecode,
        calcgroupid,
        collectreflevel,
        collectrefprodid,
        consumpconstant,
        consumpvariable,
        costamount,
        costgroupid,
        costmarkup,
        derivedrefnum,
        idrefrecid,
        idreftableid,
        inventdimid,
        inventdimstr,
        linenum,
        numofseries,
        oprid,
        oprnum,
        pmfcostallocationpct,
        pmfidrefcobyrecid,
        pmfoverheadpct,
        pricediscqty,
        qty,
        realconsump,
        realcostadjustment,
        realcostamount,
        realqty,
        resource,
        salesamount,
        salesmarkup,
        transdate,
        transrefid,
        unitid,
        vendid,
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
