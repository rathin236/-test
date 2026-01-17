with main as (
    select
        form_name,
        created_date,
        executionid,
        parse_json(json_data) as json_data
    from {{ ref('stg_pronto_forms__inventory') }}
    where form_name = 'NNI Inventory Status Update'
),

parsing as (
    select
        main.executionid,
        main.form_name as form_type,
        main.json_data:name::string as form_name,
        main.created_date,
        answer.value:question::string as question,
        main.json_data:user:username::string as login_name,
        case
            when answer.value:controlType::string = 'BarcodeScanner'
                then all_values.value:data::string
            else all_values.value::string
        end as value
    from main,
        lateral flatten(input => main.json_data:pages) as page,
        lateral flatten(input => page.value:sections) as section,
        lateral flatten(input => section.value:answers) as answer,
        lateral flatten(input => answer.value:values) as all_values
),

pivoted as (
    select
        executionid,
        form_type,
        form_name,
        created_date,
        login_name,
        max(case when question = 'QRCodeData' then value end) as qr_code_data,
        max(case when question = 'Location' then value end) as location,
        max(case when question = 'InventoryStatus' then value end) as inventory_status,
        max(case when question = 'LotNumber' then value end) as lot_number,
        max(case when question = 'ProductNumber' then value end) as product_number,
        max(case when question = 'PalletNumber' then value end) as pallet_number,
        max(case when question = 'ProductionDate' then value end) as production_date,
        max(case when question = 'Weight' then value end) as weight,
        max(case when question = 'Country' then value end) as country,
        max(case when question = 'Bag Size' then value end) as bag_size
    from parsing
    group by all
)

select * from pivoted
