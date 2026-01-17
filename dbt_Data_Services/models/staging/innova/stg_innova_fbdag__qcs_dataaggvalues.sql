with

source as (

    select * from {{ source('innova_fbdag', 'qcs_dataaggvalues') }}

),

renamed as (

    select
        dataagg,
        dataparameter,
        valuep2,
        max,
        value,
        min,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
