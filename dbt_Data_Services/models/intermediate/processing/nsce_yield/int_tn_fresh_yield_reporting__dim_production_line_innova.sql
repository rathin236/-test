with proc_plots as (
    select * from {{ ref('stg_innova_fbdag__proc_plots') }}
),

int_tn_fresh_yield_reporting__dim_production_line_innova as (
    select distinct

        'TNS' as "Company",
        'FBD' as "Warehouse",
        plot.code as "LineNumber",
        case
            when plot.code in ('1009', '2009')
                then 'FBD - Skinless'
            when plot.code in ('1010', '2010')
                then 'FBD - Deep Skinless'
            when plot.code in ('1011', '2011')
                then 'FBD - Full Deep Skinless'
        end as "Full Line Description",
        case
            when plot.code in ('1009', '2009')
                then 'Skinless'
            when plot.code in ('1010', '2010')
                then 'Deep Skinless'
            when plot.code in ('1011', '2011')
                then 'Full Deep Skinless'
        end as "LineDescription",
        'QCScanner_' || plot.code as "Key_Line"

    from proc_plots as plot

    where
        plot.code in ('1009', '2009', '1010', '1011', '2010', '2011')
)

select * from int_tn_fresh_yield_reporting__dim_production_line_innova
