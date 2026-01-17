with

source as (

    select {{ convert_columns('northscope', 'erpx_sofreightterms') }}
    from {{ source('northscope', 'erpx_sofreightterms') }}

),

renamed as (

    select
        freighttermssk,
        name,
        lastuser,
        lastupdated,
        inactive,
        description,
        dataentitycompanysk,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, 'FALSE') = 'FALSE'
