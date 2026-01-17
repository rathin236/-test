with

source as (

    select * from {{ source('erequester_dbo', 'routingnode') }}

),

renamed as (

    select
        nodeid,
        argsdisp,
        sequenceid,
        statusdate,
        statususerid,
        sequence,
        statusid,
        typeid,
        ruleid,
        _fivetran_deleted,
        _fivetran_synced

    from source
    where coalesce(_fivetran_deleted, 'false') = 'false'

)

select * from renamed
