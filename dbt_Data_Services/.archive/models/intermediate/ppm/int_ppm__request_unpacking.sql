with main as (
    select
        entity_name,
        entity_id,
        method.value:"elementValue"::string as element_value,
        method.value:"id"::int as method_id,
        row_number() over (partition by entity_id, method.value:"id"::int order by modified_date desc) as rn
    from
        {{ ref('stg_ppm__entity_request') }},
        lateral flatten(input => parse_json(json_data):"Envelope"."Body"."findEntityUpdateHistoryResponse"."return"."methodValues") as method
),

fields as (
    select
        entity_name,
        insert_date,
        modified_date,
        f.value:"method"::string as method,
        f.value:"methodId"::int as methodid
    from
        {{ ref('stg_ppm__entities_fields') }},
        lateral flatten(
            input => parse_json(json_data):"soapenv:Envelope":"soapenv:Body":"ns:getEntityFieldsResponse":"ns:return"
        ) as f
),

pivoted as (
    select
        main.entity_name,
        main.entity_id,
        max(case when method = 'createDate' then element_value end) as create_date,
        max(case when method = 'createdByResource.fullNameLastFirst' then element_value end) as created_by,
        max(case when method = 'elapsedHoldTimeInHours' then element_value end) as hold_time_hours,
        max(case when method = 'description' then element_value end) as description,
        max(case when method = 'gateStatus' then element_value end) as status,
        max(case when method = 'modifiedByResource.fullNameLastFirst' then element_value end) as modified_by,
        max(case when method = 'modifyDate' then element_value end) as modify_date,
        max(case when method = 'LLPriorityTitle' then element_value end) as priority,
        max(case when method = 'requesterFullNameLastFirst' then element_value end) as requester_name,
        max(case when method = 'title' then element_value end) as title
    from main
    left join fields on main.method_id = fields.methodid
    where rn = 1
    group by all
)

select * from pivoted
