with source as (

    select * from {{ source('inspec_fbd', 'qcfbdtemperaturelogginginformation') }}

),

filtered as (

    select * from source
    where coalesce(_fivetran_deleted, false) = false

),

renamed as (

    select
        _id,
        officialtime,
        customername,
        customerordersubform_salesorder,
        formpassfail,
        picture,
        customer,
        walltime,
        status_createdby,
        frozentemperature_uom,
        statusoverridereason,
        pallet,
        status_lastmodifiedby,
        context_enterprise,
        total_score,
        temperature,
        salesorder,
        loggerid,
        approval_datetime,
        comments,
        so,
        email,
        box_20190517_13_44_32,
        producttype,
        customerordersubform_customer,
        temperatureofproduct,
        temperatures_frozen,
        context,
        approval_user,
        formid,
        loggertype,
        status_workflow,
        temperatures_fresh,
        temperatureofproduct_uom,
        temperatures_frozentemperatures_uom,
        productdescription,
        logger,
        temperatures_freshtemperature_uom,
        approval_status,
        box,
        context_plant,
        freshtemperature_uom,
        freshtemperature,
        status_lastmodified,
        frozentemperature,
        _fivetran_deleted,
        _fivetran_synced,
        date,
        time_datestring,
        date_datestring,
        time_timestring,
        date_timestring,
        time,
        time_timedatestring,
        date_timedatestring

    from filtered

)

select * from renamed
