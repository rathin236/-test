{{ config(materialized='view') }}

with source as (
    select *
    from {{ source('finops_synapse', 'inventsettlement') }}
),

renamed as (
    select
        id,
        sink_created_on,
        sink_modified_on,
        balancesheetposting,
        cancelled,
        inventtranscurrency_ru,
        operationsposting,
        posted,
        settlemodel,
        settletype,
        sysdatastatecode,
        balancesheetledgerdimension,
        costamountadjustment,
        costamountsettled,
        defaultdimension,
        inventtransid,
        itemgroupid,
        itemid,
        markupcode_ru,
        operationsledgerdimension,
        pdscwsettled,
        qtysettled,
        settletransid,
        transbegintime,
        transdate,
        transrecid,
        vendaccountmarkup_ru,
        vendinvoiceidmarkup_ru,
        voucher,
        itmcosttransrecid,
        itmcosttypeid,
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
