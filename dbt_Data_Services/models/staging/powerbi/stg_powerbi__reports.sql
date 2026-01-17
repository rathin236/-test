with

source as (

    select * from {{ source('raw_usage', 'reports') }}

),

renamed as (

    select
        _fivetran_batch,
        _fivetran_index,
        _fivetran_synced,
        create_date,
        json_data,
        transactionid,
        modified_date

    from source

)

select * from renamed
