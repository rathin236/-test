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

start_biomass as (
    select

        gro.siteid,
        ftgp.gp_site_id,
        gro.company,
        gro.site,
        dsv.statusdate,
        month(dsv.statusdate) as month_num,
        monthname(dsv.statusdate) as month,
        sum(dsv.startbiomasskg) as start_biomass,
        gro.siteid || to_char(dsv.statusdate, 'MM-yyyy') as unique_id

    from ext_daily_status_values_v2 as dsv

    left join ext_populations_v2 as pop
        on dsv.populationid = pop.populationid

    left join ext_containers_v2 as con
        on pop.containerid = con.containerid

    left join companies as gro
        on con.containerid = gro.containerid

    left join ft_sites as ftgp
        on gro.siteid = ftgp.ft_site_id

    where date_trunc('month', dsv.statusdate) = dsv.statusdate::date

    group by
        gro.siteid,
        gro.company,
        gro.site,
        dsv.statusdate,
        month,
        ftgp.gp_site_id

    order by
        gro.company,
        gro.site,
        dsv.statusdate

),

end_biomass as (
    select

        gro.siteid,
        ftgp.gp_site_id,
        gro.company,
        gro.site,
        month(dsv.statusdate) as month_num,
        monthname(dsv.statusdate) as month,
        sum(dsv.endbiomasskg) as end_biomass,
        gro.siteid || to_char(dsv.statusdate, 'MM-yyyy') as unique_id

    from ext_daily_status_values_v2 as dsv

    left join ext_populations_v2 as pop
        on dsv.populationid = pop.populationid

    left join ext_containers_v2 as con
        on pop.containerid = con.containerid

    left join companies as gro
        on con.containerid = gro.containerid

    left join ft_sites as ftgp
        on gro.siteid = ftgp.ft_site_id

    where dsv.statusdate::date = last_day(dsv.statusdate, month)

    group by
        gro.siteid,
        gro.company,
        gro.site,
        dsv.statusdate,
        ftgp.gp_site_id

    order by
        gro.company,
        gro.site,
        dsv.statusdate

),

mortality as (
    select

        gro.siteid,
        ftgp.gp_site_id,
        gro.company,
        gro.site,
        month(dsv.statusdate) as month_num,
        monthname(dsv.statusdate) as month,
        sum(dsv.endcount) as fish_count,
        sum(dsv.mortalitycount) as mortality,
        gro.siteid || to_char(dsv.statusdate, 'MM-yyyy') as unique_id

    from ext_daily_status_values_v2 as dsv

    left join
        ext_populations_v2 as pop
        on dsv.populationid = pop.populationid

    left join ext_containers_v2 as con
        on pop.containerid = con.containerid

    left join companies as gro
        on con.containerid = gro.containerid

    left join ft_sites as ftgp
        on gro.siteid = ftgp.ft_site_id

    where dsv.statusdate::date = last_day(dsv.statusdate, month)

    group by
        gro.siteid,
        gro.company,
        gro.site,
        dsv.statusdate,
        month,
        ftgp.gp_site_id

    order by
        gro.company,
        gro.site,
        dsv.statusdate

),

hatchery_spec_models as (
    select

        edb.company,
        edb.site,
        edb.siteid,
        edb.gp_site_id,
        edb.month_num,
        edb.month,
        mor.fish_count,
        round(stb.start_biomass, 2) as start_biomass,
        round(edb.end_biomass, 2) as end_biomass,
        round(mor.mortality, 2) as mortality,
        round(edb.end_biomass / nullifzero(stb.start_biomass), 3) as growth_spec_calc

    from end_biomass as edb

    left join start_biomass as stb
        on edb.unique_id = stb.unique_id

    left join mortality as mor
        on edb.unique_id = mor.unique_id

    where stb.statusdate >= dateadd(year, -5, current_date())

    qualify row_number() over (partition by edb.unique_id order by edb.month) = 1

)

select

    company,
    site,
    siteid,
    gp_site_id,
    month,
    round(avg(growth_spec_calc), 3) as average_weight_kg,
    greatest(round((sum(end_biomass) - sum(start_biomass)) / sum(start_biomass), 4), 0)
    * 100 as average_growth_percent,
    greatest(round(sum(mortality) / sum(fish_count), 5), 0)
    * 100 as average_mortality_percent

from hatchery_spec_models

where gp_site_id is not null

group by
    company,
    site,
    siteid,
    gp_site_id,
    month,
    month_num

order by
    month_num
