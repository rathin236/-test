with public_status_values as (
    select * from {{ ref('stg_fishtalk__public_status_values') }}
),

ext_status_values_v2 as (
    select

        populationid,
        statustime,
        statustype,
        currentcount,
        currentbiomasskg,
        feedamountkg,
        harvestcount,
        harvestbiomasskg,
        inputcount,
        inputbiomasskg,
        salescount,
        salesbiomasskg,
        mortalitycount,
        mortalitybiomasskg,
        cullingcount,
        cullingbiomass as cullingbiomasskg,
        lostinsamplescount,
        lostinsamplesbiomasskg,
        escapecount,
        escapebiomasskg,
        deviationcount,
        deviationbiomasskg,
        harvestdiscardscount,
        harvestdiscardsbiomasskg,
        lostinspawningcount,
        lostinspawningbiomasskg,
        closingdeviationcount,
        closingdeviationbiomasskg,
        temperature,
        calcfeedamountkg,
        atu,
        isfasting,
        volume,
        reasonfornotfeeding,
        reasonfornotcheckingmortality,
        case
        statustype
            when 2 then dateadd(dd, 1, statustime::date)
            else statustime::date
        end as statusdate

    from public_status_values

)

select * from ext_status_values_v2
