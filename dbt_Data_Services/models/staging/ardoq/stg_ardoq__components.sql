with

source as (

    select * from {{ source('ardoq', 'components') }}

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
