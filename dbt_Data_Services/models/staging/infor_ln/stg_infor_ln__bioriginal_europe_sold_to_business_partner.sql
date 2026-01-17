with

source as (

    select * from {{ source('bioln_dbo', 'ttccom110200') }}

),

filtered as (

    select * from source
    where coalesce(_fivetran_deleted, false) = false

),

renamed as (

    select

        t_osrp as sales_rep_id,
        t_crep as customer_service_rep_id,
        t_ofbp as customer_bp_id

    from filtered
)

select * from renamed
