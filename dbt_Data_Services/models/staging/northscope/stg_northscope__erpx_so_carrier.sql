with source as (

    select * from {{ source('northscope', 'erpx_socarrier') }}

),

renamed as (

    select
        description,
        dataentitycompanysk,
        hostsystemlink,
        createdby,
        carriersk,
        email,
        createddatetime,
        isinactive,
        carriercode,
        carriername,
        phone,
        fax,
        linkedtovendorsk,
        isvisibletologistics,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
