with

source as (

    select * from {{ source('bioln_dbo', 'ttcibd001100') }}

),

filtered as (

    select * from source
    where coalesce(_fivetran_deleted, false) = false

),

renamed as (

    select

        t_item as item_number,
        t_dsca as item_description,
        t_cpcl as item_product_class

    from filtered
)

select * from renamed
