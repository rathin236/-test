with

source as (

    select * from {{ source('sharepoint', 'donation_request_management_active_requests') }}

),

renamed as (

    select
        id,
        _fivetran_synced,
        _odata_etag,
        phone_number,
        email_address,
        mail_address,
        requesting_for,
        previous_support,
        org_name,
        registered_charity,
        event_date,
        who_benefits,
        request_type,
        request_amount,
        donation_recognition,
        recommended_by_employee,
        recommending_employee_name,
        request_status,
        requester_name,
        supporting_file,
        approval_1,
        approval_2,
        approver_2_comments,
        approver_1_comments,
        employee_recommended,
        donated_amount,
        cheque_number,
        region,
        content_type,
        modified,
        created,
        author_lookup_id,
        editor_lookup_id,
        _uiversion_string,
        attachments,
        item_child_count,
        folder_child_count,
        notes,
        processing_notes,
        requested_product,
        app_editor_lookup_id,
        app_author_lookup_id,
        title,
        link_title_no_menu,
        link_title,
        _fivetran_deleted

    from source
    where coalesce(_fivetran_deleted, false) = false
)

select * from renamed
