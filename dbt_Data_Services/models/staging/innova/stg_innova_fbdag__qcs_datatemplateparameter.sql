with

source as (

    select * from {{ source('innova_fbdag', 'qcs_datatemplateparameter') }}

),

renamed as (

    select
        id,
        name,
        deviceparamid,
        active,
        filter,
        unit,
        basename,
        template,
        scaling,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
