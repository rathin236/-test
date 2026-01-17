with filtered_data as (
    select *
    from {{ ref('stg_powerbi__datasets') }}
    qualify
        _fivetran_batch = max(_fivetran_batch) over ()
),

parsed_data as (
    select
        _fivetran_batch,
        _fivetran_synced,
        create_date,
        parse_json(json_data):addRowsAPIEnabled::boolean as addrowsapienabled,
        parse_json(json_data):configuredBy::string as configuredby,
        parse_json(json_data):contentProviderType::string as contentprovidertype,
        parse_json(json_data):createReportEmbedURL::string as createreportembedurl,
        parse_json(json_data):createdDate::timestamp as createddate,
        parse_json(json_data):id::string as id,
        parse_json(json_data):isEffectiveIdentityRequired::boolean as iseffectiveidentityrequired,
        parse_json(json_data):isEffectiveIdentityRolesRequired::boolean as iseffectiveidentityrolesrequired,
        parse_json(json_data):isInPlaceSharingEnabled::boolean as isinplacesharingenabled,
        parse_json(json_data):isRefreshable::boolean as isrefreshable,
        parse_json(json_data):name::string as name,
        parse_json(json_data):qnaEmbedURL::string as qnaembedurl,
        parse_json(json_data):queryScaleOutSettings:autoSyncReadOnlyReplicas::boolean as autosyncreadonlyreplicas,
        parse_json(json_data):queryScaleOutSettings:maxReadOnlyReplicas::int as maxreadonlyreplicas,
        parse_json(json_data):targetStorageMode::string as targetstoragemode,
        parse_json(json_data):upstreamDatasets::array as upstreamdatasets,
        parse_json(json_data):users::array as users,
        parse_json(json_data):webUrl::string as weburl,
        parse_json(json_data):workspaceId::string as workspaceid,
        dateadd(day, -1, create_date) as last_check_date
    from filtered_data
)

select * from parsed_data
