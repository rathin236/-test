with main as (
    select
        entity_name,
        entity_id,
        modified_date,
        method.value:"elementValue"::string as element_value,
        method.value:"id"::int as method_id,
        row_number() over (partition by entity_id, method.value:"id"::int order by modified_date desc) as rn
    from
        {{ ref('stg_ppm__entity_taskschedule') }},
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
        main.modified_date,
        max(case when method = 'scheduleHours' then element_value end) as scheduled_hours,
        max(case when method = 'hoursToComplete' then element_value end) as hours_to_complete,
        max(case when method = 'userId' then element_value end) as user_id,
        max(case when methodid = 7904 then element_value end) as teammember_id,
        max(case when methodid = 7932 then element_value end) as hr_id,
        max(case when method = 'percentOfTime' then element_value end) as percent_time,
        max(case when method = 'taskId' then element_value end) as task_id,
        max(case when method = 'practiceId' then element_value end) as practice_id,
        max(case when method = 'actualHours' then element_value end) as actual_hours,
        max(case when method = 'actualCost' then element_value end) as actual_cost,
        max(case when method = 'humanResource.supervisor.id' then element_value end) as resource_supervisor_id,
        max(case when method = 'task.startDate' then element_value end) as start_date,
        max(case when method = 'task.targetDate' then element_value end) as target_date,
        max(case when method = 'task.completeDate' then element_value end) as complete_date,
        max(case when method = 'taskRole.title' then element_value end) as task_role,
        max(case when method = 'actualRevenue' then element_value end) as actual_revenue,
        max(case when method = 'actualProfit' then element_value end) as actual_profit,
        max(case when method = 'teamMemberRoleId' then element_value end) as team_member_role_id
    from main
    left join fields on main.method_id = fields.methodid
    where rn = 1
    group by all
),

filtered_final as (
    select
*,
           row_number() over (partition by task_id, user_id order by modified_date desc) as rn
    from final
),

result as (

select *
from filtered_final
where rn = 1
)

select * from result
