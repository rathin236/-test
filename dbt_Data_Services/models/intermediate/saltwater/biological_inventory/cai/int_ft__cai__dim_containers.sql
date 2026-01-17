with
-- ===== SOURCES =====
src_containers as (
    select {{ trim_columns_int('stg_fishtalk__containers') }}
    from {{ ref('stg_fishtalk__containers') }}
),

src_ou as (
    select {{ trim_columns_int('stg_fishtalk__organisation_unit') }}
    from {{ ref('stg_fishtalk__organisation_unit') }}
),

src_plancontainer as (
    select {{ trim_columns_int('stg_fishtalk__plan_container') }}
    from {{ ref('stg_fishtalk__plan_container') }}
),

src_plansite as (
    select {{ trim_columns_int('stg_fishtalk__plan_site') }}
    from {{ ref('stg_fishtalk__plan_site') }}
),

src_planninggroups as (
    select {{ trim_columns_int('stg_fishtalk__planning_groups') }}
    from {{ ref('stg_fishtalk__planning_groups') }}
),

-- ===== LOGIC =====
physical as (
    select
        {{ dbt_utils.generate_surrogate_key(['cont_src.containerid', "'CAI'"]) }} as ft_container_sk,
        cont_src.containerid as container_id,
        cont_src.containername as container_name,
        cont_src.orgunitid as org_unit_id,
        case
            when cont_src.groupid is null and cont_src.standid is null then cont_src.orgunitid
            when cont_src.standid is null then cont_src.groupid
            else cont_src.standid
        end as parent_id,
        cont_src.groupid as group_id,
        cont_src.containertype as container_type_id,
        cont_src.containerfeedingmethod as feed_method_id,
        cont_src.standid as stand_id,
        cont_src.sortindex as sort_index,
        org_unit_src.active as is_active
    from src_containers as cont_src
    inner join src_ou as org_unit_src
        on cont_src.orgunitid = org_unit_src.orgunitid
            and org_unit_src.orgunittypeid <> 'A409F5FE-D15A-4D68-99FE-38749C49CE25'
),

plan as (
    select
        {{ dbt_utils.generate_surrogate_key(['plan_container_src.plancontainerid', "'CAI'"]) }} as ft_container_sk,
        plan_container_src.plancontainerid as container_id,
        coalesce(cont_src.containername, planning_groups_src.defaulttext) as container_name,
        cont_src.groupid as group_id,
        plan_site_src.orgunitid as org_unit_id,
        case
            when cont_src.groupid is null and cont_src.standid is null then plan_site_src.orgunitid
            when cont_src.standid is null then cont_src.groupid
            else cont_src.standid
        end as parent_id,
        cont_src.containertype as container_type_id,
        cont_src.containerfeedingmethod as feed_method_id,
        cont_src.standid as stand_id,
        cont_src.sortindex as sort_index,
        org_unit_src.active as is_active
    from src_plancontainer as plan_container_src
    inner join src_plansite as plan_site_src
        on plan_container_src.plansiteid = plan_site_src.plansiteid
    inner join src_ou as org_unit_src
        on plan_site_src.orgunitid = org_unit_src.orgunitid
    left join src_containers as cont_src
        on plan_container_src.containerid = cont_src.containerid
    left join src_planninggroups as planning_groups_src
        on plan_container_src.planninggroupid = planning_groups_src.planninggroupsid
),

all_containers as (
    select
        ft_container_sk,
        container_id,
        container_name,
        group_id,
        org_unit_id,
        parent_id,
        container_type_id,
        feed_method_id,
        stand_id,
        sort_index,
        is_active
    from physical

    union all

    select
        ft_container_sk,
        container_id,
        container_name,
        group_id,
        org_unit_id,
        parent_id,
        container_type_id,
        feed_method_id,
        stand_id,
        sort_index,
        is_active
    from plan
)

select * from all_containers
