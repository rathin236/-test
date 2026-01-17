with main as (
    select
        entity_name,
        entity_id,
        project_id,
        method.value:"elementValue"::string as element_value,
        method.value:"id"::int as method_id,
        row_number() over (partition by entity_id, method.value:"id"::int order by modified_date desc) as rn
    from
        {{ ref('stg_ppm__entity_task') }},
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

final as (
    select
        main.entity_name,
        main.entity_id,
        main.project_id,
        max(case when methodid = 50056 then element_value end) as is_active,
        max(case when methodid = 705 then element_value end) as est_hours,
        max(case when methodid = 594 then element_value end) as created_by,
        max(case when methodid = 50089 then element_value end) as total_slack,
        max(case when methodid = 595 then element_value end) as created_date,
        max(case when methodid = 50518 then element_value end) as start_date,
        max(case when methodid = 50107 then element_value end) as scheduled_hours,
        max(case when methodid = 50520 then element_value end) as target_date,
        max(case when methodid = 5100 then element_value end) as parent_type_id,
        max(case when methodid = 50100 then element_value end) as scheduled_resources,
        max(case when methodid = 50044 then element_value end) as outline,
        max(case when methodid = 50025 then element_value end) as outline_level,
        max(case when methodid = 511 then element_value end) as status,
        max(case when methodid = 50065 then element_value end) as parent_id,
        max(case when methodid = 529 then element_value end) as title,
        max(case when methodid = 561 then element_value end) as scheduled_by,
        max(case when methodid = 703 then element_value end) as actual_hours,
        max(case when methodid = 598 then element_value end) as modify_date,
        max(case when methodid = 50051 then element_value end) as duration,
        max(case when methodid = 50028 then element_value end) as percent_complete,
        max(case when methodid = 502 then element_value end) as complete_date,
        max(case when methodid = 50060 then element_value end) as predecessors,
        max(case when methodid = 50061 then element_value end) as successors,
        max(case when methodid = 2756141572 then element_value end) as task_urgency,
        max(case when methodid = 50053 then element_value end) as constraint_type,
        max(case when methodid = 704 then element_value end) as hours_to_complete,
        max(case when methodid = 50059 then element_value end) as milestone,
        max(case when methodid = 2756141686 then element_value end) as critical,
        max(case when methodid = 50057 then element_value end) as has_scheduling_conflicts,
        max(case when methodid = 2756141340 then element_value end) as original_target_date
    from main
    left join fields on main.method_id = fields.methodid
    where rn = 1
    group by all
)

select * from final
