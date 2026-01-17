{{ config(
    cluster_by=['CompanyId', 'SiteId', 'UnitId']
) }}

with source as (
    select parse_json(json_data) as json_data
    -- Ensure JSON is in the correct format
    from {{ ref('stg_scale_aq__company_info') }}  -- Replace with actual schema & table
),

sites as (
    select
        source.json_data:"CompanyId"::string as companyid,
        source.json_data:"CompanyName"::string as companyname,
        f.value:"SiteId"::number as siteid,
        f.value:"SiteName"::string as sitename,
        f.value:"Units" as units_array
    from source,
        lateral flatten(input => source.json_data:"Sites") as f  -- Flatten "Sites" array
),

units as (
    select
        sites.companyid as company_id,
        sites.companyname as company_name,
        sites.siteid as site_id,
        sites.sitename as site_name,
        u.value:"UnitId"::number as unit_id,
        u.value:"UnitName"::string as unit_name
    from sites,
        lateral flatten(input => sites.units_array) as u  -- Flatten "Units" array
)

select * from units
