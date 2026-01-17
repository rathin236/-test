with

source as (

    select {{ convert_columns('fishtalk', 'harvestcauses') }}
    from {{ source('fishtalk', 'harvestcauses') }}

),

renamed as (

    select
        harvestcausesid,
        systemdelivered,
        textid,
        active,
        defaulttext,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, 'FALSE') = 'FALSE'
