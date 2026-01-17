with

source as (

    select * from {{ source('concur', 'itemization') }}

),

renamed as (

    select
        expense_entry_id,
        id as itemization_id,
        posted_amount,
        location_id,
        spend_category_name,
        description,
        report_owner_id,
        transaction_date,
        expense_type_name,
        transaction_amount,
        spend_category_code,
        approved_amount,
        _fivetran_synced,
        custom_12_value as glaccount,
        custom_6_value as companysubledger,
        org_unit_6_value as country,
        custom_16_value as posted_date,
        coalesce(custom_5_value, org_unit_5_value) as companyname,
        coalesce(custom_5_code, org_unit_5_code) as company_code,
        coalesce(custom_3_value, org_unit_3_value) as department,
        coalesce(custom_3_code, org_unit_3_code) as department_code,
        coalesce(custom_2_value, org_unit_4_value) as costcenter,
        coalesce(custom_2_code, org_unit_4_code) as costcenter_code

    from source

)

select * from renamed
