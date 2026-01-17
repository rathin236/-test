with
-- ===== import ctes =====
organisation_unit as (
    select {{ trim_columns_int('stg_fishtalk__organisation_unit') }}
    from {{ ref('stg_fishtalk__organisation_unit') }}
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

-- ===== property slices =====
op_sitetype as (
    select
        properties.orgunitid,
        properties.doublevalue
    from properties
    where properties.propertyid = '05B39BD2-36A4-4B1D-B47D-BAB212A595E4'
),

op_officialsiteid as (
    select
        properties.orgunitid,
        properties.stringvalue
    from properties
    where properties.propertyid = '93907ADB-138A-411B-9EB3-3AE45AD393BF'
),

op_officialsiteno as (
    select
        properties.orgunitid,
        properties.stringvalue
    from properties
    where properties.propertyid = '317F018A-3668-4F68-A0F5-317E6712AD62'
),

op_glno as (
    select
        properties.orgunitid,
        properties.stringvalue
    from properties
    where properties.propertyid = '1B379145-3D2C-4613-80A3-0FEC9D6A8DE2'
),

op_companyno as (
    select
        properties.orgunitid,
        properties.stringvalue
    from properties
    where properties.propertyid = 'B34C2F6C-F9D3-4785-A6B9-3C42765DCABC'
),

op_maxbio as (
    select
        properties.orgunitid,
        properties.doublevalue
    from properties
    where properties.propertyid = '8534F160-D99F-4F9D-A22C-72B99A4F90D5'
),

op_maxvol as (
    select
        properties.orgunitid,
        properties.doublevalue
    from properties
    where properties.propertyid = '766035E8-B6C9-4A40-8E13-555ECDC87D6B'
),

final as (
    select
        -- primary key (surrogate)
        {{ dbt_utils.generate_surrogate_key(['organisation_unit.orgunitid', "'CAI'"]) }} as ft_enterprise_sk,

        -- internal ids (core)
        organisation_unit.orgunitid as enterprise_id,
        organisation_relations.parentorgunitid as parent_org_unit_id,
        coalesce(organisation_unit.groupid, organisation_relations.parentorgunitid) as parent_id,

        -- names & descriptive/static attributes
        organisation_unit.name as enterprise_name,
        locations.name as location_name,
        case
            when locations.countyid is null then null
            else county.defaulttext
        end as province,
        organisation_unit.active as is_active,

        -- property outputs (now referenced, fixes ST11)
        op_sitetype.doublevalue as site_type,
        op_officialsiteid.stringvalue as official_site_id,
        op_officialsiteno.stringvalue as official_site_no,
        op_glno.stringvalue as gl_no,
        op_companyno.stringvalue as company_no,
        op_maxbio.doublevalue as max_bio,
        op_maxvol.doublevalue as max_vol
    from organisation_unit as organisation_unit
    left join locations as locations
        on organisation_unit.locationid = locations.locationid
    left join county as county
        on locations.nationid = county.nationid
            and locations.countyid = county.countyid
    left join organisation_relations as organisation_relations
        on organisation_unit.orgunitid = organisation_relations.orgunitid
    left join op_sitetype as op_sitetype
        on organisation_unit.orgunitid = op_sitetype.orgunitid
    left join op_officialsiteid as op_officialsiteid
        on organisation_unit.orgunitid = op_officialsiteid.orgunitid
    left join op_officialsiteno as op_officialsiteno
        on organisation_unit.orgunitid = op_officialsiteno.orgunitid
    left join op_glno as op_glno
        on organisation_unit.orgunitid = op_glno.orgunitid
    left join op_companyno as op_companyno
        on organisation_unit.orgunitid = op_companyno.orgunitid
    left join op_maxbio as op_maxbio
        on organisation_unit.orgunitid = op_maxbio.orgunitid
    left join op_maxvol as op_maxvol
        on organisation_unit.orgunitid = op_maxvol.orgunitid
    where organisation_unit.orgunittypeid in (
            -- 'A409F5FE-D15A-4D68-99FE-38749C49CE25',
            '71CE8CDB-79EE-4293-B2B9-D06ADD64896E'
        )
)

select *
from final
