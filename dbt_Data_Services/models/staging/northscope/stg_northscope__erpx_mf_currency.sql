with

source as (

    select * from {{ source('northscope', 'erpx_mfcurrency') }}

),

renamed as (

    select
        currencydescription,
        currencyreportformatstring,
        currencysk,
        _fivetran_deleted,
        _fivetran_synced,
        upper(currencyid) as currencyid

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
