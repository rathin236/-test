with

source as (

    select * from {{ source('finops_adls_crp', 'invent_item_group_item') }}

),

renamed as (

    select
        recid,
        _sys_row_id,
        lsn,
        last_processed_change_date_time,
        data_lake_modified_date_time,
        itemdataareaid,
        itemgroupdataareaid,
        itemgroupid,
        itemid,
        partition,
        recversion,
        modifieddatetime,
        modifiedby,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
