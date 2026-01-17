with source as (

    select * from {{ source('northscope', 'erpx_arcustomerattribute') }}

),

renamed as (

    select
        dataentitycompanysk,
        attributevalue,
        customersk,
        lastuser,
        customerattributesk,
        attributesk,
        lastupdated,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
