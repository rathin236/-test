select
        companyid as company_id,
        requisitionid as requisition_id,
        popostedby as user_id,
        poid as requisition_po_id,
        requisitiontypeid as requisition_type_id,
        requesttypeid as request_type_id,
        statusid as status_id,
        deptid as dept_id,
        contactname as requester,
        title as contact_title,
        routingseqid,
        daterequested as requisition_datetime,
        cast(daterequested as date) as requisition_date,
        datesubmitted as submitted_datetime,
        cast(datesubmitted as date) as submitted_date,
        dateapproved as datetime_approved_last,
        cast(dateapproved as date) as date_approved_last,
        deleted as requisition_deleted,
        popostdate as datetime_posted_po,
        cast(popostdate as date) as date_posted_po,
        upper(trim(notes)) as requisition_notes
    from {{ ref('stg_erequester__requisition') }}
where daterequested > '2020-12-31'
