with main as (
    select
        resource_id,
        status,
        start_date,
        end_date,
        modified_date,
        parse_json(json_data) as json_data
    from
        {{ ref('stg_ppm__timesheetforuser') }}
),

entries_project as (
    select
        resource_id,
        start_date,
        end_date,
        entries.value:"timesheetId"::string as timesheetid,
        entries.value:"billableRate"::string as billablerate,
        entries.value:"companyId"::string as companyid,
        entries.value:"entryDate"::string as entrydate,
        entries.value:"entryHours"::string as entryhours,
        entries.value:"entryId"::string as entryid,
        entries.value:"entryTypeId"::string as entrytypeid,
        entries.value:"internalRate"::string as internalrate,
        entries.value:"isBillable"::string as isbillable,
        entries.value:"isProductive"::string as isproductive,
        entries.value:"level1Id"::string as level1id,
        entries.value:"level2Id"::string as level2id,
        entries.value:"level3Id"::string as level3id,
        entries.value:"locationId"::string as locationid,
        entries.value:"state"::string as state,
        modified_date,
        'Project' as entry_type,
        row_number() over (
            partition by resource_id,
                         entries.value:"level1Id"::string,
                         entries.value:"level2Id"::string,
                         entries.value:"level3Id"::string,
                         entries.value:"entryDate"::string
            order by modified_date desc
        ) as row_num
    from
        main,
        lateral flatten(input => main.json_data:"Envelope"."Body"."getTimesheetForUsersResponse"."return"."entriesProject") as entries
    qualify
        row_num = 1
),

entries_other as (
    select
        resource_id,
        start_date,
        end_date,
        entries.value:"timesheetId"::string as timesheetid,
        entries.value:"billableRate"::string as billablerate,
        entries.value:"companyId"::string as companyid,
        entries.value:"entryDate"::string as entrydate,
        entries.value:"entryHours"::string as entryhours,
        entries.value:"entryId"::string as entryid,
        entries.value:"entryTypeId"::string as entrytypeid,
        entries.value:"internalRate"::string as internalrate,
        entries.value:"isBillable"::string as isbillable,
        entries.value:"isProductive"::string as isproductive,
        entries.value:"level1Id"::string as level1id,
        entries.value:"level2Id"::string as level2id,
        entries.value:"level3Id"::string as level3id,
        entries.value:"locationId"::string as locationid,
        entries.value:"state"::string as state,
        modified_date,
        'Other' as entry_type,
        row_number() over (
            partition by resource_id,
                         entries.value:"level1Id"::string,
                         entries.value:"level2Id"::string,
                         entries.value:"level3Id"::string,
                         entries.value:"entryDate"::string
            order by modified_date desc
        ) as row_num
    from
        main,
        lateral flatten(input => main.json_data:"Envelope"."Body"."getTimesheetForUsersResponse"."return"."entriesOther") as entries
    qualify
        row_num = 1
)

select * from entries_project
union all
select * from entries_other
