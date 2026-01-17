with source as (

    select {{ convert_columns('fishtalk', 'containers') }}
    from {{ source('fishtalk', 'containers') }}

),

renamed as (

    select
        containername,
        sortindex,
        containerfeedingmethod,
        containersystemtype,
        containertype,
        _fivetran_deleted,
        _fivetran_synced,
        trim(containerid) as containerid,
        trim(orgunitid) as orgunitid,
        trim(officialid) as officialid,
        trim(groupid) as groupid,
        trim(standid) as standid

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
