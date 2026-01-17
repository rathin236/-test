with source as (

    select * from {{ source('fishtalk', 'publicstatusvalues') }}

),

renamed as (

    select
        statustime,
        statustype,
        harvestcount,
        inputcount,
        inputbiomasskg,
        lostinsamplescount,
        reasonfornotcheckingmortality,
        currentcount,
        harvestbiomasskg,
        calcfeedamountkg,
        closingdeviationcount,
        cullingcount,
        temperature,
        atu,
        isfasting,
        cullingbiomass,
        salesbiomasskg,
        harvestdiscardscount,
        closingdeviationbiomasskg,
        salescount,
        deviationbiomasskg,
        mortalitybiomasskg,
        volume,
        feedamountkg,
        deviationcount,
        currentbiomasskg,
        circumference,
        escapebiomasskg,
        depth,
        harvestdiscardsbiomasskg,
        escapecount,
        lostinspawningcount,
        reasonfornotfeeding,
        mortalitycount,
        lostinspawningbiomasskg,
        lostinsamplesbiomasskg,
        _fivetran_deleted,
        _fivetran_synced,
        trim(statusid) as statusid,
        trim(populationid) as populationid

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
