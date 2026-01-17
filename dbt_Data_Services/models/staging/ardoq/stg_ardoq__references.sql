with

source as (

    select * from {{ source('ardoq', 'references') }}

),

renamed as (

    select
        json_data,
        transactionid,
        create_date,
        modified_date,
        _fivetran_synced,
        _fivetran_batch,
        _fivetran_index

    from source

)

select * from renamed
