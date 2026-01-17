with
-- ===== import ctes =====
organisation_unit as (
    select {{ trim_columns_int('stg_fishtalk__organisation_unit') }}
    from {{ ref('stg_fishtalk__organisation_unit') }}
    -- where orgunittypeid = 'CF05BBAD-BFFD-41F5-9EA7-8F1951D3BA11'
),

locations as (
    select {{ trim_columns_int('stg_fishtalk__locations') }}
    from {{ ref('stg_fishtalk__locations') }}
),

county as (
    select {{ trim_columns_int('stg_fishtalk__county') }}
    from {{ ref('stg_fishtalk__county') }}
),

organisation_relations as (
    select {{ trim_columns_int('stg_fishtalk__organisation_relations') }}
    from {{ ref('stg_fishtalk__organisation_relations') }}
),

properties as (
    select {{ trim_columns_int('stg_fishtalk__organisation_unit_properties') }}
    from {{ ref('stg_fishtalk__organisation_unit_properties') }}
),

-- ===== property slices (only the one you use) =====
op_officialsiteid as (
    select
        properties.orgunitid,
        properties.stringvalue
    from properties
    where properties.propertyid ilike '93907ADB-138A-411B-9EB3-3AE45AD393BF'
),

final as (
    select
        -- primary key (surrogate)
        {{ dbt_utils.generate_surrogate_key(['organisation_unit.orgunitid', "'CAI'"]) }} as ft_company_sk,

        -- internal ids (core)
        organisation_unit.orgunitid as company_id,
        organisation_unit.groupid as group_id,
        organisation_relations.parentorgunitid as parent_org_unit_id,
        coalesce(organisation_unit.groupid, organisation_relations.parentorgunitid) as parent_id,
        organisation_unit.orgunittypeid as org_unit_type_id,

        -- external/reference ids
        op_officialsiteid.stringvalue as official_company_id,

        -- names & descriptive/static attributes
        organisation_unit.name as company_name,
        locations.name as location_name,
        case
            when locations.countyid is null then null
            else county.defaulttext
        end as province,
        organisation_unit.active as is_active
    from organisation_unit as organisation_unit
    left join locations as locations
        on organisation_unit.locationid = locations.locationid
    left join county as county
        on locations.nationid = county.nationid
            and locations.countyid = county.countyid
    left join organisation_relations as organisation_relations
        on organisation_unit.orgunitid = organisation_relations.orgunitid
    left join op_officialsiteid as op_officialsiteid
        on organisation_unit.orgunitid = op_officialsiteid.orgunitid
    where organisation_unit.orgunittypeid in (
            -- 'A409F5FE-D15A-4D68-99FE-38749C49CE25',
            'CF05BBAD-BFFD-41F5-9EA7-8F1951D3BA11'
        )
)

select *
from final
