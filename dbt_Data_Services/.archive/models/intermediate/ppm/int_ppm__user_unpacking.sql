with main as (
    select
        entity_name,
        entity_id,
        method.value:"elementValue"::string as element_value,
        method.value:"id"::int as method_id,
        row_number() over (partition by entity_id, method.value:"id"::int order by modified_date desc) as rn
    from
        {{ ref('stg_ppm__entity_user') }},
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
        max(case when methodid = 2301 then element_value end) as isactive,
        max(case when methodid = 2302 then element_value end) as hasadminaccess,
        max(case when methodid = 2310 then element_value end) as fullnamelastfirst,
        max(case when methodid = 2395 then element_value end) as createdate,
        max(case when methodid = 2307 then element_value end) as getprimaryemail,
        max(case when methodid = 2331 then element_value end) as lastlogin,
        max(case when methodid = 2300 then element_value end) as paactivationdate,
        max(case when methodid = 2338 then element_value end) as padeactivationdate,
        max(case when methodid = 2304 then element_value end) as typeid

    from main
    left join fields on main.method_id = fields.methodid
    where rn = 1
    group by all

    union all

    --adding a dummy user for the relationship to userallocation table , this table has 0 as unallocated user id
    select
        'User' as entity_name,
        0 as entity_id,
        true as isactive,
        false as hasadminaccess,
        '**Unallocated Resource**' as fullnamelastfirst,
        'Fri Jan 01 00:00:00 PDT 1999' as createdate,
        null as getprimaryemail,
        'Fri Jan 01 00:00:00 PDT 1999' as lastlogin,
        to_date('01/01/1999') as paactivationdate,
        null as padeactivationdate,
        1 as typeid
)

select * from pivoted
