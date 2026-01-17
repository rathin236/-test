with

source as (

    select * from {{ source('bioln_dbo', 'ttcmcs062100') }}

),

filtered as (

    select * from source
    where coalesce(_fivetran_deleted, false) = false

),

renamed as (

    select

        t_dsca as product_category_grouping_description,
        t_cpcl as item_product_class

    from filtered

)

select * from renamed
