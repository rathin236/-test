with ext_mortality_status_values_v2 as (
    select * from {{ ref('int_fishtalk__ext_mortality_status_values_v2') }}
),

ext_daily_mortality_status_values_v2 as (
    select

        endstatus.populationid,
        endstatus.mortalitycauseid,
        dateadd('day', -1, endstatus.statusdate) as statusdate,
        case
            when startstatus.mortalitycount is null and endstatus.statustype = 0 then 0
            when startstatus.mortalitycount is null and endstatus.statustype in (1, 2) then endstatus.mortalitycount
            else endstatus.mortalitycount - startstatus.mortalitycount
        end as mortalitycount,
        case
            when startstatus.mortalitybiomasskg is null and endstatus.statustype = 0 then 0
            when startstatus.mortalitybiomasskg is null and endstatus.statustype in (1, 2) then endstatus.mortalitybiomasskg
            else endstatus.mortalitybiomasskg - startstatus.mortalitybiomasskg
        end as mortalitybiomasskg

    from ext_mortality_status_values_v2 as startstatus

    left join ext_mortality_status_values_v2 as endstatus
        on startstatus.populationid = endstatus.populationid
            and startstatus.mortalitycauseid = endstatus.mortalitycauseid
            and startstatus.statusdate = dateadd('day', -1, endstatus.statusdate)

)

select * from ext_daily_mortality_status_values_v2
