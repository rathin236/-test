with

source as (

    select * from {{ source('concur', 'expense_type') }}

),

renamed as (

    select
        policy_id,
        id,
        name,
        expense_code,
        _fivetran_synced

    from source

)

select * from renamed
