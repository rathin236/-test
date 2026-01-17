with source as (

    select * from {{ source('fishtalk', 'county') }}

),

renamed as (

    select
        countycode,
        defaulttext,
        _fivetran_deleted,
        _fivetran_synced,
        trim(textid) as textid,
        trim(nationid) as nationid,
        trim(countyid) as countyid

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
