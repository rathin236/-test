with companies as (

    select * from {{ ref('int_fishtalk__ext_grouped_organisation_v2') }}

    where company in (
            'Cold Ocean',
            'Kelly Cove',
            'Cooke Aqua',
            'Cooke Aquaculture USA',
            'NB Grand Manan',
            'NB Mainland ',
            'Nova Scotia ',
            'Trout',
            'Marine Sites'
        )
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

ext_daily_mortality_values_v2 as (
    select * from {{ ref('int_fishtalk__ext_daily_mortality_values_v2') }}
),

ext_organisation_v2 as (
    select * from {{ ref('int_fishtalk__ext_organisation_v2') }}
),

ext_feed_store_v2 as (
    select * from {{ ref('int_fishtalk__ext_feed_store_v2') }}
),

ext_feed_delivery_v2 as (
    select

        feedstoreid,
        to_char(date_trunc('month', receptiondate), 'MM-yyyy') as gen_month,
        sum(amountkg) as amountkg

    from {{ ref('int_fishtalk__ext_feed_delivery_v2') }} --noqa: disable=PRS

    group by all
    -- noqa: enable=PRS
),

end_of_month as (
    select

        gro.siteid,
        year(date_trunc('year', dsv.statusdate)) as generation,
        to_char(date_trunc('month', dsv.statusdate), 'MM-yyyy') as gen_month,
        sum(dsv.endcount) as end_count,
        sum(dsv.endbiomasskg) as end_biomass_kg,
        gro.siteid || to_char(date_trunc('month', dsv.statusdate), 'MM-yyyy') as unique_id

    from ext_daily_status_values_v2 as dsv

    left join ext_populations_v2 as pop
        on dsv.populationid = pop.populationid

    left join ext_containers_v2 as con
        on pop.containerid = con.containerid

    left join companies as gro
        on con.containerid = gro.containerid

    where dsv.statusdate::date = last_day(dsv.statusdate, month) --noqa: disable=PRS

    group by all
    -- noqa: enable=PRS
),

production_overview as (
    select

        gro.company as gro_entity,
        gro.siteid,
        gro.site,
        ftgp.gp_site_id,
        eom.end_biomass_kg,
        eom.end_count,
        fdl.amountkg as feed_purchased_kg,
        to_char(date_trunc('month', dsv.statusdate), 'MM-yyyy') as gen_month,
        year(date_trunc('year', dsv.statusdate)) as generation,
        sum(dsv.cullingcount) as culls,
        sum(dsv.mortalitycount) as total_mortality,
        sum(dsv.inputcount) as inputs,
        sum(dsv.salescount) as sales,
        sum(dsv.deviationcount) as deviations,
        sum(dsv.harvestcount) as harvest_count,
        sum(dsv.harvestkg) as harvest_biomass,
        sum(dsv.feedusekg) as total_feed_fed_kg,
        sum(dmv.mortalitycount) as acclimation_mortality_count,
        sum(dmv.mortalitybiomasskg) as acclimation_mortality_kg,
        gro.siteid || to_char(date_trunc('month', dsv.statusdate), 'MM-yyyy') as unique_id

    from ext_daily_status_values_v2 as dsv

    inner join ext_populations_v2 as pop
        on dsv.populationid = pop.populationid

    inner join ext_containers_v2 as con
        on pop.containerid = con.containerid

    left join companies as gro on con.containerid = gro.containerid

    left join ft_sites as ftgp on gro.siteid = ftgp.ft_site_id

    left join ext_daily_mortality_values_v2 as dmv
        on dsv.populationid = dmv.populationid
            and dsv.statusdate = dmv.statusdate
            and dmv.mortalitycauseid in ('1000054', '1000053', '1000052', '1000051', '1000020') -- acclimation mortality IDs

    left join end_of_month as eom
        on eom.unique_id = gro.siteid || to_char(date_trunc('month', dsv.statusdate), 'MM-yyyy')

    left join ext_organisation_v2 as org
        on con.orgunitid = org.orgunitid

    left join ext_feed_store_v2 as fst
        on org.orgunitid = fst.orgunitid
            and gro.siteid = fst.orgunitid

    left join ext_feed_delivery_v2 as fdl
        on fst.feedstoreid = fdl.feedstoreid
            and fdl.gen_month = to_char(date_trunc('month', dsv.statusdate), 'MM-yyyy')

    group by

        gro.company,
        gro.site,
        gro.siteid,
        date_trunc('year', dsv.statusdate),
        date_trunc('month', dsv.statusdate),
        ftgp.gp_site_id,
        eom.end_count,
        eom.end_biomass_kg,
        fdl.gen_month,
        fdl.amountkg,
        org.orgunitid

    order by

        gro.site,
        year(date_trunc('year', dsv.statusdate)),
        to_char(date_trunc('month', dsv.statusdate), 'MM-yyyy')

)

select

    gro_entity,
    site,
    siteid,
    gp_site_id,
    culls,
    null as transfers,
    null as transfers_in,
    null as transfers_out,
    inputs,
    sales,
    acclimation_mortality_count as acclimation_mortality,
    null as entry_allowance_mortality,
    gen_month,
    feed_purchased_kg,
    round(deviations, 6) as deviations,
    round(total_mortality, 1) as total_mortality,
    round(harvest_count, 1) as harvest_count,
    round(harvest_biomass, 6) as harvest_biomass_kg,
    round(total_feed_fed_kg, 6) as total_feed_fed_kg,
    round(end_count, 1) as end_count,
    round(end_biomass_kg, 6) as end_biomass_kg

from production_overview
where gp_site_id is not null

/* For Testing */
--and site = 'Starboard' --and gen_month = '04-2016'
