with

source as (

    select * from {{ source('finops_adls_crp', 'invent_table_module') }}

),

renamed as (

    select
        recid,
        _sys_row_id,
        lsn,
        last_processed_change_date_time,
        data_lake_modified_date_time,
        allocatemarkup,
        enddisc,
        intercompanyblocked,
        markup,
        markupseccur_ru,
        maximumretailprice_in,
        moduletype,
        overdeliverypct,
        pdspricingprecision,
        price,
        pricedate,
        priceqty,
        priceseccur_ru,
        priceunit,
        taxitemgroupid,
        taxwithholdcalculate_th,
        taxwithholditemgroupheading_th,
        underdeliverypct,
        taxgstreliefcategory_my,
        retailinventoryavailabilitybuffer,
        partition,
        recversion,
        modifieddatetime,
        modifiedby,
        createddatetime,
        createdby,
        basepricepurchase,
        _fivetran_deleted,
        _fivetran_synced,
        trim(itemid) as itemid,
        trim(unitid) as unitid,
        upper(dataareaid) as dataareaid

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
