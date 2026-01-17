WITH company AS (
    SELECT {{ trim_columns_int('int_ereq__dim_company') }} 
    FROM {{ ref('int_ereq__dim_company') }} 
    WHERE companycode = 'TNS'
),

-- Currency Mapping (Transactional & Functional)
currency_mapping AS (
    SELECT DISTINCT 
        upper(trim(currnidx)) as currnidx, 
        upper(trim(curncyid)) as currency, 
        'Transactional' AS curr_type 
    FROM {{ ref('stg_gp_tns__mc020103') }}

    UNION

    SELECT 
        upper(trim(funcridx)) AS currnidx, 
        upper(trim(funlcurr)) AS currency, 
        'Functional' AS curr_type 
    FROM {{ ref('stg_gp_tns__mc40000') }}
),

FXRates_CAD AS (
    SELECT * FROM {{ ref('dim_exchange_rates') }}
    WHERE from_ccy = 'CAD' AND to_ccy = 'USD'
    -- and fx_date = '2024-09-10'
),

po_active AS (
    SELECT {{ trim_columns_int('stg_gp_tns__pop10110') }} 
    FROM {{ ref("stg_gp_tns__pop10110") }} where year(prmdate) > 2023
),

po_historic AS (
    SELECT {{ trim_columns_int('stg_gp_kcs__pop30110') }} 
    FROM {{ ref("stg_gp_kcs__pop30110") }} where year(prmdate) > 2023
),

todays_rate AS (
    SELECT rate 
    FROM {{ ref('dim_exchange_rates') }} 
    WHERE from_ccy = 'CAD' AND to_ccy = 'USD' 
    AND fx_date = CURRENT_DATE()
),

active_po_in_line AS (
    SELECT
        po_active.dex_row_id,
        po_active.dex_row_ts,
        (SELECT companyid FROM company) AS company_id,
        po_active.ord,
        po_active.ponumber AS po_number,
        po_active.vendorid AS vendor_id,
        po_active.itemnmbr AS item_id,
        po_active.vnditnum AS vend_item_id,
        po_active.doctype AS document_type_id,
        CAST(po_active.prmdate AS DATE) AS prm_date,
        CAST(po_active.reqdate AS DATE) AS req_date,
        CAST(po_active.releasebydate AS DATE) AS release_by_date,
        CAST(po_active.released_date AS DATE) AS release_date,
        po_active.qtyorder AS qty,
        po_active.umqtyinb,
        po_active.uofm AS uom_id,
        po_active.unitcost AS unit_cost,
        po_active.oruntcst AS originating_unit_cost,
        po_active.orextcst AS originating_extended_cost,
        po_active.ortaxamt AS originating_tax_amount,
        po_active.extdcost AS functional_extended_cost,
        po_active.taxamnt AS functional_tax_amount,

        -- Correctly mapped Currency ID from the new mapping logic
        currency_mapping.currency AS transaction_currency_id,
        -- currency_mapping.curr_type AS currency_type,
        (SELECT currency FROM currency_mapping WHERE curr_type = 'Functional') AS company_currency,

        -- Currency Conversion (Using mapped `transaction_currency_id`)
        {{ cad_current_rate('currency_mapping.currency', 'po_active.orextcst', 'FXRates_CAD.rate') }} 
        + {{ cad_current_rate('currency_mapping.currency', 'po_active.ortaxamt', 'FXRates_CAD.rate') }} AS cad_amount,
        {{ usd_current_rate('currency_mapping.currency', 'po_active.orextcst', 'FXRates_CAD.rate') }} + 
        {{ usd_current_rate('currency_mapping.currency', 'po_active.ortaxamt', 'FXRates_CAD.rate') }} AS usd_amount,

        'active' AS source
    FROM po_active
    LEFT JOIN currency_mapping 
        ON po_active.currnidx = currency_mapping.currnidx  -- Mapping to get transaction currency
    LEFT JOIN FXRates_CAD 
        ON po_active.prmdate = FXRates_CAD.fx_date
),

historic_po_in_line AS (
    SELECT
        po_historic.dex_row_id,
        po_historic.dex_row_ts,
        (SELECT companyid FROM company) AS company_id,
        po_historic.ord,
        po_historic.ponumber AS po_number,
        po_historic.vendorid AS vendor_id,
        po_historic.itemnmbr AS item_id,
        po_historic.vnditnum AS vend_item_id,
        po_historic.doctype AS document_type_id,
        CAST(po_historic.prmdate AS DATE) AS prm_date,
        CAST(po_historic.reqdate AS DATE) AS req_date,
        CAST(po_historic.releasebydate AS DATE) AS release_by_date,
        CAST(po_historic.released_date AS DATE) AS release_date,
        po_historic.qtyorder AS qty,
        po_historic.umqtyinb,
        po_historic.uofm AS uom_id,
        po_historic.unitcost AS unit_cost,
        po_historic.oruntcst AS originating_unit_cost,
        po_historic.orextcst AS originating_extended_cost,
        po_historic.ortaxamt AS originating_tax_amount,
        po_historic.extdcost AS functional_extended_cost,
        po_historic.taxamnt AS functional_tax_amount,

        -- Correctly mapped Currency ID from the new mapping logic
        currency_mapping.currency AS transaction_currency_id,
        -- currency_mapping.curr_type AS currency_type,
        (SELECT currency FROM currency_mapping WHERE curr_type = 'Functional') AS company_currency,

        -- Currency Conversion (Using mapped `transaction_currency_id`)
        {{ cad_current_rate('currency_mapping.currency', 'po_historic.orextcst', 'FXRates_CAD.rate') }} 
        + {{ cad_current_rate('currency_mapping.currency', 'po_historic.ortaxamt', 'FXRates_CAD.rate') }} AS cad_amount,
        {{ usd_current_rate('currency_mapping.currency', 'po_historic.orextcst', 'FXRates_CAD.rate') }} + 
        {{ usd_current_rate('currency_mapping.currency', 'po_historic.ortaxamt', 'FXRates_CAD.rate') }} AS usd_amount,

        'historic' AS source
    FROM po_historic
    LEFT JOIN currency_mapping 
        ON po_historic.currnidx = currency_mapping.currnidx  -- Mapping to get transaction currency
    LEFT JOIN FXRates_CAD 
        ON po_historic.prmdate = FXRates_CAD.fx_date
),


all_po_in_line AS (
    SELECT * FROM active_po_in_line
    UNION ALL
    SELECT * FROM historic_po_in_line
)

SELECT * FROM all_po_in_line 

