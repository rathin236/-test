with source as (

    select * from {{ source('northscope', 'erpx_imitemattributes') }}

),

renamed as (

    select
        attributesk,
        itemattributesk,
        attributevalue,
        itemsk,
        itemclasssk,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
