with companies as (
    select * from {{ ref('int_fishtalk__ext_grouped_organisation_v2') }}

    where company in ('Cold Ocean', 'Kelly Cove', 'Cooke Aqua')
),

ext_daily_status_values_v2 as (
    select * from {{ ref('int_fishtalk__ext_daily_status_values_v2') }}
),

ext_populations_v2 as (
    select * from {{ ref('int_fishtalk__ext_populations_v2') }}
),

ext_containers_v2 as (
    select * from {{ ref('int_fishtalk__ext_containers_v2') }}
),

ft_sites as (
    select * from {{ ref('FT_Sites') }}
),

feed_consumed as (
    select
        ftgp.gp_site_id,
        gro.siteid,
        gro.company,
        gro.site,
        sum(dsv.calcfeedamountkg) as total_feed_consumed_kg,
        sum(dsv.growthkg) as growth_kg,
        sum(dsv.cullingkg) as culling_kg,
        sum(dsv.mortalitykg) as mortality_kg,
        sum(dsv.deviationkg) as deviation_kg

    from ext_daily_status_values_v2 as dsv

    left join ext_populations_v2 as pop
        on dsv.populationid = pop.populationid

    left join ext_containers_v2 as con
        on pop.containerid = con.containerid

    left join companies as gro
        on con.containerid = gro.containerid

    left join ft_sites as ftgp on gro.siteid = ftgp.ft_site_id

    where
        dsv.statusdate between dateadd(
            year, -3, current_date()
        ) and current_date()

    group by
        gro.siteid,
        gro.company,
        gro.site,
        ftgp.gp_site_id

    order by
        gro.company,
        gro.site
),

biological_fcr as (
    select

        gro.company,
        gro.site,
        tfc.gp_site_id,
        gro.siteid as ft_site_id,
        tfc.total_feed_consumed_kg,
        tfc.growth_kg,
        tfc.total_feed_consumed_kg
        / nullifzero(tfc.growth_kg) as biological_fcr,
        tfc.total_feed_consumed_kg
        / nullifzero(tfc.growth_kg - tfc.mortality_kg - tfc.culling_kg - tfc.deviation_kg) as biological_fcr_minus_mortality_culling_deviation

    from ext_daily_status_values_v2 as dsv

    left join ext_populations_v2 as pop
        on dsv.populationid = pop.populationid

    left join ext_containers_v2 as con
        on pop.containerid = con.containerid

    left join companies as gro
        on con.containerid = gro.containerid

    left join feed_consumed as tfc
        on gro.siteid = tfc.siteid

    group by
        gro.company,
        gro.site,
        gro.siteid,
        tfc.total_feed_consumed_kg,
        tfc.growth_kg,
        tfc.mortality_kg,
        tfc.culling_kg,
        tfc.deviation_kg,
        tfc.gp_site_id

    order by
        gro.company,
        gro.site
)

select

    company,
    site,
    gp_site_id,
    ft_site_id,
    round(total_feed_consumed_kg, 6) as total_feed_consumed_kg,
    round(growth_kg, 6) as growth_kg,
    round(biological_fcr, 6) as biological_fcr,
    round(biological_fcr_minus_mortality_culling_deviation, 6)
        as biological_fcr_minus_mortality_culling_deviation

from biological_fcr
where biological_fcr is not null and gp_site_id is not null
