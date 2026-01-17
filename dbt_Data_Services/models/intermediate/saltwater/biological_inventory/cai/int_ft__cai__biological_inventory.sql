with
-- required tables
stg_public_plan_status_values as (
    select {{ trim_columns_int('stg_fishtalk__public_plan_status_values') }}
    from {{ ref('stg_fishtalk__public_plan_status_values') }}
),

stg_public_status_values as (
    select {{ trim_columns_int('stg_fishtalk__public_status_values') }}
    from {{ ref('stg_fishtalk__public_status_values') }}
),

dim_populations as (
    select *
    from {{ ref('int_ft__cai__dim_populations') }}
),

dim_containers as (
    select *
    from {{ ref('int_ft__cai__dim_containers') }}
),

dim_grouped_orgs as (
    select *
    from {{ ref('int_ft__cai__grouped_orgs') }}
),

public_plan_status_values_filtered as (
    select
        plan_src.scenarioid as scenario_id,
        plan_src.populationid as population_id,
        plan_src.statustime as status_time,
        plan_src.statustype as status_type,
        plan_src.currentcount as current_count,
        plan_src.currentbiomasskg as current_biomass_kg,
        plan_src.feedamountkg as feed_amount_kg,
        plan_src.harvestcount as harvest_count,
        plan_src.harvestbiomasskg as harvest_biomass_kg,
        plan_src.inputcount as input_count,
        plan_src.inputbiomasskg as input_biomass_kg,
        plan_src.salescount as sales_count,
        plan_src.salesbiomasskg as sales_biomass_kg,
        plan_src.mortalitycount as mortality_count,
        plan_src.mortalitybiomasskg as mortality_biomass_kg,
        plan_src.cullingcount as culling_count,
        plan_src.cullingbiomass as culling_biomass_kg,
        plan_src.lostinsamplescount as lost_in_samples_count,
        plan_src.lostinsamplesbiomasskg as lost_in_samples_biomass_kg,
        plan_src.escapecount as escape_count,
        plan_src.escapebiomasskg as escape_biomass_kg,
        plan_src.deviationcount as deviation_count,
        plan_src.deviationbiomasskg as deviation_biomass_kg,
        plan_src.harvestdiscardscount as harvest_discards_count,
        plan_src.harvestdiscardsbiomasskg as harvest_discards_biomass_kg,
        plan_src.lostinspawningcount as lost_in_spawning_count,
        plan_src.lostinspawningbiomasskg as lost_in_spawning_biomass_kg,
        plan_src.closingdeviationcount as closing_deviation_count,
        plan_src.closingdeviationbiomasskg as closing_deviation_biomass_kg,
        plan_src.temperature,
        plan_src.calcfeedamountkg as calc_feed_amount_kg,
        plan_src.atu,
        plan_src.isfasting as is_fasting,
        plan_src.volume,
        cast(null as varchar) as reason_for_not_feeding,
        cast(null as varchar) as reason_for_not_checking_mortality,
        case
            when plan_src.statustype = 2
                then dateadd('day', 1, cast(plan_src.statustime as date))
            else cast(plan_src.statustime as date)
        end as status_date
    from stg_public_plan_status_values as plan_src
    where plan_src.statustime >= dateadd(year, -3, current_date)
        and plan_src.statustime < dateadd(day, 1, current_date)
),

public_status_values_filtered as (
    select
        '00000000-0000-0000-0000-000000000001' as scenario_id,
        stat_src.populationid as population_id,
        stat_src.statustime as status_time,
        stat_src.statustype as status_type,
        stat_src.currentcount as current_count,
        stat_src.currentbiomasskg as current_biomass_kg,
        stat_src.feedamountkg as feed_amount_kg,
        stat_src.harvestcount as harvest_count,
        stat_src.harvestbiomasskg as harvest_biomass_kg,
        stat_src.inputcount as input_count,
        stat_src.inputbiomasskg as input_biomass_kg,
        stat_src.salescount as sales_count,
        stat_src.salesbiomasskg as sales_biomass_kg,
        stat_src.mortalitycount as mortality_count,
        stat_src.mortalitybiomasskg as mortality_biomass_kg,
        stat_src.cullingcount as culling_count,
        stat_src.cullingbiomass as culling_biomass_kg,
        stat_src.lostinsamplescount as lost_in_samples_count,
        stat_src.lostinsamplesbiomasskg as lost_in_samples_biomass_kg,
        stat_src.escapecount as escape_count,
        stat_src.escapebiomasskg as escape_biomass_kg,
        stat_src.deviationcount as deviation_count,
        stat_src.deviationbiomasskg as deviation_biomass_kg,
        stat_src.harvestdiscardscount as harvest_discards_count,
        stat_src.harvestdiscardsbiomasskg as harvest_discards_biomass_kg,
        stat_src.lostinspawningcount as lost_in_spawning_count,
        stat_src.lostinspawningbiomasskg as lost_in_spawning_biomass_kg,
        stat_src.closingdeviationcount as closing_deviation_count,
        stat_src.closingdeviationbiomasskg as closing_deviation_biomass_kg,
        stat_src.temperature,
        stat_src.calcfeedamountkg as calc_feed_amount_kg,
        stat_src.atu,
        stat_src.isfasting as is_fasting,
        stat_src.volume,
        stat_src.reasonfornotfeeding as reason_for_not_feeding,
        stat_src.reasonfornotcheckingmortality as reason_for_not_checking_mortality,
        case
            when stat_src.statustype = 2
                then dateadd('day', 1, cast(stat_src.statustime as date))
            else cast(stat_src.statustime as date)
        end as status_date
    from stg_public_status_values as stat_src
    where stat_src.statustime >= dateadd(year, -3, current_date)
and stat_src.statustime < dateadd(day, 1, current_date)
),

