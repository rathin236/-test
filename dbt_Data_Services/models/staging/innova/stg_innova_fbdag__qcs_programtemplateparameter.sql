with

source as (

    select * from {{ source('innova_fbdag', 'qcs_programtemplateparameter') }}

),

renamed as (

    select
        id,
        template,
        name,
        defaultvalue,
        reasonindex,
        scaling,
        techmaxlimit,
        type,
        unit,
        basename,
        sequence,
        techminlimit,
        filter,
        active,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
