with ext_organisation_v2 as (
    select * from {{ ref('int_fishtalk__ext_organisation_v2') }}
),

ext_containers_v2 as (
    select * from {{ ref('int_fishtalk__ext_containers_v2') }}
),

ext_stands_v2 as (
    select * from {{ ref('int_fishtalk__ext_stands_v2') }}
),

ext_organisation_groups_v2 as (
    select * from {{ ref('int_fishtalk__ext_organisation_groups_v2') }}
),

ext_grouped_organisation_v2 as (
    select

        containers.containerid,
        containers.containername as container,
        sites.orgunitname as site,
        companies.orgunitname as company,
        enterprises.orgunitname as enterprise,
        sitegroups.groupname as sitegroup,
        companygroups.groupname as companygroup,
        sites.orgunitid as siteid,
        companies.orgunitid as companyid,
        enterprises.orgunitid as enterpriseid,
        sitegroups.groupid as sitegroupid,
        companygroups.groupid as companygroupid,
        containergroups.groupid as containergroupid,
        containergroups.groupname as containergroup,
        sites.prodstage,
        stands.standname,
        containers.standid

    from ext_organisation_v2 as enterprises

    left join ext_organisation_v2 as companies
        on enterprises.orgunitid = companies.parentorgunitid

    left join ext_organisation_v2 as sites
        on companies.orgunitid = sites.parentorgunitid

    left join ext_containers_v2 as containers
        on sites.orgunitid = containers.orgunitid

    left join ext_stands_v2 as stands
        on containers.standid = stands.standid

    left join ext_organisation_groups_v2 as containergroups
        on containers.groupid = containergroups.groupid

    left join ext_organisation_groups_v2 as companygroups
        on companies.groupid = companygroups.groupid

    left join ext_organisation_groups_v2 as sitegroups
        on sites.groupid = sitegroups.groupid

)

select * from ext_grouped_organisation_v2
