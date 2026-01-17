with ext_status_values_v2 as (
    select * from {{ ref('int_fishtalk__ext_status_values_v2') }}
),

ext_daily_status_values_v2 as (
    select
        startstatus.populationid,
        startstatus.statusdate,
        startstatus.statustime,
        startstatus.statustype as starttype,
        startstatus.currentcount as startcount,
        startstatus.currentbiomasskg as startbiomasskg,
        endstatus.statusdate as enddate,
        endstatus.statustype as endtype,
        endstatus.currentcount as endcount,
        endstatus.currentbiomasskg as endbiomasskg,
        endstatus.isfasting,
        endstatus.reasonfornotfeeding,
        endstatus.reasonfornotcheckingmortality,
        endstatus.volume,
        endstatus.feedamountkg - startstatus.feedamountkg as feedusekg,
        endstatus.mortalitycount - startstatus.mortalitycount as mortalitycount,
        endstatus.mortalitybiomasskg - startstatus.mortalitybiomasskg as mortalitykg,
        endstatus.escapecount - startstatus.escapecount as escapecount,
        endstatus.escapebiomasskg - startstatus.escapebiomasskg as escapekg,
        endstatus.cullingcount - startstatus.cullingcount as cullingcount,
        case
            when endstatus.statustype = 2
                and endstatus.cullingcount != 0
                and endstatus.cullingbiomasskg = 0
                and startstatus.currentcount != 0
                then (
                    startstatus.currentbiomasskg / startstatus.currentcount
                ) * endstatus.cullingcount - startstatus.cullingbiomasskg
            else endstatus.cullingbiomasskg - startstatus.cullingbiomasskg
        end as cullingkg,
        endstatus.lostinsamplescount - startstatus.lostinsamplescount as lostinsamplescount,
        endstatus.lostinsamplesbiomasskg - startstatus.lostinsamplesbiomasskg as lostinsampleskg,
        endstatus.lostinspawningcount - startstatus.lostinspawningcount as lostinspawningcount,
        endstatus.lostinspawningbiomasskg - startstatus.lostinspawningbiomasskg as lostinspawningkg,
        endstatus.inputcount - startstatus.inputcount as inputcount,
        endstatus.inputbiomasskg - startstatus.inputbiomasskg as inputkg,
        endstatus.harvestcount - startstatus.harvestcount as harvestcount,
        endstatus.harvestbiomasskg - startstatus.harvestbiomasskg as harvestkg,
        endstatus.salescount - startstatus.salescount as salescount,
        endstatus.salesbiomasskg - startstatus.salesbiomasskg as saleskg,
        endstatus.deviationcount - startstatus.deviationcount as deviationcount,
        endstatus.deviationbiomasskg - startstatus.deviationbiomasskg as deviationkg,
        endstatus.harvestdiscardscount - startstatus.harvestdiscardscount as harvestdiscardscount,
        endstatus.harvestdiscardsbiomasskg - startstatus.harvestdiscardsbiomasskg as harvestdiscardskg,
        ((
            (endstatus.currentbiomasskg - startstatus.currentbiomasskg)
            - (endstatus.inputbiomasskg - startstatus.inputbiomasskg)
        )
        + (endstatus.harvestbiomasskg - startstatus.harvestbiomasskg))
        + (endstatus.salesbiomasskg - startstatus.salesbiomasskg) as growthkg,
        (endstatus.currentbiomasskg - startstatus.currentbiomasskg)
        - (endstatus.inputbiomasskg - startstatus.inputbiomasskg)
        + (endstatus.harvestbiomasskg - startstatus.harvestbiomasskg)
        + (endstatus.salesbiomasskg - startstatus.salesbiomasskg)
        + (endstatus.mortalitybiomasskg - startstatus.mortalitybiomasskg)
        + (endstatus.cullingbiomasskg - startstatus.cullingbiomasskg)
        + (endstatus.escapebiomasskg - startstatus.escapebiomasskg)
        + (endstatus.lostinsamplesbiomasskg - startstatus.lostinsamplesbiomasskg)
        + (endstatus.lostinspawningbiomasskg - startstatus.lostinspawningbiomasskg) as grossgrowthkg,
        endstatus.calcfeedamountkg - startstatus.calcfeedamountkg as calcfeedamountkg,
        endstatus.atu - startstatus.atu as atu,
        case
            when (endstatus.statustime = startstatus.statustime) then endstatus.temperature
            when (endstatus.atu = startstatus.atu) then endstatus.temperature
            else (endstatus.atu - startstatus.atu) / datediff(minute, endstatus.statustime::timestamp_ntz, startstatus.statustime::timestamp_ntz)
        end as avgtemp,
        (endstatus.currentbiomasskg - startstatus.currentbiomasskg)
        - (endstatus.inputbiomasskg - startstatus.inputbiomasskg)
        + (endstatus.harvestbiomasskg - startstatus.harvestbiomasskg)
        + (endstatus.salesbiomasskg - startstatus.salesbiomasskg)
        - (endstatus.harvestdiscardsbiomasskg - startstatus.harvestdiscardsbiomasskg) as growthkgexdiscards
    from ext_status_values_v2 as startstatus

    inner join ext_status_values_v2 as endstatus
        on startstatus.populationid = endstatus.populationid
            and startstatus.statusdate = dateadd(day, -1, endstatus.statusdate)

)

select * from ext_daily_status_values_v2
