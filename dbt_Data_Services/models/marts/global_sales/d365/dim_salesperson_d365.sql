with dir_person_name as (
    select * from {{ ref('stg_d365__dir_person_name') }}
),

sales_taker as (
    select * from {{ ref('stg_d365__hcm_worker') }}
),

dim_salesperson_d365 as (
    select

        sales_taker.recid as "Salesperson_SK",
        sales_taker.person as "Salesperson ID",
        dpn.firstname || ' ' || dpn.lastname as "Salesperson Name",
        null as "Email",
        iff(dpn.validto < current_date(), 1, 0) as "Is Inactive",
        null as "Data_Entity_Company_SK",
        null as salespersontypeen

    from sales_taker
    left join dir_person_name dpn 
    on sales_taker.person = dpn.person
    and sales_taker.dataareaid = dpn.dataareaid

    qualify row_number() over (partition by sales_taker.recid order by sales_taker.person) = 1

    order by dpn.firstname || ' ' || dpn.lastname
)

select * from dim_salesperson_d365
-- where "Salesperson_SK" = '5637205328'