with source as (

    select * from {{ source('fishtalk', 'subtransfers') }}

),

renamed as (

    select
        destpopafter,
        transfertype,
        sharebiomfwd,
        branchedbiomass,
        sharebiombwd,
        sourcepopafter,
        branchedcount,
        sampleset,
        sharecountfwd,
        avgweightstrategy,
        destpopbefore,
        sourcepopbefore,
        sharecountbwd,
        _fivetran_deleted,
        _fivetran_synced,
        trim(operationid) as operationid,
        trim(subtransferid) as subtransferid

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
