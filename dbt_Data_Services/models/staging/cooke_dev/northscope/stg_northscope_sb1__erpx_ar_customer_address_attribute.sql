with source as (

    select * from {{ source('northscope_sb1', 'erpx_arcustomeraddressattribute') }}

),

renamed as (

    select
        lastupdated,
        attributesk,
        attributevalue,
        lastuser,
        dataentitycompanysk,
        customeraddressattributesk,
        customeraddresssk,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
