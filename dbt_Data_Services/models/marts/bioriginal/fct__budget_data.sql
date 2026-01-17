with budget_data as (
    select * from {{ ref("int_sort_data__unioned") }}
),

budget_data_totals as (
    select * from {{ ref("int_sort_data_budget_totals__unioned") }}
),

organized as (
    select  
        budget_data_totals."Sort", 
        budget_data_totals.t_atvs,
        trim(split_part(budget_data_totals.t_atvs,'    ', 1)) as "Sales Rep",
        trim(split_part(budget_data_totals.t_atvs,'    ', 2)) as "Customer",
        trim(split_part(budget_data_totals.t_atvs,'        ', 2)) as "Item",
        budget_data_totals."Year", 
        budget_data."Period", 
        budget_data."Inventory Unit",
        budget_data."Ordered Unit",
        budget_data."Price Unit",
        round(budget_data."Amount",2) as "Amount", 
        round(budget_data."COGS",2) as "COGS", 
        budget_data_totals."Company"
    from  budget_data_totals join budget_data on budget_data_totals.t_atvs = budget_data.t_atvs
    where budget_data."Inventory Unit" <> 0
    and   contains(upper(budget_data_totals."Sort"),'BG')
)
select * from organized
