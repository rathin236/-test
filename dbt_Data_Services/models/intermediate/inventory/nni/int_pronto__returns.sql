with main as (
    select
        form_name,
        created_date,
        executionid,
        parse_json(json_data) as json_data
    from {{ ref('stg_pronto_forms__inventory') }}
    where form_name = 'NNI Returns - Dispatched Feed'
),

top_level_answers as (
    select
        main.executionid,
        main.created_date,
        main.form_name as form_type,
        main.json_data:name::string as form_name,
        answer.value:question::string as question,
        main.json_data:user:username::string as login_name,
        case
            when answer.value:controlType::string = 'BarcodeScanner' then all_val.value:data::string
            else all_val.value::string
        end as value
    from main,
        lateral flatten(input => main.json_data:pages) as page,
        lateral flatten(input => page.value:sections) as sec,
        lateral flatten(input => sec.value:answers) as answer,
        lateral flatten(input => answer.value:values) as all_val
),

nested_answers as (
    select
        main.executionid,
        nested_row.index as line_num,
        main.form_name as form_type,
        main.json_data:name::string as form_name,
        main.created_date,
        na.value:question::string as question,
        case
            when na.value:controlType::string = 'BarcodeScanner' then n_val.value:data::string
            else n_val.value::string
        end as value
    from
        main,
        lateral flatten(input => main.json_data:pages) as p,
        lateral flatten(input => p.value:sections) as s,
        lateral flatten(input => s.value:rows) as nested_row,
        lateral flatten(input => nested_row.value:pages) as n_page,
        lateral flatten(input => n_page.value:sections) as n_sec,
        lateral flatten(input => n_sec.value:answers) as na,
        lateral flatten(input => na.value:values) as n_val
),

return_header as (
    select
        executionid,
        created_date,
        form_type,
        form_name,
        login_name,
        max(case when question = 'Warehouse' then value end) as warehouse,
        max(case when question = 'Date' then value end) as dispatch_date,
        max(case when question = 'Returning Area' then value end) as returning_area,
        max(case when question = 'ReturningSite' then value end) as returning_site,
        max(case when question = 'Site Manager' then value end) as site_manager,
        max(case when question = 'Phone Number' then value end) as phone_number,
        max(case when question = 'Transport Carrier' then value end) as transport_carrier,
        max(case when question = 'Tractor Unit #' then value end) as tractor_unit,
        max(case when question = 'Trailer #' then value end) as trailer,
        max(case when question = 'Order #' then value end) as order_no,
        max(case when question = 'NNI Order #' then value end) as nni_order_no,
        max(case when question = 'Comments' then value end) as comments
    from
        top_level_answers
    group by all
),

return_line as (
    select
        executionid,
        line_num,
        max(case when question = 'LotNumber' then value end) as lot_number,
        max(case when question = 'ProductNumber' then value end) as product_number,
        max(case when question = 'PalletNumber' then value end) as pallet_number,
        max(case when question = 'ProductionDate' then value end) as production_date,
        max(case when question = 'Weight' then value end) as weight,
        max(case when question = 'Country' then value end) as country,
        max(case when question = 'Picked Inventory' then value end) as qr_code_data,
        max(case when question = 'Bag Size' then value end) as bag_size
    from nested_answers
    group by all
),

fact_return as (
    select
        hdr.executionid,
        hdr.created_date,
        hdr.form_name,
        hdr.form_type,
        hdr.warehouse,
        hdr.site_manager,
        hdr.phone_number,
        hdr.returning_area as location,
        hdr.dispatch_date,
        hdr.returning_area,
        hdr.returning_site,
        hdr.transport_carrier,
        hdr.tractor_unit,
        hdr.trailer,
        hdr.order_no,
        hdr.nni_order_no,
        hdr.comments,
        hdr.login_name,
        line.line_num,
        line.lot_number,
        line.product_number,
        line.pallet_number,
        line.production_date,
        line.weight,
        line.country,
        line.qr_code_data,
        line.bag_size
    from return_line as line

    inner join return_header as hdr
        on line.executionid = hdr.executionid
)

select * from fact_return
