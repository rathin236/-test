with

source as (

    select * from {{ source('bioln_dbo', 'ttcmcs044600') }}

),

filtered as (

    select * from source
    where coalesce(_fivetran_deleted, false) = false

),

renamed as (

    select

        t_dsca as product_category_description,
        t_csgp as id

    from filtered

)

select * from renamed
