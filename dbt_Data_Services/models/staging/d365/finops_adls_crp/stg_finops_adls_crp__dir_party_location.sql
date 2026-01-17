with

source as (

    select * from {{ source('finops_adls_crp', 'dir_party_location') }}

),

renamed as (

    select
        recid,
        _sys_row_id,
        lsn,
        last_processed_change_date_time,
        data_lake_modified_date_time,
        islocationowner,
        ispostaladdress,
        isprimary,
        isprimarytaxregistration,
        isprivate,
        isrolebusiness,
        isroledelivery,
        isrolehome,
        isroleinvoice,
        location,
        party,
        postaladdressroles,
        partition,
        recversion,
        modifiedby,
        modifieddatetime,
        _fivetran_deleted,
        _fivetran_synced,
        assignmentdate,
        assignmentdatetzid

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
