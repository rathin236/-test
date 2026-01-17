{% set sql_statement %}
    select datefromparts(year(current_date), month(current_date), 1) as first_date limit 1
{% endset %}

{%- set first_curr_month = dbt_utils.get_single_value(sql_statement) -%}

{% set sql_statement_2 %}
    select cad_usd from {{ ref('dim__exchange_rates') }} where date_day = current_date
{% endset %}

{%- set curr_cad_usd = dbt_utils.get_single_value(sql_statement_2) -%}


{% set sql_statement_3 %}
    select eur_usd from {{ ref('dim__exchange_rates') }} where date_day = current_date
{% endset %}

{%- set curr_eur_usd = dbt_utils.get_single_value(sql_statement_3) -%}

{% set sql_statement_4 %}
    select jpy_usd from {{ ref('dim__exchange_rates') }} where date_day = current_date
{% endset %}

{%- set curr_jpy_usd = dbt_utils.get_single_value(sql_statement_4) -%}


with orders as (

    select * from {{ ref("int_sales_order_fullfillment_workbench__unioned") }}

),

cogs as (

    select * from {{ ref("int_sales_order_actual_delivery_line__unioned") }}

),

so_status as (

    select * from {{ ref("int_sales_order_status__unioned") }}

),

conversion as (

    select * from {{ ref("dim__exchange_rates") }}

),

consingment as (

    select * from {{ ref("int_consingment_orders__unioned") }}
),

orders_filtered as (

    select * from orders where year(invoice_date) >= 2020 or year(invoice_date) = 1970 and canceled_order = 2

),

cogs_joined as (

    select

        orders_filtered.order_number,
        orders_filtered.line_number,
        orders_filtered.sequence_number,
        item_number,
        total_amount_sales_currency,
        quantity,
        sales_unit,
        customer_bp_id,
        invoice_date,
        fx_rate_to_home_curr,
        orders_filtered.company_code,
        price_sales_currency,
        total_cogs_home_currency,
        contract_number

    from orders_filtered
    left outer join cogs on orders_filtered.order_number = cogs.order_number
        and orders_filtered.line_number = cogs.line_number
        and orders_filtered.sequence_number = cogs.sequence_number

),

so_sales_curr_joined as (

    select

        cogs_joined.order_number,
        line_number,
        sequence_number,
        item_number,
        total_amount_sales_currency,
        quantity,
        sales_unit,
        customer_bp_id,
        invoice_date,
        fx_rate_to_home_curr,
        company_code,
        price_sales_currency,
        total_cogs_home_currency,
        so_status.sales_currency,
        contract_number,
        delivery_date,
        sales_order_status

    from cogs_joined
    left outer join so_status on cogs_joined.order_number = so_status.order_number

),

consingment_joined as (

    select

        so_sales_curr_joined.order_number,
        so_sales_curr_joined.line_number,
        so_sales_curr_joined.sequence_number,
        item_number,
        total_amount_sales_currency,
        so_sales_curr_joined.quantity,
        sales_unit,
        customer_bp_id,
        invoice_date,
        fx_rate_to_home_curr,
        company_code,
        price_sales_currency,
        total_cogs_home_currency,
        sales_currency,
        contract_number,
        purchase_order_number,
        purchase_order_line,
        warehouse_number,
        whs_type,
        purchase_order_amount,
        purchase_order_currency,
        delivery_date,
        sales_order_status

    from so_sales_curr_joined
    left outer join consingment
        on so_sales_curr_joined.order_number = consingment.order_number
            and so_sales_curr_joined.line_number = consingment.line_number
            and so_sales_curr_joined.sequence_number = consingment.sequence_number
),

add_keys as (


    select

        order_number || line_number || sequence_number || company_code as order_line_seq_comp_key,
        order_number,
        line_number,
        sequence_number,
        item_number,
        sales_currency,
        total_amount_sales_currency,
        quantity,
        sales_unit,
        customer_bp_id,
        invoice_date,
        fx_rate_to_home_curr,
        company_code,
        price_sales_currency,
        total_cogs_home_currency,
        contract_number,
        purchase_order_number,
        purchase_order_line,
        warehouse_number,
        whs_type,
        purchase_order_amount,
        purchase_order_currency,
        delivery_date,
        item_number::string || '_' || company_code::string as item_key,
        date(invoice_date) as date_key,
        sales_order_status

    from consingment_joined

),

