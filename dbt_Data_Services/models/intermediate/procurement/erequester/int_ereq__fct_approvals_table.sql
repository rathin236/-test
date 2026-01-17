with req as (
    select * from {{ ref('int_ereq__dim_requisition') }}
),

routingnode as (
    select * from {{ ref('stg_erequester__routingnode') }}
),

routingnodedet as (
    select * from {{ ref('stg_erequester__routingnodedetail') }}
),

users as (
    select * from {{ ref('int_ereq__dim_user') }}
),

approvals as (
    select
        company_id,
        requisition_id,
        user_id,
        requisition_po_id,
        requisition_type_id,
        request_type_id,
        status_id,
        dept_id,
        requester,
        contact_title,
        routingseqid,
        requisition_notes,
        requisition_datetime,
        requisition_date,
        submitted_datetime,
        submitted_date,
        datetime_approved_last,
        date_approved_last,
        requisition_deleted,
        datetime_posted_po,
        date_posted_po,
        routingnodedet.userid as current_approver_id,
        requested_by as approver_name
    from req

    inner join routingnode
    on req.routingseqid = routingnode.sequenceid
    and routingnode.statusid = 1

    inner join routingnodedet
    on routingnode.nodeid = routingnodedet.nodeid

    inner join users
    on routingnodedet.userid = users.userid
)

select * from approvals
