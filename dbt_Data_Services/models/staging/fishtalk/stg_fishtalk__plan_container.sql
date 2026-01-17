with

source as (

    select {{ convert_columns('fishtalk', 'plancontainer') }}
    from {{ source('fishtalk', 'plancontainer') }}

),

renamed as (

    select
        plancontainerid,
        plansiteid,
        containerid,
        planninggroupid,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, 'FALSE') = 'FALSE'