ext_status_values as (
    select
        scenario_id,
        population_id,
        status_time,
        status_type,
        current_count,
        current_biomass_kg,
        feed_amount_kg,
        harvest_count,
        harvest_biomass_kg,
        input_count,
        input_biomass_kg,
        sales_count,
        sales_biomass_kg,
        mortality_count,
        mortality_biomass_kg,
        culling_count,
        culling_biomass_kg,
        lost_in_samples_count,
        lost_in_samples_biomass_kg,
        escape_count,
        escape_biomass_kg,
        deviation_count,
        deviation_biomass_kg,
        harvest_discards_count,
        harvest_discards_biomass_kg,
        lost_in_spawning_count,
        lost_in_spawning_biomass_kg,
        closing_deviation_count,
        closing_deviation_biomass_kg,
        temperature,
        calc_feed_amount_kg,
        atu,
        is_fasting,
        volume,
        reason_for_not_feeding,
        reason_for_not_checking_mortality,
        status_date
    from public_plan_status_values_filtered

    union all

    select
        scenario_id,
        population_id,
        status_time,
        status_type,
        current_count,
        current_biomass_kg,
        feed_amount_kg,
        harvest_count,
        harvest_biomass_kg,
        input_count,
        input_biomass_kg,
        sales_count,
        sales_biomass_kg,
        mortality_count,
        mortality_biomass_kg,
        culling_count,
        culling_biomass_kg,
        lost_in_samples_count,
        lost_in_samples_biomass_kg,
        escape_count,
        escape_biomass_kg,
        deviation_count,
        deviation_biomass_kg,
        harvest_discards_count,
        harvest_discards_biomass_kg,
        lost_in_spawning_count,
        lost_in_spawning_biomass_kg,
        closing_deviation_count,
        closing_deviation_biomass_kg,
        temperature,
        calc_feed_amount_kg,
        atu,
        is_fasting,
        volume,
        reason_for_not_feeding,
        reason_for_not_checking_mortality,
        status_date
    from public_status_values_filtered
),

