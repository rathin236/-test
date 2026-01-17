with source as (

    select * from {{ source('fishtalk', 'publicmortalitystatus') }}

),

renamed as (

    select
        statustime,
        statustype,
        mortalitycount,
        mortalitybiomasskg,
        _fivetran_deleted,
        _fivetran_synced,
        trim(populationid) as populationid,
        trim(mortalitycauseid) as mortalitycauseid

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
