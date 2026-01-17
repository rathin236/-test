with companies as (
    select * from {{ ref('int_fishtalk__ext_grouped_organisation_v2') }}
    where company in ('Cold Ocean', 'Kelly Cove', 'Cooke Aqua')
),

site_components as (
    select * from {{ ref('stg_fishtalk__site_components') }}
),

ext_containers_v2 as (
    select * from {{ ref('int_fishtalk__ext_containers_v2') }}
),

ext_populations_v2 as (
    select * from {{ ref('int_fishtalk__ext_populations_v2') }}
),

ext_daily_status_values_v2 as (
    select * from {{ ref('int_fishtalk__ext_daily_status_values_v2') }}
),

ft_sites as (
    select * from {{ ref('FT_Sites') }}
),

start_biomass as (
    select
        gro.site,
        ftgp.gp_site_id,
        gro.siteid,
        com.component,
        dsv.statusdate,
        month(dsv.statusdate) as month_num,
        monthname(dsv.statusdate) as month_name,
        year(dsv.statusdate) as year_num,
        sum(dsv.startbiomasskg) as start_biomass,
        gro.siteid || to_char(dsv.statusdate, 'MM-yyyy') as unique_id
    from site_components as com
    left join companies as gro on com.site_id = gro.siteid
    left join ext_containers_v2 as con on gro.containerid = con.containerid
    left join ext_populations_v2 as pop on con.containerid = pop.containerid
    left join ext_daily_status_values_v2 as dsv on pop.populationid = dsv.populationid
    left join ft_sites as ftgp on gro.siteid = ftgp.ft_site_id
    where
        com.component in (select distinct site_components.component from site_components)
        and date_trunc('month', dsv.statusdate) = dsv.statusdate::date
    group by
        gro.site, gro.siteid, com.component, dsv.statusdate, month_name, ftgp.gp_site_id
),

end_biomass as (
    select
        gro.site,
        ftgp.gp_site_id,
        gro.siteid,
        com.component,
        dsv.statusdate,
        month(dsv.statusdate) as month_num,
        monthname(dsv.statusdate) as month_name,
        year(dsv.statusdate) as year_num,
        sum(dsv.endbiomasskg) as end_biomass,
        gro.siteid || to_char(dsv.statusdate, 'MM-yyyy') as unique_id
    from site_components as com
    left join companies as gro on com.site_id = gro.siteid
    left join ext_containers_v2 as con on gro.containerid = con.containerid
    left join ext_populations_v2 as pop on con.containerid = pop.containerid
    left join ext_daily_status_values_v2 as dsv on pop.populationid = dsv.populationid
    left join ft_sites as ftgp on gro.siteid = ftgp.ft_site_id
    where
        com.component in (select distinct site_components.component from site_components)
        and dsv.statusdate::date = last_day(dsv.statusdate, month)
    group by
        gro.site, gro.siteid, com.component, dsv.statusdate, month_name, ftgp.gp_site_id
),

mortality as (
    select
        gro.site,
        ftgp.gp_site_id,
        gro.siteid,
        com.component,
        dsv.statusdate,
        month(dsv.statusdate) as month_num,
        monthname(dsv.statusdate) as month_name,
        year(dsv.statusdate) as year_num,
        sum(dsv.endcount) as fish_count,
        sum(dsv.mortalitycount) as mortality,
        gro.siteid || to_char(dsv.statusdate, 'MM-yyyy') as unique_id
    from site_components as com
    left join companies as gro on com.site_id = gro.siteid
    left join ext_containers_v2 as con on gro.containerid = con.containerid
    left join ext_populations_v2 as pop on con.containerid = pop.containerid
    left join ext_daily_status_values_v2 as dsv on pop.populationid = dsv.populationid
    left join ft_sites as ftgp on gro.siteid = ftgp.ft_site_id
    where
        com.component in (select distinct site_components.component from site_components)
        and dsv.statusdate::date = last_day(dsv.statusdate, month)
    group by
        gro.site, gro.siteid, com.component, dsv.statusdate, month_name, ftgp.gp_site_id
),

combined as (
    select
        edb.component as site_type,
        edb.month_name,
        edb.month_num,
        edb.unique_id,
        edb.end_biomass,
        stb.start_biomass,
        mor.mortality,
        mor.fish_count
    from end_biomass as edb
    left join start_biomass as stb on edb.unique_id = stb.unique_id
    left join mortality as mor on edb.unique_id = mor.unique_id
    where stb.statusdate >= dateadd(year, -5, current_date())
),

generalized_growth as (
    select
        site_type,
        month_name,
        round((sum(end_biomass) - sum(start_biomass)) / nullif(sum(start_biomass), 0), 4) * 100 as average_growth_percent,
        greatest(round(sum(mortality) / nullif(sum(fish_count), 0), 5), 0) * 100 as average_mortality_percent
    from combined
    group by site_type, month_num, month_name
    order by site_type, month_num
)

select * from generalized_growth
