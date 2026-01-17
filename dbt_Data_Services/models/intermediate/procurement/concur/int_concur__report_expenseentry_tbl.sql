with reports as (
    select * from {{ ref('stg_concur__report') }}
),

expentry as (
    select * from {{ ref('stg_concur__expense_entry') }}
),

-- location as (
--     select * from {{ ref('stg_concur__location') }}
-- ),

-- users as (
--     select * from {{ ref('stg_concur__user') }}
-- ),

allocation as (
    select * from {{ ref('stg_concur__allocation') }}
),

itemization as (
    select * from {{ ref('stg_concur__itemization') }}
),

-- paymenttype as (
--     select * from {{ ref('stg_concur__payment_type') }}
-- ),

currency as (
    select * from {{ ref('dim__daily_exchange_rates') }}
    where from_ccy = 'USD'
        and to_ccy = 'CAD'
),

fact as (
    select
        rep.id as report_id, --fk
        rep.policy_id, --fk
        rep.currency_code as homecurrency,
        exp.entry_id, --fk
        exp.payment_type_name,
        exp.expense_type_id, --fk
        exp.exchange_rate,
        exp.location_country,
        exp.location_name,
        exp.business_purpose,
        coalesce(ite.location_id, '**Not Itemized**') as location_id,
        coalesce(ite.expense_type_name, exp.expense_type_name) as expense_type_name,
        coalesce(ite.transaction_date, exp.transaction_date) as transaction_date,
        coalesce(exp.vendor_description, '**No Vendor Specified**') as vendor_description,
        coalesce(alo.allocation_id, '**Not Itemized/Not Allocated**') as allcoation_id,
        coalesce(alo.percentage, 1.0) as percentage,
        coalesce(ite.itemization_id, '**Not itemized**') as itemization_id,
        coalesce(ite.spend_category_name, exp.spend_category) as spend_category,
        coalesce(ite.description, '**No Spend Description**') as spend_description,
        coalesce(ite.glaccount, exp.glaccount) as glaccount,
        coalesce(ite.companyname, exp.companyname) as companyname,
        coalesce(ite.company_code, exp.company_code) as company_code,
        coalesce(ite.department, exp.department) as department,
        coalesce(ite.department_code, exp.department_code) as department_code,
        coalesce(ite.costcenter, exp.costcenter) as costcenter,
        coalesce(ite.costcenter_code, exp.costcenter_code) as costcenter_code,
        coalesce(ite.approved_amount * alo.percentage, exp.approved_amount * 1.0) as approved_amount_homecurr,
        coalesce(ite.transaction_amount * alo.percentage, exp.transaction_amount) as transaction_amount_transcurr,
        round(coalesce(ite.transaction_amount * exp.exchange_rate * alo.percentage, exp.transaction_amount * exp.exchange_rate * 1.0), 2)
            as transaction_amount_homecurr,
        case when rep.currency_code = 'USD'
                then round(coalesce(ite.approved_amount * alo.percentage * cur.rate, exp.approved_amount * cur.rate), 2)
            else coalesce(ite.approved_amount * alo.percentage, exp.approved_amount * 1.0)
        end as approved_amount_cad,
        case when rep.currency_code = 'USD'
                then round(
                        coalesce(
                            ite.transaction_amount * exp.exchange_rate * alo.percentage * cur.rate,

                            exp.transaction_amount * exp.exchange_rate * cur.rate
                        ), 2
                    )
            else round(coalesce(ite.transaction_amount * exp.exchange_rate * alo.percentage, exp.transaction_amount * exp.exchange_rate * 1.0), 2)
        end as transaction_amount_cad
        ---using coalesce and multiplication with 1.0 for non-itemized items, and coz approved amount is always in homecurrency so no need to convert
    from reports as rep

    inner join expentry as exp
        on rep.id = exp.report_id

    left join itemization as ite
        on exp.entry_id = ite.expense_entry_id

    left join allocation as alo
        on ite.itemization_id = alo.itemization_id

    left join currency as cur
        on cur.key_date = coalesce(cast(ite.transaction_date as date), cast(exp.transaction_date as date))
            and rep.currency_code = cur.from_ccy
),

