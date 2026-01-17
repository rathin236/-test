with

source as (

    select * from {{ source('bioln_dbo', 'ttccom100600') }}

),

filtered as (

    select * from source
    where coalesce(_fivetran_deleted, false) = false

),

renamed as (

    select

        t_bpid as customer_bp_id,
        t_nama as customer_name

    from filtered
)

select * from renamed
