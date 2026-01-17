with public_mortality_status as (
    select * from {{ ref('stg_fishtalk__public_mortality_status') }}
),

mortality_status_values_v2 as (
    select

        populationid,
        mortalitycauseid,
        statustype,
        statustime,
        mortalitycount,
        mortalitybiomasskg,
        case
        statustype
            when 2
                then dateadd('day', 1, statustime::date)
            else statustime::date
        end as statusdate

    from public_mortality_status
    where statustime between dateadd('year', -3, current_date()) and current_date()

)

select * from mortality_status_values_v2
