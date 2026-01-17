with

source as (

    select {{ convert_columns('fishtalk', 'action') }}
    from {{ source('fishtalk', 'action') }}

),

renamed as (

    select
        actionid,
        actiontype,
        populationid,
        operationid,
        actionorder,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, 'FALSE') = 'FALSE'
