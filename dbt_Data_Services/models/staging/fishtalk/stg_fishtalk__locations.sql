with source as (

    select * from {{ source('fishtalk', 'locations') }}

),

renamed as (

    select
        name,
        metresabovesea,
        longitude,
        latitude,
        address,
        _fivetran_deleted,
        _fivetran_synced,
        trim(locationid) as locationid,
        trim(countyid) as countyid,
        trim(nationid) as nationid

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
