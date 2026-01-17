with source as (

    select * from {{ source('fishtalk', 'organisationrelations') }}

),

renamed as (

    select
        _fivetran_deleted,
        _fivetran_synced,
        trim(orgunitid) as orgunitid,
        trim(parentorgunitid) as parentorgunitid

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
