with source as (

    select * from {{ source('northscope', 'erpx_sosalesperson') }}

),

renamed as (

    select
        lastupdated,
        salespersonname,
        email,
        isinactive,
        salespersonid,
        lastuser,
        dataentitycompanysk,
        salespersontypeen,
        hostsystemlink,
        _fivetran_deleted,
        _fivetran_synced,
        trim(salespersonsk) as salespersonsk

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
