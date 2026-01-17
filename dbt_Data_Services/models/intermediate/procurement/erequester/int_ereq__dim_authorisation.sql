with authorisation as (
    select * from {{ ref('stg_erequester__requisition_authorisation') }}
),

users as (
    select * from {{ ref('stg_erequester__user') }}
),

req_auth as (
    select
        auth.requisitionid as requisition_id,
        usr.jobtitle,
        upper(concat(trim(usr.firstname), ' ', trim(usr.lastname))) as authorised_by
    from authorisation as auth
    left join users as usr
    on auth.userid = usr.userid
)

select * from req_auth
