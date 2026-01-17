with

source as (

    select * from {{ source('finops_adls_crp', 'eco_res_product_translation') }}

),

renamed as (

    select
        recid,
        _sys_row_id,
        lsn,
        last_processed_change_date_time,
        data_lake_modified_date_time,
        description,
        languageid,
        trim(name)::string as prodname,
        product,
        partition,
        recversion,
        modifiedby,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
