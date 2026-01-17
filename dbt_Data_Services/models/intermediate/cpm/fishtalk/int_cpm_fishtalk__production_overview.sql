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

culls as (
    select

        gro.company,
        gro.site,
        ftgp.gp_site_id,
        year(date_trunc('year', dsv.enddate)) as generation,
        to_char(date_trunc('month', dsv.enddate), 'MM-yyyy') as gen_month,
        sum(dsv.cullingcount) as culling_count,
        gro.siteid
        || to_char(date_trunc('month', dsv.enddate), 'MM-yyyy') as unique_id

    from ext_daily_status_values_v2 as dsv

    left join ext_populations_v2 as pop
        on dsv.populationid = pop.populationid

    left join ext_containers_v2 as con
        on pop.containerid = con.containerid

    left join companies as gro
        on con.containerid = gro.containerid

    left join ft_sites as ftgp
        on gro.siteid = ftgp.ft_site_id

    group by

        gro.company,
        gro.site,
        gro.siteid,
        date_trunc('year', dsv.enddate),
        date_trunc('month', dsv.enddate),
        ftgp.gp_site_id

    order by

        gro.site,
        year(date_trunc('year', dsv.enddate)),
        to_char(date_trunc('month', dsv.enddate), 'MM-yyyy')

),

production_overview as (
    select

        gro.company,
        gro.site,
        gro.siteid,
        ftgp.gp_site_id,
        cul.culling_count as culls,
        '' as transfers,
        '' as transfers_in,
        '' as transfers_out,
        '' as inputs,
        '' as sales,
        '' as deviations,
        '' as total_mortality,
        '' as acclimation_mortality,
        '' as entry_allowance_mortality,
        '' as harvest_count,
        '' as harvest_biomass,
        to_char(date_trunc('month', dsv.enddate), 'MM-yyyy') as gen_month,
        sum(dsv.endcount) as end_count,
        sum(dsv.endbiomasskg) as biomass

    from ext_daily_status_values_v2 as dsv

    left join ext_populations_v2 as pop
        on dsv.populationid = pop.populationid

    left join ext_containers_v2 as con
        on pop.containerid = con.containerid

    left join companies as gro
        on con.containerid = gro.containerid

    left join culls as cul
        on cul.unique_id = gro.siteid || to_char(date_trunc('month', dsv.enddate), 'MM-yyyy')

    left join ft_sites as ftgp on gro.siteid = ftgp.ft_site_id

    where dsv.enddate::date = last_day(dsv.enddate, month)

    group by

        gro.company,
        gro.siteid,
        gro.site,
        dsv.enddate,
        cul.culling_count,
        ftgp.gp_site_id

    order by

        gro.site
)

select

    company,
    site,
    siteid,
    gp_site_id,
    culls,
    transfers,
    transfers_in,
    transfers_out,
    inputs,
    sales,
    deviations,
    total_mortality,
    acclimation_mortality,
    entry_allowance_mortality,
    harvest_count,
    harvest_biomass,
    gen_month,
    end_count,
    round(biomass, 6) as biomass

from production_overview
where gp_site_id is not null
