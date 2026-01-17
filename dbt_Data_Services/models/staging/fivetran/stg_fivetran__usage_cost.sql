with source as (

    select * from {{ source('fivetran', 'usage_cost') }}

),

renamed as (

    select
        measured_month,
        destination_id,
        _fivetran_synced,
        round(amount) as cost

    from source

)

select * from renamed
