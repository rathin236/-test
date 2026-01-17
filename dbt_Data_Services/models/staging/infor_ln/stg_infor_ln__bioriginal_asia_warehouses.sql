with

source as (

    select * from {{ source('bioln_dbo', 'ttcmcs003600') }}

),

filtered as (

    select * from source
    where coalesce(_fivetran_deleted, false) = false

),

renamed as (

    select

        t_cwar as warehouse_number,
        t_typw as whs_type

    from filtered
)

select * from renamed
