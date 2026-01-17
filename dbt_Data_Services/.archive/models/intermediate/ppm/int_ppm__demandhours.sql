with main as (
    select
        allocation_roleid,
        method.value:"elementValue"::string as element_value,
        method.value:"id"::int as method_id,
        modified_date
    from
        {{ ref('stg_ppm__demandcapacity') }},
        lateral flatten(input => parse_json(json_data):"soapenv:Envelope"."soapenv:Body"."ns:findEntityResponse"."ns:return"."methodValues") as method
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
        where entity_name = 'Allocation Roles'
),

final as (
    select
        main.allocation_roleid,
        main.modified_date,
        max(case when methodid = 5460 then element_value end) as allocation_type_title,
        max(case when methodid = 5450 then element_value end) as actual_hours,
        max(case when methodid = 5416 then element_value end) as estimated_hours,
        max(case when methodid = 5495 then element_value end) as create_date,
        max(case when methodid = 5405 then element_value end) as end_date,
        max(case when methodid = 5429 then element_value end) as fte,
        max(case when methodid = 5407 then element_value end) as is_active,
        max(case when methodid = 5498 then element_value end) as modify_date,
        max(case when methodid = 5421 then element_value end) as project_id,
        max(case when methodid = 5448 then element_value end) as project_title,
        max(case when methodid = 5410 then element_value end) as role_id,
        max(case when methodid = 5417 then element_value end) as resource_id,
        max(case when methodid = 5440 then element_value end) as resource_full_name,
        max(case when methodid = 5419 then element_value end) as role_title,
        max(case when methodid = 5411 then element_value end) as start_date,
        max(case when methodid = 5443 then element_value end) as allocated_cost
    from main

    left join fields
    on main.method_id = fields.methodid

    group by all
),

latest_rec as (
    select
        allocation_roleid,
        allocation_type_title,
        actual_hours,
        estimated_hours,
        create_date,
        end_date,
        fte,
        is_active,
        modify_date,
        project_id,
        project_title,
        role_id,
        resource_id,
        resource_full_name,
        role_title,
        start_date,
        allocated_cost,
        modified_date,
        row_number() over (
            partition by allocation_roleid
            order by modified_date desc
        ) as row_num
    from final
    qualify
        row_num = 1
)

select * from latest_rec
