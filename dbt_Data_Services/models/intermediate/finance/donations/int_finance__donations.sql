{{ config(materialized='ephemeral') }}

with

staging as (
    select * from {{ ref('stg_sharepoint__donations') }}
),

-- Parse JSON fields and expand region abbreviations
donations as (
    select
        id,
        phone_number,
        email_address,
        mail_address,
        org_name,
        event_date,
        who_benefits,
        request_amount,
        donation_recognition,
        recommending_employee_name,
        request_status,
        requester_name,
        approval_1,
        approval_2,
        approver_2_comments,
        approver_1_comments,
        employee_recommended,
        donated_amount,
        cheque_number,
        modified,
        created,
        attachments,
        notes,
        processing_notes,

        -- Parse JSON fields to extract labels (using original column names for backward compatibility)
        coalesce(try_parse_json(requesting_for):label::string, requesting_for::string) as requesting_for_label,
        coalesce(try_parse_json(previous_support):label::string, previous_support::string) as previous_support,
        coalesce(try_parse_json(registered_charity):label::string, registered_charity::string) as registered_charity,
        coalesce(try_parse_json(request_type):label::string, request_type::string) as request_type,
        coalesce(try_parse_json(recommended_by_employee):label::string, recommended_by_employee::string) as recommended_by_employee,
        coalesce(try_parse_json(supporting_file):Url::string, null) as supporting_file,

        -- Expand region abbreviations to full names
        case
            when region = 'NS' then 'Nova Scotia'
            when region = 'NB' then 'New Brunswick'
            when region = 'NL' then 'Newfoundland and Labrador'
            when region = 'PE' then 'Prince Edward Island'
            when region = 'ON' then 'Ontario'
            when region = 'MB' then 'Manitoba'
            when region = 'WA' then 'Washington'
            when region = 'ME' then 'Maine'
            when region = 'USA' then 'United States'
            when region = 'CAN' then 'Canada'
            else coalesce(region, 'Unknown')
        end as region,

        -- event date in next 30 days flag
        case
            when event_date >= current_date and event_date <= current_date + 30 then 1
            else 0
        end as flag_event_date_in_next_30_days

    from staging
)

select * from donations
