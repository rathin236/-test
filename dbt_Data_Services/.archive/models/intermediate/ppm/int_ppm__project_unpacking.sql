with main as (
    select
        entity_name,
        entity_id,
        method.value:"elementValue"::string as element_value,
        method.value:"id"::int as method_id,
        row_number() over (partition by entity_id, method.value:"id"::int order by modified_date desc) as rn
    from
        {{ ref('stg_ppm__entity_project') }},
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
        max(case when methodid = 447 then element_value end) as percent_complete,
        max(case when methodid = 445 then element_value end) as time_actual,
        max(case when methodid = 446 then element_value end) as hours_to_comp,
        max(case when methodid = 476 then element_value end) as cost_at_complete,
        max(case when methodid = 495 then element_value end) as create_date,
        max(case when methodid = 428 then element_value end) as start_date,
        max(case when methodid = 403 then element_value end) as complete_date,
        max(case when methodid = 482 then element_value end) as duration_days,
        max(case when methodid = 405 then element_value end) as description,
        max(case when methodid = 2748719621 then element_value end) as business_capability,
        max(case when methodid = 2754559852 then element_value end) as secondary_business_capability,
        max(case when methodid = 2731100955 then element_value end) as associated_portfolio,
        max(case when methodid = 2725078513 then element_value end) as affected_lob,
        max(case when methodid = 2725078510 then element_value end) as affected_stakeholders,
        max(case when methodid = 2728937001 then element_value end) as assigned_bsa,
        max(case when methodid = 2756139658 then element_value end) as analytics_engineers,
        max(case when methodid = 2756140437 then element_value end) as capability_owner,
        max(case when methodid = 2756140441 then element_value end) as capability_delivery,
        max(case when methodid = 2756140915 then element_value end) as business_lead,
        max(case when methodid = 2756205145 then element_value end) as business_sme_multiselect,
        max(case when methodid = 2745120431 then element_value end) as target_date_reporting,
        max(case when methodid = 862241097 then element_value end) as business_sponsor,
        max(case when methodid = 2756205175 then element_value end) as business_sponsor_multiselect,
        max(case when methodid = 2728952292 then element_value end) as requester_business,
        max(case when methodid = 862241132 then element_value end) as overall_health,
        max(case when methodid = 2726082417 then element_value end) as overall_health_comments,
        max(case when methodid = 862241415 then element_value end) as scope_health,
        max(case when methodid = 2726082362 then element_value end) as scope_health_comments,
        max(case when methodid = 1963343873 then element_value end) as schedule_health,
        max(case when methodid = 2726082322 then element_value end) as schedule_health_comments,
        max(case when methodid = 862241389 then element_value end) as resource_health,
        max(case when methodid = 2726082374 then element_value end) as resource_health_comments,
        max(case when methodid = 2753697384 then element_value end) as project_priority,
        max(case when methodid = 2725078557 then element_value end) as project_size,
        max(case when methodid = 400010 then element_value end) as demand_cost,
        max(case when methodid = 400014 then element_value end) as total_forecast_cost,
        max(case when methodid = 100495 then element_value end) as total_actual_cost,
        max(case when methodid = 496 then element_value end) as created_by,
        max(case when methodid = 423 then element_value end) as parent_id,
        max(case when methodid = 443 then element_value end) as est_hours,
        max(case when methodid = 475 then element_value end) as hours_at_complete,
        max(case when methodid = 100449 then element_value end) as portfolio_title,
        max(case when methodid = 498 then element_value end) as modify_date,
        max(case when methodid = 416 then element_value end) as owner_name,
        max(case when methodid = 424 then element_value end) as parent_type_id,
        max(case when methodid = 458 then element_value end) as priority,
        max(case when methodid = 100476 then element_value end) as scheduled_hours,
        max(case when methodid = 411 then element_value end) as status,
        max(case when methodid = 407 then element_value end) as phase,
        max(case when methodid = 413 then element_value end) as type,
        max(case when methodid = 430 then element_value end) as target_date,
        max(case when methodid = 2756140570 then element_value end) as go_live_date,
        max(case when methodid = 2745120431 then element_value end) as planned_completion_date,
        max(case when methodid = 478 then element_value end) as team_member_ids,
        max(case when methodid = 100418 then element_value end) as team_member_names,
        max(case when methodid = 436 then element_value end) as title,
        max(case when methodid = 474 then element_value end) as cost_estimate_total,
        max(case when methodid = 2725078513 then element_value end) as company,
        substring(business_capability, 1, charindex('-', business_capability) - 1) as capability1,
        substring(business_capability,
            charindex('-', business_capability) + 1,
            charindex('-', business_capability, charindex('-', business_capability) + 1) - charindex('-', business_capability) - 1) as capability2,
        substring(business_capability,
            charindex('-', business_capability, charindex('-', business_capability) + 1) + 1,
            len(business_capability)) as capability3
    from main
    left join fields on main.method_id = fields.methodid
    where rn = 1
    group by all
),

final as (
    select
        entity_name,
        entity_id,
        percent_complete,
        time_actual,
        hours_to_comp,
        cost_at_complete,
        create_date,
        start_date,
        complete_date,
        duration_days,
        description,
        business_capability,
        capability1,
        capability2,
        capability3,
        secondary_business_capability,
        associated_portfolio,
        affected_lob,
        affected_stakeholders,
        assigned_bsa,
        analytics_engineers,
        capability_owner,
        capability_delivery,
        business_lead,
        business_sme_multiselect,
        target_date_reporting,
        business_sponsor,
        business_sponsor_multiselect,
        requester_business,
        overall_health,
        overall_health_comments,
        scope_health,
        scope_health_comments,
        schedule_health,
        schedule_health_comments,
        resource_health,
        resource_health_comments,
        created_by,
        parent_id,
        est_hours,
        project_priority,
        project_size,
        hours_at_complete,
        portfolio_title,
        modify_date,
        owner_name,
        parent_type_id,
        priority,
        scheduled_hours,
        status,
        phase,
        type,
        target_date,
        go_live_date,
        planned_completion_date,
        team_member_ids,
        team_member_names,
        title,
        cost_estimate_total,
        demand_cost,
        total_forecast_cost,
        total_actual_cost,
        company,
        datediff(day, start_date, target_date) as duration,
        case
            when status = 'Open' then 1
            when status = 'Completed' then 2
            when status = 'Hold' then 3
            when status = 'Proposed' then 4
            when status = 'Cancelled' then 5
            else 6
        end as status_order
    from pivoted
)

select * from final
