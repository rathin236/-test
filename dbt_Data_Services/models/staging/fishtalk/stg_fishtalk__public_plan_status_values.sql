with source as (

    select {{ convert_columns('fishtalk', 'publicplanstatusvalues') }}
    from {{ source('fishtalk', 'publicplanstatusvalues') }}

),

renamed as (

    select
        populationid,
        scenarioid,
        statustime,
        statustype,
        salesbiomasskg,
        cullingbiomass,
        inputbiomasskg,
        cullingcount,
        lostinsamplescount,
        harvestcount,
        mortalitycount,
        inputcount,
        lostinsamplesbiomasskg,
        lostinspawningbiomasskg,
        harvestdiscardscount,
        feedamountkg,
        mortalitybiomasskg,
        escapecount,
        harvestdiscardsbiomasskg,
        lostinspawningcount,
        deviationbiomasskg,
        temperature,
        escapebiomasskg,
        harvestbiomasskg,
        closingdeviationcount,
        volume,
        salescount,
        currentcount,
        deviationcount,
        calcfeedamountkg,
        currentbiomasskg,
        isfasting,
        closingdeviationbiomasskg,
        statusid,
        atu,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
