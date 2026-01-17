with source as (

    select * from {{ source('easyvista', 'tickets_action') }}

),

renamed as (

    select
        rfc_number,
        json_data,
        transactionid,
        insert_date,
        modified_from,
        modified_to,
        status

    from source
    where status = 'Active'
)

select * from renamed
