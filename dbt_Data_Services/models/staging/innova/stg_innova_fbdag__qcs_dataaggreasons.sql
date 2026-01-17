with

source as (

    select * from {{ source('innova_fbdag', 'qcs_dataaggreasons') }}

),

renamed as (

    select
        dataagg,
        programparameter,
        rework,
        reject,
        category1,
        category2,
        triggerlimits,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
