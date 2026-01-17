with creation as (
    select
        executionid,
        form_type,
        created_date,
        qr_code_data,
        location,
        inventory_status as current_status,
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
        created_date,
        qr_code_data,
        location,
        inventory_status as current_status,
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
        created_date,
        qr_code_data,
        location,
        'In Transit' as current_status,
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
        created_date,
        qr_code_data,
        'N/A' as location,
        'Missing' as current_status,
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
        created_date,
        qr_code_data,
        location,
        'Returned' as current_status,
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

ranked as (
    select
        form_type,
        lot_number,
        product_number,
        pallet_number,
        created_date,
        production_date,
        location,
        weight,
        country,
        qr_code_data,
        bag_size,
        login_name,
        current_status,
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
        to_char(created_date, 'HH24:MI:00') as created_time
    from allforms
    where lot_number is not null
    qualify
        row_number() over (partition by qr_code_data order by created_date desc) = 1
),

delivered as (
    select
        ranked.form_type,
        ranked.lot_number,
        ranked.product_number,
        ranked.pallet_number,
        ranked.created_date,
        ranked.production_date,
        'Destination' as location,
        ranked.weight,
        ranked.country,
        ranked.qr_code_data,
        ranked.bag_size,
        ranked.login_name,
        'Delivered' as current_status,
        ranked.warehouse,
        ranked.dispatch_date,
        ranked.destination_area,
        ranked.destination_site,
        ranked.returning_area,
        ranked.returning_site,
        ranked.site_manager,
        ranked.phone_number,
        ranked.transport_carrier,
        ranked.tractor_unit,
        ranked.trailer,
        ranked.order_no,
        ranked.nni_order_no,
        ranked.comments,
        to_char(ranked.created_date, 'HH24:MI:00') as created_time
    from ranked

    left join inbound
        on ranked.order_no = inbound.order_no
            and ranked.current_status = 'In Transit'

    where inbound.order_no is not null
),

other as (
    select ranked.* from ranked

    left join delivered
        on ranked.qr_code_data = delivered.qr_code_data

    where delivered.qr_code_data is null
),

finalstatus as (
    select * from delivered
    union all
    select * from other
)

select
    *,
    (tractor_unit || ' : ' || trailer) as tractor_trailer
from finalstatus
