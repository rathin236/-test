with source as (

    select {{ convert_columns('fishtalk', 'pricetabledetails') }}
    from {{ source('fishtalk', 'pricetabledetails') }}

),

renamed as (

    select
        fromweight,
        pricetableid,
        toweight,
        priceperfish,
        priceperkg,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, 'false') = 'false'