conversion_joined as (

    select

        order_line_seq_comp_key,
        order_number,
        line_number,
        sequence_number,
        item_number,
        total_amount_sales_currency,
        quantity,
        sales_unit,
        customer_bp_id,
        invoice_date,
        fx_rate_to_home_curr,
        company_code,
        price_sales_currency,
        total_cogs_home_currency,
        sales_currency,
        contract_number,
        purchase_order_number,
        purchase_order_line,
        warehouse_number,
        whs_type,
        purchase_order_amount,
        purchase_order_currency,
        item_key,
        date_key,
        coalesce(cad_usd, '{{ curr_cad_usd }}') as cad_usd,
        coalesce(eur_usd, '{{ curr_eur_usd }}') as eur_usd,
        coalesce(jpy_usd, '{{ curr_jpy_usd }}') as jpy_usd,
        delivery_date,
        sales_order_status

    from add_keys
    left outer join conversion on add_keys.date_key = conversion.date_day

),

converted as (

    select

        order_line_seq_comp_key,
        order_number,
        line_number,
        sequence_number,
        item_number,
        total_amount_sales_currency,
        quantity,
        sales_unit,
        customer_bp_id,
        invoice_date,
        fx_rate_to_home_curr,
        company_code,
        price_sales_currency,
        total_cogs_home_currency,
        sales_currency,
        contract_number,
        purchase_order_number,
        purchase_order_line,
        warehouse_number,
        whs_type,
        purchase_order_amount,
        purchase_order_currency,
        item_key,
        date_key,
        cad_usd,
        eur_usd,
        jpy_usd,
        delivery_date,
        case
            when sales_currency = 'USD' then total_amount_sales_currency
            when sales_currency = 'CAD' then round(total_amount_sales_currency * cad_usd, 2)
            when sales_currency = 'JPY' then round(total_amount_sales_currency * jpy_usd, 2)
            when sales_currency = 'EUR' then round(total_amount_sales_currency * eur_usd, 2)
            else 0
        end as total_amount_usd,
        case
            when company_code = 100 then round(total_cogs_home_currency * cad_usd, 2)
            when company_code = 200 then round(total_cogs_home_currency * eur_usd, 2)
            when company_code = 600 then round(total_cogs_home_currency * jpy_usd, 2)
            else 0
        end as total_cogs_usd,
        (total_amount_usd - total_cogs_usd) as margin_usd,
        case
            when total_amount_usd = 0 then 0
            else ((total_amount_usd - total_cogs_usd) / total_amount_usd)
        end as margin_percent,
        case
            when purchase_order_currency = 'CAD' then round(purchase_order_amount * cad_usd, 2)
            when purchase_order_currency = 'EUR' then round(purchase_order_amount * eur_usd, 2)
            when purchase_order_currency = 'JPY' then round(purchase_order_amount * jpy_usd, 2)
            else purchase_order_amount
        end as consingment_cogs_usd,
        case
            when whs_type = 21 then '1' else '0'
        end as consingment_flag,
        sales_order_status


    from conversion_joined

),

organized as (

    select

        order_line_seq_comp_key,
        order_number,
        line_number,
        sequence_number,
        company_code,
        customer_bp_id,
        contract_number,
        item_number,
        delivery_date,
        quantity,
        sales_unit,
        sales_currency,
        total_amount_sales_currency,
        total_amount_usd,
        price_sales_currency,
        total_cogs_home_currency,
        margin_usd,
        margin_percent,
        cad_usd,
        eur_usd,
        jpy_usd,
        date_key,
        item_key,
        consingment_flag,
        case
            when year(invoice_date) = 1970 then null
            else invoice_date
        end as invoice_date,
        case
            when consingment_flag = '0' then total_cogs_usd
            else consingment_cogs_usd
        end as total_cogs_usd,
        case
            when len(contract_number) > 0 then 'Contract' else 'No Contract'
        end as contract_flag,
        case
            when sales_order_status in ('5', '10', '25', '40')
                then '1'

            else '0'
        end as open_order_flag,
        case
            when year(invoice_date) = 1970
                and delivery_date >= '{{ first_curr_month }}'
                and delivery_date < dateadd('month', 6, '{{ first_curr_month }}') then '1'
            else '0'
        end as six_months_flag
    from converted
)

select * from organized
