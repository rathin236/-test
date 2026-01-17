with

source as (

    select * from {{ source('bioln_dbo', 'ttccom001100') }}

),

filtered as (

    select * from source
    where coalesce(_fivetran_deleted, false) = false

),

renamed as (

    select

        t_emno as sales_rep_id,
        t_nama as sales_rep_name

    from filtered
)

select * from renamed
