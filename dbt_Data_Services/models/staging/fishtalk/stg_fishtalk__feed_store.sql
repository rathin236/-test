with source as (

    select * from {{ source('fishtalk', 'feedstore') }}

),

renamed as (

    select
        name,
        active,
        feedstoretypeid,
        capacity,
        _fivetran_deleted,
        _fivetran_synced,
        trim(orgunitid) as orgunitid,
        trim(feedstoreid) as feedstoreid

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
