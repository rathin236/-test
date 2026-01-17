with

source as (

    select {{ convert_columns('fishtalk', 'planninggroups') }}
    from {{ source('fishtalk', 'planninggroups') }}

),

renamed as (

    select
        active,
        textid,
        defaulttext,
        planninggroupsid,
        systemdelivered,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, 'FALSE') = 'FALSE'
