with bio as (
    select
        ft_site_sk,
        ft_company_sk,
        ft_enterprise_sk,
        site_id,
        site_name,
        status_date,
        end_type,
        start_count,
        start_biomass_kg,
        end_count,
        end_biomass_kg,
        mortality_kg,
        mortality_count
    from {{ ref('int_ft__cai__biological_inventory') }}
),

ipf as (
    select
        ft_insurance_sk,
        site_id,
        policy_id,
        policy_number,
        policy_date,
        from_weight,
        to_weight,
        price_per_fish,
        price_per_kg
    from {{ ref('int_ft__cai__insurance_profile') }}
),

agg as (
    select
        bio.ft_site_sk,
        bio.ft_company_sk,
        bio.ft_enterprise_sk,
        bio.site_id,
        bio.site_name,
        bio.status_date,
        bio.end_type,
        sum(bio.mortality_kg) as mortality_kg,
        sum(bio.mortality_count) as mortality_count,
        sum(bio.start_count) as start_count,
        sum(bio.start_biomass_kg) as start_biomass_kg,
        sum(bio.end_count) as end_count,
        sum(bio.end_biomass_kg) as end_biomass_kg
    from bio
    group by
        bio.ft_site_sk,
        bio.ft_company_sk,
        bio.ft_enterprise_sk,
        bio.site_id,
        bio.site_name,
        bio.status_date,
        bio.end_type
),

rol as (
    select
        src.site_id,
        src.site_name,
        src.status_date,
        src.mortality_count,
        src.mortality_kg,
        avg(src.mortality_count) over (
            partition by src.site_id
            order by src.status_date
            range between interval '30 days' preceding and current row
        ) as mortality_count_30d_avg,
        avg(src.mortality_kg) over (
            partition by src.site_id
            order by src.status_date
            range between interval '30 days' preceding and current row
        ) as mortality_kg_30d_avg,
        avg(src.start_count) over (
            partition by src.site_id
            order by src.status_date
            range between interval '30 days' preceding and current row
        ) as start_count_count_30d_avg,
        case when start_count_count_30d_avg <> 0
                then
                    round((mortality_count_30d_avg / start_count_count_30d_avg) * 100, 2)
        end as mortality_percent
    from agg as src
),

aaw as (
    select
        agg.ft_enterprise_sk,
        agg.ft_company_sk,
        agg.ft_site_sk,
        agg.site_id,
        agg.site_name,
        agg.status_date,
        agg.start_count,
        agg.start_biomass_kg,
        agg.end_count,
        agg.end_type,
        agg.end_biomass_kg,
        case
            when agg.end_type = 1
                and agg.end_count <> 0
                and agg.end_biomass_kg is not null
                then round((agg.end_biomass_kg * 1000 / agg.end_count), 1)
        end as weight_g
    from agg
),

bas as (
    select
        ipf.ft_insurance_sk,
        ipf.site_id,
        ipf.policy_id,
        ipf.policy_number,
        ipf.policy_date,
        ipf.from_weight,
        ipf.to_weight,
        ipf.price_per_fish,
        ipf.price_per_kg
    from ipf
),

pol as (
    select distinct
        bas.site_id,
        bas.policy_id,
        bas.policy_date
    from bas
),

rnk as (
    select
        pol.site_id,
        pol.policy_id,
        pol.policy_date,
        row_number() over (
            partition by pol.site_id
            order by pol.policy_date desc, pol.policy_id desc
        ) as rn
    from pol
),

lps as (
    select
        rnk.site_id,
        rnk.policy_id
    from rnk
    where rnk.rn = 1
),

sxi as (
    -- latest-policy bands only (inner join to enforce filter)
    select
        bas.ft_insurance_sk,
        bas.site_id,
        bas.policy_id,
        bas.policy_number,
        bas.policy_date,
        bas.from_weight,
        bas.to_weight,
        bas.price_per_fish,
        bas.price_per_kg
    from bas
    inner join lps
        on bas.site_id = lps.site_id
            and bas.policy_id = lps.policy_id
),

mat as (
    select
        aaw.ft_enterprise_sk,
        aaw.ft_company_sk,
        aaw.ft_site_sk,
        aaw.site_id,
        aaw.site_name,
        aaw.status_date,
        aaw.end_type,
        aaw.start_count,
        aaw.start_biomass_kg,
        aaw.end_count,
        aaw.end_biomass_kg,
        aaw.weight_g,
        sxi.ft_insurance_sk,
        sxi.policy_id,
        sxi.from_weight,
        sxi.to_weight,
        sxi.price_per_fish,
        sxi.price_per_kg,
        rol.mortality_kg_30d_avg,
        rol.mortality_count_30d_avg,
        rol.start_count_count_30d_avg,
        rol.mortality_percent,
        row_number() over (
            partition by aaw.site_id, aaw.status_date
            order by sxi.to_weight asc
        ) as bracket_rank
    from aaw
    inner join sxi
        on aaw.site_id = sxi.site_id
            and aaw.weight_g is not null
            and aaw.weight_g between sxi.from_weight and sxi.to_weight
    left join rol
        on aaw.site_id = rol.site_id
            and aaw.status_date = rol.status_date
),

final as (
    select
        {{ dbt_utils.generate_surrogate_key(['mat.ft_site_sk', 'mat.ft_insurance_sk', 'mat.status_date']) }} as ft_valuation_pk,
        mat.ft_enterprise_sk,
        mat.ft_company_sk,
        mat.ft_site_sk,
        mat.ft_insurance_sk,
        mat.status_date,
        mat.site_name,
        mat.weight_g,
        mat.start_count,
        mat.start_biomass_kg,
        mat.end_count,
        mat.end_biomass_kg,
        mat.policy_id,
        mat.end_type,
        mat.from_weight,
        mat.to_weight,
        mat.price_per_fish,
        mat.price_per_kg,
        mat.mortality_kg_30d_avg,
        mat.mortality_count_30d_avg,
        mat.mortality_percent,
        mat.start_count_count_30d_avg,
        coalesce(
            case
                when mat.price_per_fish is not null
                    and mat.price_per_fish > 0
                    then mat.price_per_fish * mat.end_count
            end,
            case
                when mat.price_per_kg is not null
                    and (mat.price_per_fish is null or mat.price_per_fish = 0)
                    then mat.price_per_kg * mat.end_biomass_kg
            end,
            0
        ) as monetary_value
    from mat
    qualify mat.bracket_rank = 1
)

select * from final

/* for testing
-- ft_valuation_pk is the primary key
ft_valuation_pk, count(*) as err from final
group by 1
having err > 1
*/
