with creation as (
    select
        executionid,
        form_type,
        form_name,
        created_date,
        qr_code_data,
        inventory_status as status,
        lot_number,
        product_number,
        pallet_number,
        production_date,
        weight,
        country,
        bag_size,
        login_name,
        'N/A' as warehouse,
        'N/A' as dispatch_date,
        'N/A' as destination_area,
        'N/A' as destination_site,
        'N/A' as returning_area,
        'N/A' as returning_site,
        'N/A' as site_manager,
        'N/A' as phone_number,
        'N/A' as transport_carrier,
        'N/A' as tractor_unit,
        'N/A' as trailer,
        'N/A' as order_no,
        'N/A' as nni_order_no,
        'N/A' as comments
    from {{ ref('int_pronto__inv_creation') }}
),

stupdate as (
    select
        executionid,
        form_type,
        form_name,
        created_date,
        qr_code_data,
        inventory_status as status,
        lot_number,
        product_number,
        pallet_number,
        production_date,
        weight,
        country,
        bag_size,
        login_name,
        'N/A' as warehouse,
        'N/A' as dispatch_date,
        'N/A' as destination_area,
        'N/A' as destination_site,
        'N/A' as returning_area,
        'N/A' as returning_site,
        'N/A' as site_manager,
        'N/A' as phone_number,
        'N/A' as transport_carrier,
        'N/A' as tractor_unit,
        'N/A' as trailer,
        'N/A' as order_no,
        'N/A' as nni_order_no,
        'N/A' as comments
    from {{ ref('int_pronto__status_update') }}
),

outbound as (
    select
        executionid,
        form_type,
        form_name,
        created_date,
        qr_code_data,
        'In Transit' as status,
        lot_number,
        product_number,
        pallet_number,
        production_date,
        weight,
        country,
        bag_size,
        login_name,
        warehouse,
        dispatch_date,
        destination_area,
        destination_site,
        'N/A' as returning_area,
        'N/A' as returning_site,
        site_manager,
        phone_number,
        transport_carrier,
        tractor_unit,
        trailer,
        order_no,
        nni_order_no,
        comments
    from {{ ref('int_pronto__outbound') }}
),

inbound as (
    select
        executionid,
        form_type,
        form_name,
        created_date,
        qr_code_data,
        'Missing' as status,
        lot_number,
        product_number,
        pallet_number,
        production_date,
        weight,
        country,
        bag_size,
        login_name,
        warehouse,
        'N/A' as dispatch_date,
        'N/A' as destination_area,
        'N/A' as destination_site,
        'N/A' as returning_area,
        'N/A' as returning_site,
        'N/A' as site_manager,
        'N/A' as phone_number,
        'N/A' as transport_carrier,
        'N/A' as tractor_unit,
        'N/A' as trailer,
        'N/A' as order_no,
        nni_order_no,
        comments
    from {{ ref('int_pronto__inbound') }}
),

returns as (
    select
        executionid,
        form_type,
        form_name,
        created_date,
        qr_code_data,
        'Returned' as status,
        lot_number,
        product_number,
        pallet_number,
        production_date,
        weight,
        country,
        bag_size,
        login_name,
        warehouse,
        dispatch_date,
        'N/A' as destination_area,
        'N/A' as destination_site,
        returning_area,
        returning_site,
        site_manager,
        phone_number,
        transport_carrier,
        tractor_unit,
        trailer,
        order_no,
        nni_order_no,
        comments
    from {{ ref('int_pronto__returns') }}
),

allforms as (
    select * from creation
    union all
    select * from stupdate
    union all
    select * from outbound
    union all
    select * from inbound
    union all
    select * from returns
),

alltrans as (
    select
        executionid,
        form_type,
        form_name,
        created_date,
        qr_code_data,
        status,
        lot_number,
        product_number,
        pallet_number,
        production_date,
        weight,
        country,
        bag_size,
        login_name,
        warehouse,
        dispatch_date,
        destination_area,
        destination_site,
        returning_area,
        returning_site,
        site_manager,
        phone_number,
        transport_carrier,
        tractor_unit,
        trailer,
        order_no,
        nni_order_no,
        comments,
        to_char(created_date, 'HH24:MI:00') as created_time,
        row_number() over (partition by form_type, qr_code_data order by 1) as dedupe_error
    from allforms
    where lot_number is not null
)

select * from alltrans
