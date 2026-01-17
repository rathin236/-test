with source as (

    select * from {{ source('northscope', 'erpx_imitemsetitems') }}

),

renamed as (

    select
        _fivetran_deleted,
        _fivetran_synced,
        itemsk,
        trim(itemsetsk) as itemsetsk

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
