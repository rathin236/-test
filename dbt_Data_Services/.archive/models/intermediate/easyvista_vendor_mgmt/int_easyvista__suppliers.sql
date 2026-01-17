with main as (
    select 
        *
    from {{ ref('stg_easyvista__suppliers') }}
    where status ='Active'
),
flattened as (
    select
        transactionid,
        insert_date,
        record.value:"SUPPLIER_ID"::string as supplier_id,
        record.value:"Supplier"::string as supplier_name,
        record.value:"Vendor Category"::string as supplier_category,
        record.value:"Type"::string as supplier_type,
        record.value:"Account Manager"::string as account_manager,
        record.value:"Main Phone"::string as supplier_contact,
        record.value:"Email"::string as supplier_email,
        record.value:"App Owner"::string as app_owner,
        record.value:"MSA"::string as msa,
        record.value:"VRA"::string as vra,
        record.value:"Available Field 1"::string as af1,
        record.value:"Available Field 2"::string as af2,
        record.value:"Available Field 3"::string as af3,
        record.value:"Available Field 4"::string as af4,
        record.value:"Available Field 5"::string as af5,
        record.value:"Available Field 6"::string as af6,
        record.value:"Discount Rate (%)"::string as discount_rate,
        record.value:"COMMENT_SUPPLIER"::string as comment_supplier
    from main,
    lateral flatten(input => main.json_data:records) as record
),
latest as (
    select
        *,
        row_number() over (partition by supplier_id order by insert_date desc) as rn
    from flattened
    qualify rn = 1
)
select * from latest
