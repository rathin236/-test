with
enterprises as (select * from {{ ref('int_ft__cai__dim_enterprises') }}
),

companies as (select * from {{ ref('int_ft__cai__dim_companies') }}),

sites as (select * from {{ ref('int_ft__cai__dim_sites') }}),

containers as (
    select *
    from {{ ref('int_ft__cai__dim_containers') }}
),

org_groups as (
    select *
    from {{ ref('int_ft__organization_groups') }}
),

stands as (
    select *
    from {{ ref('stg_fishtalk__stand') }}
),

ext_stands as (
    select
        standid as stand_id,
        orgunitid as org_unit_id,
        name as stand_name,
        groupid as group_id
    from stands
)

select
    con.container_id,
    con.container_name as container,
    site.site_name,
    com.company_name,
    ent.enterprise_name,
    grp_site.group_name as site_group,
    site.site_id,
    com.company_id,
    ent.enterprise_id,
    grp_site.group_id as site_group_id,
    grp_con.group_id as container_group_id,
    grp_con.group_name as container_group,
    site.prod_stage,
    std_ext.stand_name,
    con.stand_id
from containers as con
left join sites as site
    on con.org_unit_id = site.site_id
left join companies as com
    on site.parent_org_unit_id = com.company_id
left join enterprises as ent
    on com.parent_org_unit_id = ent.enterprise_id
left join ext_stands as std_ext
    on con.stand_id = std_ext.stand_id
left join org_groups as grp_con
    on con.group_id = grp_con.group_id
left join org_groups as grp_site
    on site.group_id = grp_site.group_id
