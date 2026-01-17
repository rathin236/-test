with wm_production_line_def as (
    select * from {{ ref('stg_coolearth__wm_production_line_def') }}
),

int_tn_fresh_yield_reporting__dim_production_line_ns as (
    select
        company as "Company",
        warehouse as "Warehouse",
        linekey as "LineNumber",
        linedescription as "Full Line Description",
        substring(linedescription, charindex('- ', linedescription) + 1, len(linedescription)) as "LineDescription",
        'CE_' || linekey as "Key_Line"

    from wm_production_line_def

    where company = 'TNS'
)

select * from int_tn_fresh_yield_reporting__dim_production_line_ns
