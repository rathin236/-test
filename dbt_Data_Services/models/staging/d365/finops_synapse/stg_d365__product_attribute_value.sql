with

source as (

    select * from {{ source('finops_synapse', 'ecoresproductattributevalue') }}

),

renamed as (

    select
        attribute,
        executionid,
        insertloaddate,
        lastupdatedate,
        partition,
        product,
        syncstartdatetime,
        recid,
        value

    from source

)

select * from renamed
