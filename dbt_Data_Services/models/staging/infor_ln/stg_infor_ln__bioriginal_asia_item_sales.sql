with

source as (

    select * from {{ source('bioln_dbo', 'ttdisa001600') }}

),

filtered as (

    select * from source
    where coalesce(_fivetran_deleted, false) = false

),

renamed as (

    select

        t_item as item_number,
        t_csgs as item_product_category_description

    from filtered
)

select * from renamed
