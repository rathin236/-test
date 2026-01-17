with stg_fishtalk_populations as (
    select {{ trim_columns_int('stg_fishtalk__populations') }} from {{ ref('stg_fishtalk__populations') }}
),

int_ft_containers as (
    select * from {{ ref('int_ft__cai__dim_containers') }}
),

stg_fishtalk_subtransfers as (
    select {{ trim_columns_int('stg_fishtalk_subtransfers') }} from {{ ref('stg_fishtalk_subtransfers') }}
),

subtransfers_lookup as (
    select sub1.sourcepopafter as popid
    from stg_fishtalk_subtransfers as sub1
    inner join stg_fishtalk_subtransfers as sub2
        on sub1.operationid = sub2.operationid
            and sub1.sourcepopafter = sub2.sourcepopbefore

    union distinct

    select sub1.sourcepopafter
    from stg_fishtalk_subtransfers as sub1
    inner join stg_fishtalk_subtransfers as sub2
        on sub1.operationid = sub2.operationid
            and sub1.sourcepopafter = sub2.destpopbefore

    union distinct

    select sub1.destpopafter
    from stg_fishtalk_subtransfers as sub1
    inner join stg_fishtalk_subtransfers as sub2
        on sub1.operationid = sub2.operationid
            and sub1.destpopafter = sub2.destpopbefore

    union distinct

    select sub1.destpopafter
    from stg_fishtalk_subtransfers as sub1
    inner join stg_fishtalk_subtransfers as sub2
        on sub1.operationid = sub2.operationid
            and sub1.destpopafter = sub2.sourcepopbefore
),

final as (
    select
        '00000000-0000-0000-0000-000000000001' as scenario_id,
        pop.populationid as population_id,
        pop.containerid as container_id,
        pop.populationname as population_name,
        pop.species as species_id,
        pop.starttime as start_time,
        pop.endtime as end_time,
        pop.inputyear as input_year,
        pop.projectnumber as input_number,
        pop.runningnumber as running_number,
        cast(
            cast(pop.inputyear as string)
            || cast(pop.projectnumber as string) || '.'
            || lpad(cast(pop.runningnumber as string), 4, '0')
            as string
        ) as fish_group,
        cast(pop.starttime as date) as start_date,
        case pop.endtime
            when null then null
            else dateadd(dd, 1, cast(pop.endtime as date))
        end as end_date
    from stg_fishtalk_populations as pop
    inner join int_ft_containers as cont on pop.containerid = cont.container_id
    where pop.populationid not in (
            select stl.popid
            from subtransfers_lookup as stl
        )

)

select * from final
