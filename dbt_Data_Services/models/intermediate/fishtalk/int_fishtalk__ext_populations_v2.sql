with populations as (
    select * from {{ ref('stg_fishtalk__populations') }}
),

ext_containers_v2 as (
    select * from {{ ref('int_fishtalk__ext_containers_v2') }}
),

subtransfers as (
    select * from {{ ref('stg_fishtalk_subtransfers') }}
),

subtransfers_lookup as (
    select sub1.sourcepopafter as popid
    from subtransfers as sub1,
        subtransfers as sub2
    where sub1.operationid = sub2.operationid
        and sub1.sourcepopafter = sub2.sourcepopbefore

    union distinct

    select sub1.sourcepopafter
    from subtransfers as sub1,
        subtransfers as sub2
    where sub1.operationid = sub2.operationid
        and sub1.sourcepopafter = sub2.destpopbefore

    union distinct

    select sub1.destpopafter
    from subtransfers as sub1,
        subtransfers as sub2
    where sub1.operationid = sub2.operationid
        and sub1.destpopafter = sub2.destpopbefore

    union distinct

    select sub1.destpopafter
    from subtransfers as sub1,
        subtransfers as sub2
    where sub1.operationid = sub2.operationid
        and sub1.destpopafter = sub2.sourcepopbefore
),

ext_populations_v2 as (
    select

        pop.populationid,
        pop.containerid,
        pop.populationname,
        pop.species as speciesid,
        pop.starttime,
        pop.endtime,
        pop.inputyear,
        pop.projectnumber::string as inputnumber,
        pop.runningnumber,
        (pop.inputyear || pop.projectnumber || '.' || repeat('0', 4 - len(pop.runningnumber)) || pop.runningnumber)::string as fishgroup,
        pop.starttime::date as startdate,
        case
        pop.endtime
            when null then null
            else dateadd(dd, 1, pop.endtime::date)
        end as enddate
    from populations as pop

    inner join ext_containers_v2 as con
        on pop.containerid = con.containerid

    where pop.populationid not in (select * from subtransfers_lookup)

)

select * from ext_populations_v2
