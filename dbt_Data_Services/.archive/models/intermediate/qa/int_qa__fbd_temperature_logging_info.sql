with fbd_temp_log as (

    select * from {{ ref('stg_inspec_fbd__qcfbdtemperaturelogginginformation') }}

),

filtered as (

    select * from fbd_temp_log
    where status_workflow = 'Finished'

),

transformed as (

    select

        _id as form_id,
        officialtime as created_at,
        customerordersubform_customer as customer_name,
        customerordersubform_salesorder as sales_order_id,
        productdescription as product_description,
        temperatures_fresh as fresh_temperature,
        temperatures_frozen as frozen_temperature,
        context_plant as facility

    from filtered

),

organized as (

    select

        --pk
        form_id,

        --fk
        sales_order_id,

        --details

        ----strings
        customer_name,
        product_description,
        facility,

        ----numerics
        fresh_temperature,
        frozen_temperature,

        ----booleans

        ----dates

        ----timestamps
        created_at

        --metadata

    from transformed

)

select * from organized
