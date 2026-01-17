with source as (

    select {{ convert_columns('fishtalk', 'pricetable') }}
    from {{ source('fishtalk', 'pricetable') }}
),

renamed as (

    select
        pricetableid,
        tablename,
        currencyid,
        description,
        speciesid,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, 'false') = 'false'
