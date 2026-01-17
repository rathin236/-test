with

source as (

    select * from {{ source('finops_synapse', 'ecoresvalue') }}

),

renamed as (

    select
        createdtransactionid,
        instancerelationtype,
        origin,
        recid,
        currencycode,
        currencyvalue,
        datetimevalue,
        floatunitofmeasure,
        floatvalue,
        intunitofmeasure,
        intvalue,
        textvalue,
        reffieldid,
        refrecid,
        reftableid,
        booleanvalue,
        partition,
        syncstartdatetime,
        executionid,
        insertloaddate,
        lastupdatedate

    from source

)

select * from renamed
