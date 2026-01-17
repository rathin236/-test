with source as (

    select * from {{ source('northscope_sb1', 'erpx_mfattributeclass') }}

),

renamed as (

    select
        attributetypedefinitionsk,
        attributeclasssk,
        classdescription,
        dataentitycompanysk,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
