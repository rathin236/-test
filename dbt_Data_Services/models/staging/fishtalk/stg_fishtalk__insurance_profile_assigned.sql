with source as (

    select {{ convert_columns('fishtalk', 'insuranceprofilesassigned') }}
    from {{ source('fishtalk', 'insuranceprofilesassigned') }}

),

renamed as (

    select
        insuranceprofileid,
        orgunitid,
        startdate,
        enddate,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, 'false') = 'false'
