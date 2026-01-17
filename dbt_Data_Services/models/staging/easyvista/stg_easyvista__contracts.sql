with

source as (

    select * from {{ source('easyvista', 'contracts') }}

),

renamed as (

    select
        json_data,
        transactionid,
        insert_date,
        modified_from,
        modified_to,
        status

    from source

)

select * from renamed
