with source as (

    select * from {{ source('fishtalk', 'organisationunitgroupings') }}

),

renamed as (

    select
        colour,
        sortindex,
        parent,
        name,
        _fivetran_deleted,
        _fivetran_synced,
        trim(groupid) as groupid

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
