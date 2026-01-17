with main as (
    select
        entity_name,
        entity_id,
        method.value:"elementValue"::string as element_value,
        method.value:"id"::int as method_id,
        row_number() over (partition by entity_id, method.value:"id"::int order by modified_date desc) as rn
    from
        {{ ref('stg_ppm__entity_portfolio') }},
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
        main.rn,
        max(case when fields.method = 'parentTypeId' then main.element_value end) as parent_type_id,
        max(case when fields.method = 'classId' then main.element_value end) as class_id,
        max(case when fields.method = 'isAtTopLevel' then main.element_value end) as is_at_top,
        max(case when fields.method = 'level' then main.element_value end) as level,
        max(case when fields.method = 'ownerFullNameLastFirst' then main.element_value end) as owner_name,
        max(case when fields.method = 'parentId' then main.element_value end) as parent_id,
        max(case when fields.method = 'projectCount' then main.element_value end) as project_count,
        max(case when fields.method = 'LLStatusTitle' then main.element_value end) as status,
        max(case when fields.method = 'subPortfolioCount' then main.element_value end) as subportfolio_count,
        max(case when fields.method = 'title' then main.element_value end) as title
    from main
    left join fields on main.method_id = fields.methodid
    group by all
),

final as (
    select
        entity_name,
        entity_id,
        parent_type_id,
        is_at_top,
        level,
        owner_name,
        parent_id,
        project_count,
        status,
        subportfolio_count,
        title
    from pivoted
    where rn = 1
)

select * from final
