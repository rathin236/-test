with d365 as (
    select
        fct.pk_global_sales,
        fct.inventtransid,
        fct."Order ID",
        fct."Company",
        fct."Order Status ID",
        fct."Order_Type_SK",
        fct."Inventory Location ID",
        fct."Inventory Site ID",
        fct."Create Date",
        fct."Delivery Date",
        fct."Invoice Account",
        fct."Customer Invoice Date",
        fct."Customer Account",
        fct."Shipping Date Confirmed",
        fct."Shipping Date Requested",
        item."Item ID",
        fct."Salesperson_SK",
        fct."Flag_Price_Adjustment",
        fct."Invoice ID",
        fct."Ordered Amount",
        fct."Sales Amount",
        fct."Sales Price",
        fct."Invoice Amount",
        fct."Freight Rate",
        fct.ub_price_high,
        fct.ub_price_avg,
        fct.ub_price_low,
        fct."Ordered Qty",
        fct."Ordered Volume (Lbs)",
        fct."Sales Qty",
        fct."Sales Volume (Lbs)",
        fct."Invoice Volume (Lbs)",
        fct."Inv Qty",
        fct."Estimated Cost",
        fct."Posted Cost",
        fct."Adjusted Cost",
        fct."Settled Cost",
        fct."Rebates",
        fct."Returned Invoice",
        fct."Date Financial",
        fct."Financial Division ID",
        fct."Delivery Address ID",
        fct."Delivery Terms",
        fct."Customer PO",
        fct."Mode",
        fct."Last Data Refresh",
        fct."Exchange Rate (USD-CAD)",
        'D365' as sourcesystem,
        0 as sourcesystemcode,
        fct."Price UOM",
        fct."Weight UOM",
        upper(trim(fct."Sales Unit")) as "Sales Unit",
        upper(fct."Currency") as "Currency"

    from {{ ref('fact_cost_d365') }} as fct

    left join {{ ref('dim_item') }} as item
        on fct."Item ID" = item."Item ID"
            and item.sourcesystemcode = 0

),

ns as (
    select
        fct.pk_global_sales,
        fct.inventtransid,
        fct."Order ID",
        fct."Company",
        fct."Order Status ID",
        fct."Order_Type_SK",
        fct."Inventory Location ID",
        fct."Inventory Site ID",
        fct."Create Date",
        fct."Delivery Date",
        fct."Delivery Address ID" as "Invoice Account",
        fct."Customer Invoice Date",
        fct."Delivery Address ID" as "Customer Account",
        fct."Shipping Date Confirmed",
        fct."Shipping Date Requested",
        item."Item_SK" as "Item ID",
        fct."Salesperson_SK",
        fct."Flag_Price_Adjustment",
        fct."Invoice ID",
        fct."Ordered Amount",
        fct."Sales Amount",
        fct."Sales Price",
        fct."Invoice Amount",
        fct."Freight Rate",
        fct.ub_price_high,
        fct.ub_price_avg,
        fct.ub_price_low,
        fct."Ordered Qty",
        fct."Ordered Volume (Lbs)",
        fct."Sales Qty",
        fct."Sales Volume (Lbs)",
        fct."Invoice Volume (Lbs)",
        fct."Inv Qty",
        fct."Estimated Cost",
        fct."Posted Cost",
        fct."Adjusted Cost",
        fct."Settled Cost",
        fct.rebates,
        fct."Returned Invoice",
        fct."Date Financial",
        fct."Financial Division ID",
        fct."Delivery Address ID",
        fct."Delivery Terms",
        fct."Customer PO",
        fct."Mode",
        fct."Last Data Refresh",
        fct."Exchange Rate (USD-CAD)",
        'NORTHSCOPE' as sourcesystem,
        1 as sourcesystemcode,
        fct."Price UOM",
        fct."Weight UOM",
        upper(fct."Sales UOM") as "Sales Unit",
        upper(fct."Currency") as "Currency"

    from {{ ref('fact_cost_ns') }} as fct

    left join {{ ref('dim_item') }} as item
        on fct."Item_SK" = item."Item_SK"
            and item.sourcesystemcode = 1

),

