with organisation_unit as (
    select * from {{ ref('stg_fishtalk__organisation_unit') }}
),

locations as (
    select * from {{ ref('stg_fishtalk__locations') }}
),

county as (
    select * from {{ ref('stg_fishtalk__county') }}
),

organisation_relations as (
    select * from {{ ref('stg_fishtalk__organisation_relations') }}
),

organisation_unit_properties as (
    select * from {{ ref('stg_fishtalk__organisation_unit_properties') }}
),

ext_organisations_v2 as (
    select

        orgu.orgunitid,
        orgu.name as orgunitname,
        orgu.groupid,
        orgr.parentorgunitid,
        orgu.orgunittypeid,
        loc.name as location_,
        loc.longitude,
        cou.defaulttext as county,
        loc.latitude,
        orgu.active,
        case
        orgu.orgunittypeid
            when '64CD1744-1E7E-49FD-A92D-A5EC863985E5' then 'Site'
            when 'CF05BBAD-BFFD-41F5-9EA7-8F1951D3BA11' then 'Company'
            when '71CE8CDB-79EE-4293-B2B9-D06ADD64896E' then 'Enterprise'
        end as type_,
        case
        orgup.doublevalue
            when -1 then 'Undefined'
            when 0 then 'FreshWater'
            when 1 then 'Lake'
            when 2 then 'BrackishWater'
            when 3 then 'MarineSite'
            when 4 then 'Hatchery'
            when 5 then 'SacFryProduction'
            when 6 then 'FryProduction'
            when 7 then 'SmoltProduction'
            when 8 then 'BroodStock'
        end as prodstage,
        coalesce(orgu.groupid, orgr.parentorgunitid) as parentid

    from organisation_unit as orgu

    left join locations as loc
        on orgu.locationid = loc.locationid

    left join county as cou
        on loc.nationid = cou.nationid
            and loc.countyid = cou.countyid

    left join organisation_relations as orgr
        on orgu.orgunitid = orgr.orgunitid

    left join organisation_unit_properties as orgup
        on orgu.orgunitid = orgup.orgunitid
            and orgup.propertyid = '05B39BD2-36A4-4B1D-B47D-BAB212A595E4'

    where orgu.orgunittypeid not in (
            'A409F5FE-D15A-4D68-99FE-38749C49CE25',
            '00000000-0000-0000-0000-000000000000'
        )

)

select * from ext_organisations_v2
