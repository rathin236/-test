with source as (

    select {{ convert_columns('fishtalk', 'publicplanpopulation') }}
    from {{ source('fishtalk', 'publicplanpopulation') }}

),

renamed as (

    select
        planpopulationid,
        scenarioid,
        yearclass,
        projectnumber,
        starttime,
        plancontainerid,
        endtime,
        specie,
        populationname,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, 'false') = 'false'
