with source as (

    select {{ convert_columns('fishtalk', 'fishgrouphistory') }}
    from {{ source('fishtalk', 'fishgrouphistory') }}

),

renamed as (

    select
        inputprojectid,
        populationid,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, 'FALSE') = 'FALSE'
