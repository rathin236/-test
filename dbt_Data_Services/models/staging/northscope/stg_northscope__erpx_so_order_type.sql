with source as (

    select * from {{ source('northscope', 'erpx_soordertype') }}

),

renamed as (

    select
        isenabled,
        ordertypesk,
        sort,
        ordertypename,
        hostordertypesk,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
