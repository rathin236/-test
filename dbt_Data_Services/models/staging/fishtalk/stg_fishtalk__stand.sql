with source as (

    select * from {{ source('fishtalk', 'stand') }}

),

renamed as (

    select
        name,
        _fivetran_deleted,
        _fivetran_synced,
        trim(standid) as standid,
        trim(groupid) as groupid,
        trim(orgunitid) as orgunitid

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
