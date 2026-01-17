with

source as (

    select * from {{ source('finops_synapse', 'enumtable') }}

),

renamed as (

    select
        enumid,
        enumlabel,
        enumname,
        enumvalue,
        enumvaluename,
        enumvaluelabel,
        executionid,
        insertloaddate,
        lastupdatedate,
        recid,
        partition,
        syncstartdatetime

    from source

)

select * from renamed
