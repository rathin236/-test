with company as (
    select {{ trim_columns_int('int_ereq__dim_company') }} 
    from {{ ref('int_ereq__dim_company') }} 
    where upper(companycode) = 'GMG'
),

-- Currency Mapping (Transactional & Functional)
currency_mapping as (
    select distinct 
        upper(trim(currnidx)) as currnidx, 
        upper(trim(curncyid)) as currency, 
        'Transactional' as curr_type 
    from {{ ref('stg_gp_gmg__mc020103') }}

    union

    select 
        upper(trim(funcridx)) as currnidx, 
        upper(trim(funlcurr)) as currency, 
        'Functional' as curr_type 
    from {{ ref('stg_gp_gmg__mc40000') }}
),

FXRates_CAD as (
    select * from {{ ref('dim_exchange_rates') }}
    where from_ccy = 'CAD' and to_ccy = 'USD'
    -- and fx_date = '2024-09-10'
),

po_active as (
    select * 
    from {{ ref("stg_gp_gmg__pop10110") }} where dex_row_ts > '2022-12-31'
),

po_historic as (
    select *
    from {{ ref("stg_gp_gmg__pop30110") }} where prmdate > '2022-12-31'
),

todays_rate as (
    select rate 
    from {{ ref('dim_exchange_rates') }} 
    where from_ccy = 'CAD' and to_ccy = 'USD' 
    and fx_date = current_date()
),

active_po_in_line as (
    select
        po_active.dex_row_id,
        po_active.dex_row_ts,
        (select companyid from company) as company_id,
        po_active.ord,
        po_active.ponumber as po_number,
        po_active.vendorid as vendor_id,
        po_active.itemnmbr as item_id,
        po_active.vnditnum as vend_item_id,
        po_active.doctype as document_type_id,
        cast(po_active.prmdate as date) as prm_date,
        cast(po_active.reqdate as date) as req_date,
        cast(po_active.releasebydate as date) as release_by_date,
        cast(po_active.released_date as date) as release_date,
        po_active.qtyorder as qty,
        po_active.umqtyinb,
        po_active.uofm as uom_id,
        po_active.unitcost as unit_cost,
        po_active.oruntcst as originating_unit_cost,
        po_active.orextcst as originating_extended_cost,
        po_active.ortaxamt as originating_tax_amount,
        po_active.extdcost as functional_extended_cost,
        po_active.taxamnt as functional_tax_amount,

        -- Correctly mapped Currency ID from the new mapping logic
        currency_mapping.currency as transaction_currency_id,
        -- currency_mapping.curr_type as currency_type,
        (select currency from currency_mapping where curr_type = 'Functional') as company_currency,

        -- Currency Conversion (Using mapped `transaction_currency_id`)
        {{ cad_current_rate('currency_mapping.currency', 'po_active.orextcst', 'FXRates_CAD.rate') }} 
        + {{ cad_current_rate('currency_mapping.currency', 'po_active.ortaxamt', 'FXRates_CAD.rate') }} as cad_amount,
        {{ usd_current_rate('currency_mapping.currency', 'po_active.orextcst', 'FXRates_CAD.rate') }} + 
        {{ usd_current_rate('currency_mapping.currency', 'po_active.ortaxamt', 'FXRates_CAD.rate') }} as usd_amount,

        'active' as source
    from po_active
    left join currency_mapping 
        on po_active.currnidx = currency_mapping.currnidx  -- Mapping to get transaction currency
    left join FXRates_CAD 
        on po_active.prmdate = FXRates_CAD.fx_date
),

historic_po_in_line as (
    select
        po_historic.dex_row_id,
        po_historic.dex_row_ts,
        (select companyid from company) as company_id,
        po_historic.ord,
        po_historic.ponumber as po_number,
        po_historic.vendorid as vendor_id,
        po_historic.itemnmbr as item_id,
        po_historic.vnditnum as vend_item_id,
        po_historic.doctype as document_type_id,
        cast(po_historic.prmdate as date) as prm_date,
        cast(po_historic.reqdate as date) as req_date,
        cast(po_historic.releasebydate as date) as release_by_date,
        cast(po_historic.released_date as date) as release_date,
        po_historic.qtyorder as qty,
        po_historic.umqtyinb,
        po_historic.uofm as uom_id,
        po_historic.unitcost as unit_cost,
        po_historic.oruntcst as originating_unit_cost,
        po_historic.orextcst as originating_extended_cost,
        po_historic.ortaxamt as originating_tax_amount,
        po_historic.extdcost as functional_extended_cost,
        po_historic.taxamnt as functional_tax_amount,

        -- Correctly mapped Currency ID from the new mapping logic
        currency_mapping.currency as transaction_currency_id,
        -- currency_mapping.curr_type as currency_type,
        (select currency from currency_mapping where curr_type = 'Functional') as company_currency,

        -- Currency Conversion (Using mapped `transaction_currency_id`)
        {{ cad_current_rate('currency_mapping.currency', 'po_historic.orextcst', 'FXRates_CAD.rate') }} 
        + {{ cad_current_rate('currency_mapping.currency', 'po_historic.ortaxamt', 'FXRates_CAD.rate') }} as cad_amount,
        {{ usd_current_rate('currency_mapping.currency', 'po_historic.orextcst', 'FXRates_CAD.rate') }} + 
        {{ usd_current_rate('currency_mapping.currency', 'po_historic.ortaxamt', 'FXRates_CAD.rate') }} as usd_amount,

        'historic' as source
    from po_historic
    left join currency_mapping 
        on po_historic.currnidx = currency_mapping.currnidx  -- Mapping to get transaction currency
    left join FXRates_CAD 
        on po_historic.prmdate = FXRates_CAD.fx_date
),


all_po_in_line as (
    select * from active_po_in_line
    union all
    select * from historic_po_in_line
)

select * from all_po_in_line
