with source as (

    select {{ convert_columns('fishtalk', 'planaction') }}
    from {{ source('fishtalk', 'planaction') }}

),

renamed as (

    select
        actionid,
        actiontype,
        planpopulationid,
        startdate,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, 'false') = 'false'