allfact as (
    select
        fact.*,
        case
            when position('-' in expense_type_name) > 0
                then
                    trim(
                        case
                            when position('(' in substring(fact.expense_type_name, position('-' in expense_type_name) + 1)) > 2
                                then
                                    left(
                                        substring(fact.expense_type_name, position('-' in expense_type_name) + 1),
                                        position('(' in substring(fact.expense_type_name, position('-' in expense_type_name) + 1)) - 2
                                    )
                            else
                                substring(fact.expense_type_name, position('-' in expense_type_name) + 1)
                        end
                    )
            else fact.expense_type_name
        end as expense_group,
        case
            when expense_group ilike '%building improvement%' then 'Building Improvements'
            when expense_group ilike '%cip - building%' then 'CIP - Building'
            when expense_group ilike '%cip - vessels%' then 'CIP - Vessels'
            when expense_group ilike '%compliance - environmental%' then 'Compliance - Environmental'
            when expense_group ilike '%computer hardware%' then 'Computer Hardware'
            when expense_group ilike '%computer software%'
                or expense_group ilike '%software licenses%' then 'Computer Software'
            when expense_group ilike '%customer meals%'
                or expense_group ilike '%customer relations%' then 'Customer Relations'
            when expense_group ilike '%dues%' and expense_group ilike '%subscription%' then 'Dues and Subscriptions'
            when expense_group ilike '%employee event%' then 'Employee Events'
            when expense_group ilike '%lease%' and expense_group ilike '%equipment%' then 'Equipment Leases & Rentals'
            when expense_group ilike '%boat repairs%'
                or expense_group ilike '%equipment repairs%' then 'Equipment Repairs and Maintenance'
            when expense_group ilike '%ferry%' or expense_group ilike '%tolls%' then 'Ferry Charges'
            when expense_group ilike '%fuel%' or expense_group ilike '%gas%' then 'Fuel'
            when expense_group ilike '%license%' and expense_group ilike '%fee%' then 'Licenses and Fees'
            when expense_group ilike '%accommodation%' or expense_group ilike '%lodging%' then 'Lodging'
            when expense_group ilike '%meal%' or expense_group ilike '%entertainment%' then 'Meals and Entertainment'
            when expense_group ilike '%mileage%' then 'Mileage'
            when expense_group ilike '%office%' and expense_group ilike '%rent%' then 'Office & Building Rentals'
            when expense_group ilike '%parking%' then 'Parking'
            when expense_group ilike '%postage%' or expense_group ilike '%courier%' then 'Postage and Couriers'
            when expense_group ilike '%property repairs%' then 'Property Repairs and Maintenance'
            when expense_group ilike '%research materials%' then 'Research Materials'
            when expense_group ilike '%packaging%' or expense_group ilike '%product development%' then 'Packaging & Product Development'
            when expense_group ilike '%phone%' or expense_group ilike '%telephone%' then 'Phone'
            when expense_group ilike '%security%' or expense_group ilike '%safety%' then 'Security'
            when expense_group ilike '%sample%' then 'Samples'
            when expense_group ilike '%testing%' or expense_group ilike '%inspection%' then 'Testing and Inspection'
            when expense_group ilike '%training%' then 'Training'
            when expense_group ilike '%airfare%' then 'Travel - Airfare'
            when expense_group ilike '%travel - car rentals%'
                or expense_group ilike '%taxi%'
                or expense_group ilike '%train%'
                or expense_group ilike '%bus%'
                or expense_group ilike '%ferry%' then 'Travel - Car Rentals, Taxis, Train, Bus, Ferry, etc'
            when expense_group ilike '%travel other%' then 'Travel - Other'
            when expense_group ilike '%vehicle repairs%' then 'Vehicle Repairs and Maintenance'
            when expense_group ilike '%vessel%' then 'Vessels'
            when expense_group ilike '%warehouse storage%' then 'Warehouse Storage'
            when expense_group ilike '%waste disposal%' then 'Waste Disposal'
            when expense_group ilike '%water%' and expense_group ilike '%sewer%' then 'Water & Sewer'
            when expense_group ilike '%website%' then 'Website'
            else expense_group
        end as expense_group_rollup,
        concat(fact.glaccount, ' - ', fact.costcenter_code, ' - ', fact.department_code) as spend_code
    from fact
)

select * from allfact
