with

source as (

    select * from {{ source('northscope_sb1', 'erpx_soordertype') }}

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