sales_cost as (
    select * from d365
    union all
    select * from ns
),

final as (

    select
        fct.pk_global_sales,
        fct.inventtransid,
        fct."Order ID",
        fct."Item ID",
        fct."Create Date",
        fct."Customer Invoice Date",
        fct."Shipping Date Confirmed",
        fct."Shipping Date Requested",
        fct."Flag_Price_Adjustment",
        fct."Ordered Amount",
        fct."Sales Amount",
        fct."Sales Price",
        fct."Invoice Amount",
        fct."Freight Rate",
        fct.ub_price_high,
        fct.ub_price_avg,
        fct.ub_price_low,
        fct."Ordered Qty",
        fct."Ordered Volume (Lbs)",
        fct."Sales Qty",
        fct."Sales Volume (Lbs)",
        fct."Invoice Volume (Lbs)",
        fct."Inv Qty",
        fct."Estimated Cost",
        fct."Posted Cost",
        fct."Settled Cost",
        fct."Rebates",
        fct."Currency",
        fct."Returned Invoice",
        fct."Date Financial",
        fct."Financial Division ID",
        fct."Last Data Refresh",
        fct."Exchange Rate (USD-CAD)",
        fct.sourcesystemcode,
        fct."Delivery Terms",
        fct."Customer PO",
        fct."Price UOM",
        fct."Weight UOM",
        coalesce(fct."Adjusted Cost", 0) as "Adjusted Cost",
        case
            when fct.sourcesystemcode = 0
                then (fct."Sales Amount" + fct."Posted Cost" + coalesce(fct."Adjusted Cost", 0) - coalesce(fct."Rebates", 0))
        end as "Gross Margin",
        case
            when date_part('year', fct."Date Financial") = date_part('year', dateadd(day, -7, current_date))
                and date_part('week', fct."Date Financial") = date_part('week', dateadd(day, -7, current_date))
                then 'Previous Week'

            when date_part('year', fct."Date Financial") = date_part('year', dateadd(month, -1, current_date))
                and date_part('month', fct."Date Financial") = date_part('month', dateadd(month, -1, current_date))
                then 'Previous Month'

            when date_part('year', fct."Date Financial") = date_part('year', current_date)
                then 'Current Year'

            when date_part('year', fct."Date Financial") = date_part('year', current_date) - 1
                then 'Previous Year'

            else 'All'
        end as "Date Category",
        md5(concat(coalesce(upper(fct."Company"), 'blank'), fct.sourcesystem)) as sk_company_global,
        md5(concat(trim(cast(fct."Order Status ID" as int)), fct.sourcesystem)) as sk_order_status_id_global,
        md5(concat(fct."Order_Type_SK", fct.sourcesystem)) as sk_order_type_id_global,
        md5(concat(fct."Inventory Location ID", fct.sourcesystem)) as sk_warehouse_global,
        md5(concat(fct."Inventory Site ID", fct.sourcesystem)) as sk_site_global,
        md5(concat(fct."Salesperson_SK", fct.sourcesystem)) as sk_salesperson_global,
        md5(concat(fct."Sales Unit", fct.sourcesystem)) as sk_uom_global,
        md5(concat(fct."Mode", fct.sourcesystem)) as sk_mode_global,
        md5(concat(trim(fct."Item ID"), fct.sourcesystem)) as sk_item_global,
        md5(concat(fct."Invoice ID", fct.sourcesystem)) as sk_invoice_id_global,
        md5(concat(fct."Customer Account", fct.sourcesystem)) as sk_customer_id_global,
        md5(concat(fct."Invoice Account", fct.sourcesystem)) as sk_invoice_account_global,
        case
            when fct."Delivery Date" is not null
                then to_number(to_char(fct."Delivery Date", 'YYYYMMDD'))
            else to_number(to_char(fct."Create Date", 'YYYYMMDD'))
        end as "Delivery Date",
        case
            when fct."Shipping Date Requested" is not null
                then to_number(to_char(fct."Shipping Date Requested", 'YYYYMMDD'))
            else to_number(to_char(fct."Shipping Date Requested", 'YYYYMMDD'))
        end as "Ship Date"
    from sales_cost as fct
)

select * from final
