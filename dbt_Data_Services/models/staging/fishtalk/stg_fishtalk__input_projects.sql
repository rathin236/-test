with

source as (

    select {{ convert_columns('fishtalk', 'inputprojects') }}
    from {{ source('fishtalk', 'inputprojects') }}

),

renamed as (

    select
        inputprojectid,
        active,
        siteid,
        projectnumber,
        projectnumberold,
        yearclass,
        species,
        projectname,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, 'FALSE') = 'FALSE'
