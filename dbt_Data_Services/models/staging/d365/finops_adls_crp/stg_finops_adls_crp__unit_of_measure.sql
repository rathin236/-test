with

source as (

    select * from {{ source('finops_adls_crp', 'unitofmeasure') }}

),

renamed as (

    select
        recid,
        _sys_row_id,
        data_lake_modified_date_time,
        decimalprecision,
        symbol,
        systemofunits,
        unitofmeasureclass,
        partition,
        recversion,
        modifieddatetime,
        modifiedby,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
