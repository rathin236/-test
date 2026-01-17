with main as (
    select 
        *
    from {{ ref('stg_easyvista__contracts') }}
    where status ='Active'
),
usd_curr as (
    select
        key_date,
        min(to_ccy) as to_ccy,
        min(from_ccy) as from_ccy,
        min(rate) AS rate
    from {{ ref('dim__daily_exchange_rates') }}
    where from_ccy in ('USD')
    and to_ccy = 'CAD'
    group by key_date
),
flattened as (
    select
        transactionid,
        insert_date,
        record.value:"ASSET_ID"::string as contract_id, 
        record.value:"Account Manager"::string as account_manager,
        record.value:"Contract Number"::string as contract_number,
        record.value:"App Owner"::string as app_owner,
        record.value:"Currency"::string as currency,
        record.value:"Description"::string as supplier_description,
        record.value:"Reference"::string as reference,
        record.value:"Scheduled Expiration"::string as expiration_date,
        record.value:"Start Date"::string as start_date,
        record.value:"SUPPLIER_ID"::string as supplier_id,
        record.value:"Supplier"::string as supplier_name,
        record.value:"Sup Type"::string as supplier_type,
        record.value:"Vendor Category"::string as supplier_category,
        replace(record.value:"Total Cost"::string, ',', '') as total_cost,
        record.value:"Renewal Decision"::string as renewal_decision,
        record.value:"Vendor_ID"::string as vendor_id,
        record.value:"Priority Vendor"::string as priority_vendor,
        record.value:"Company"::string as company,
        record.value:"Type (Last Level)"::string as type_last_level,
        record.value:"Case Number"::string as case_number,
        record.value:"Case Status"::string as case_status, 
        record.value:"MSA"::string as msa,
        record.value:"VRA"::string as vra,
        record.value:"TFC"::string as tfc,
        record.value:"P":"O. Number"::string as po_number,
        record.value:"Duration (Months)"::string as duration_months
    from main,
    lateral flatten(input => main.json_data:records) as record
),
conversion as (
    select
        contract.transactionid,
        contract.insert_date,
        contract.contract_id, 
        contract.account_manager,
        contract.contract_number,
        contract.app_owner,
        contract.currency as currency_base,
        contract.supplier_description,
        contract.reference,
        contract.expiration_date,
        contract.start_date,
        contract.supplier_id,
        contract.supplier_name,
        contract.supplier_type,
        contract.supplier_category,
        contract.total_cost as total_cost_base,
        case 
            when lower(currency) = 'usd' then (contract.total_cost*curr.rate)
            when lower(currency) = 'cad' then (contract.total_cost)
            else (contract.total_cost)
        end as total_cost_cad,
        contract.renewal_decision,
        contract.case_number,
        contract.vendor_id,
        contract.type_last_level,
        contract.company,
        contract.priority_vendor,
        contract.case_status, 
        contract.msa,
        contract.vra,
        contract.tfc,
        contract.po_number,
        contract.duration_months
    from flattened contract

    join usd_curr curr 
    on contract.start_date = curr.key_date
),
latest as (
    select
        *,
        row_number() over (partition by contract_id order by insert_date desc) as rn
    from conversion
    qualify rn = 1
)
select * from latest
