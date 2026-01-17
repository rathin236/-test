with source as (

    select * from {{ source('fishtalk', 'mortalitycauses') }}

),

renamed as (

    select
        systemdelivered,
        active,
        diagnosiscode,
        _fivetran_deleted,
        _fivetran_synced,
        trim(defaulttext) as defaulttext,
        trim(textid::number) as textid,
        trim(mortalitycausegroupid) as mortalitycausegroupid,
        trim(mortalitycategoryid) as mortalitycategoryid,
        trim(mortalitycausesid) as mortalitycausesid

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
