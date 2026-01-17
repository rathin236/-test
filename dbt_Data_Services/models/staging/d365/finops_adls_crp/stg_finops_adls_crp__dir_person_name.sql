with

source as (

    select * from {{ source('finops_adls_crp', 'dir_person_name') }}

),

renamed as (

    select
        recid,
        _sys_row_id,
        data_lake_modified_date_time,
        trim(firstname)::string as empfirstname,
        lastnameprefix,
        trim(lastname)::string as emplastname,
        middlename,
        person,
        validfrom,
        validfromtzid,
        validto,
        validtotzid,
        partition,
        recversion,
        modifiedby,
        createdby,
        _fivetran_deleted,
        _fivetran_synced,
        last_processed_change_date_time

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