final as (
    select
        org_dim.company_name,
        org_dim.enterprise_name,
        org_dim.site_name,
        org_dim.site_id,
        start_status.population_id,
        -- org_dim.container_id_org,
        con_dim.container_name,
        pop_dim.input_year,
        pop_dim.input_number,
        start_status.status_date,
        start_status.status_time,
        start_status.status_type as start_type,
        start_status.current_count as start_count,
        start_status.current_biomass_kg as start_biomass_kg,
        end_status.status_date as end_date,
        end_status.status_type as end_type,
        end_status.current_count as end_count,
        end_status.current_biomass_kg as end_biomass_kg,
        end_status.is_fasting,
        end_status.reason_for_not_feeding,
        end_status.reason_for_not_checking_mortality,
        (end_status.current_biomass_kg) * 1000 as end_biomass_g,
        end_status.feed_amount_kg - start_status.feed_amount_kg as feed_use_kg,
        end_status.mortality_count - start_status.mortality_count as mortality_count,
        end_status.mortality_biomass_kg - start_status.mortality_biomass_kg as mortality_kg,
        end_status.escape_count - start_status.escape_count as escape_count,
        end_status.escape_biomass_kg - start_status.escape_biomass_kg as escape_kg,
        end_status.culling_count - start_status.culling_count as culling_count,
        case
            when end_status.status_type = 2
                and end_status.culling_count <> 0
                and end_status.culling_biomass_kg = 0
                and start_status.current_count <> 0
                then (start_status.current_biomass_kg / start_status.current_count) * end_status.culling_count
                    - start_status.culling_biomass_kg
            else end_status.culling_biomass_kg - start_status.culling_biomass_kg
        end as culling_kg,
        end_status.lost_in_samples_count - start_status.lost_in_samples_count as lost_in_samples_count,
        end_status.lost_in_samples_biomass_kg - start_status.lost_in_samples_biomass_kg as lost_in_samples_kg,
        end_status.lost_in_spawning_count - start_status.lost_in_spawning_count as lost_in_spawning_count,
        end_status.lost_in_spawning_biomass_kg - start_status.lost_in_spawning_biomass_kg as lost_in_spawning_kg,
        end_status.input_count - start_status.input_count as input_count,
        end_status.input_biomass_kg - start_status.input_biomass_kg as input_kg,
        end_status.harvest_count - start_status.harvest_count as harvest_count,
        end_status.harvest_biomass_kg - start_status.harvest_biomass_kg as harvest_kg,
        end_status.sales_count - start_status.sales_count as sales_count,
        end_status.sales_biomass_kg - start_status.sales_biomass_kg as sales_kg,
        end_status.deviation_count - start_status.deviation_count as deviation_count,
        end_status.deviation_biomass_kg - start_status.deviation_biomass_kg as deviation_kg,
        end_status.harvest_discards_count - start_status.harvest_discards_count as harvest_discards_count,
        end_status.harvest_discards_biomass_kg - start_status.harvest_discards_biomass_kg as harvest_discards_kg,
        (
            (end_status.current_biomass_kg - start_status.current_biomass_kg)
            - (end_status.input_biomass_kg - start_status.input_biomass_kg)
            + (end_status.harvest_biomass_kg - start_status.harvest_biomass_kg)
            + (end_status.sales_biomass_kg - start_status.sales_biomass_kg)
        ) as growth_kg,
        (
            (end_status.current_biomass_kg - start_status.current_biomass_kg)
            - (end_status.input_biomass_kg - start_status.input_biomass_kg)
            + (end_status.harvest_biomass_kg - start_status.harvest_biomass_kg)
            + (end_status.sales_biomass_kg - start_status.sales_biomass_kg)
            + (end_status.mortality_biomass_kg - start_status.mortality_biomass_kg)
            + (end_status.culling_biomass_kg - start_status.culling_biomass_kg)
            + (end_status.escape_biomass_kg - start_status.escape_biomass_kg)
            + (end_status.lost_in_samples_biomass_kg - start_status.lost_in_samples_biomass_kg)
            + (end_status.lost_in_spawning_biomass_kg - start_status.lost_in_spawning_biomass_kg)
        ) as gross_growth_kg,
        end_status.calc_feed_amount_kg - start_status.calc_feed_amount_kg as calc_feed_amount_kg,
        end_status.atu - start_status.atu as atu,
        case
            when end_status.scenario_id = '00000000-0000-0000-0000-000000000001'
                then
                    case
                        when end_status.status_time = start_status.status_time then null
                        when end_status.atu = start_status.atu then null
                        else
                            (end_status.atu - start_status.atu)
                            / (datediff('second', start_status.status_time, end_status.status_time) / 86400.0)
                    end
            else end_status.temperature
        end as avg_temperature,
        (
            (end_status.current_biomass_kg - start_status.current_biomass_kg)
            - (end_status.input_biomass_kg - start_status.input_biomass_kg)
            + (end_status.harvest_biomass_kg - start_status.harvest_biomass_kg)
            + (end_status.sales_biomass_kg - start_status.sales_biomass_kg)
            - (end_status.harvest_discards_biomass_kg - start_status.harvest_discards_biomass_kg)
        ) as growth_kg_ex_discards,
        coalesce(end_status.volume, start_status.volume) as status_volume,

        {{ dbt_utils.generate_surrogate_key([
            'org_dim.container_id',
            "'CAI'"
        ]) }} as ft_container_sk,

        {{ dbt_utils.generate_surrogate_key([
            'org_dim.enterprise_id',
            "'CAI'"
        ]) }} as ft_enterprise_sk,

        {{ dbt_utils.generate_surrogate_key([
            'org_dim.site_id',
            "'CAI'"
        ]) }} as ft_site_sk,

        {{ dbt_utils.generate_surrogate_key([
            'org_dim.company_id',
            "'CAI'"
        ]) }} as ft_company_sk,

        {{ dbt_utils.generate_surrogate_key([
            'ft_company_sk',
            'ft_site_sk',
            'ft_container_sk',
            'ft_enterprise_sk',
            'start_status.population_id',
            'start_status.status_date'
        ]) }} as ft_inventory_pk
    -- noqa: disable=PRS
    from ext_status_values as start_status
    inner join ext_status_values as end_status
        on start_status.population_id = end_status.population_id
            and start_status.scenario_id = end_status.scenario_id
            and start_status.status_date = dateadd('day', -1, end_status.status_date)
    inner join dim_populations as pop_dim
        on start_status.population_id = pop_dim.population_id
    inner join dim_containers as con_dim
        on pop_dim.container_id = con_dim.container_id
    left join dim_grouped_orgs as org_dim
        on con_dim.container_id = org_dim.container_id
)

select *
from final
/*
for testing
select
sum(end_count) as end_count, sum(end_biomass_kg) as end_biomass_kg, sum(end_biomass_g), sum(end_biomass_g)/sum(end_count) as end_avg_wt
from final
where site_name = 'BOONE COVE'
and status_date = '2025-08-24'
and end_type = '1'
-- */
