with

source as (

    select * from {{ source('northscope_sb1', 'erpx_soorderstatus') }}

),

renamed as (

    select
        orderstatussk,
        orderstatusname,
        sequence,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
