with main as (
    select
        entity_name,
        entity_id,
        method.value:"elementValue"::string as element_value,
        method.value:"id"::int as method_id,
        row_number() over (partition by entity_id, method.value:"id"::int order by modified_date desc) as rn
    from
        {{ ref('stg_ppm__entity_resource') }},
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
        max(case when method = 'primaryEmail' then element_value end) as resource_email,
        max(case when method = 'firstName' then element_value end) as f_name,
        max(case when method = 'lastName' then element_value end) as l_name,
        max(case when method = 'supervisorId' then element_value end) as supervisor_id,
        max(case when method = 'supervisor.fullNameLastFirst' then element_value end) as supervisor_name,
        max(case when method = 'primaryRole' then element_value end) as resource_role,
        max(case when methodid = 1110 then element_value end) as role_id,
        max(case when methodid = 1102 then element_value end) as termination_date,
        max(case when methodid = 1163 then element_value end) as target_cap_week,
        max(case when methodid = 1110 then element_value end) as resource_role_id

    from main
    left join fields on main.method_id = fields.methodid
    where rn = 1
    group by all
)

select * from pivoted
