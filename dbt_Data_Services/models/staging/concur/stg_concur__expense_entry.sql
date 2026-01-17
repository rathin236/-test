with

source as (

    select * from {{ source('concur', 'expense_entry') }}

),

renamed as (

    select
        report_id,
        id as entry_id,
        is_personal_card_charge,
        posted_amount,
        payment_type_name,
        payment_type_id,
        exchange_rate,
        location_country,
        location_name,
        is_personal,
        transaction_date,
        vendor_description,
        expense_type_name,
        transaction_amount,
        approved_amount,
        is_itemized,
        user_id,
        business_purpose,
        transaction_currency_code,
        spend_category,
        expense_type_id,
        custom_12_value as glaccount,
        custom_16_value as posted_date,
        coalesce(custom_5_value, org_unit_5_value) as companyname,
        coalesce(custom_3_value, org_unit_3_value) as department,
        coalesce(custom_2_value, org_unit_4_value) as costcenter,
        coalesce(custom_5_code, org_unit_5_value) as company_code,
        coalesce(custom_3_code, org_unit_3_value) as department_code,
        coalesce(custom_2_code, org_unit_4_code) as costcenter_code
        --- Abe Gibbsons was able to help to give field names for custom columns

    from source
)

select * from renamed
