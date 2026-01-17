with user as (
        select
            userid,
            datecreated as user_created_date,
            jobtitle as job_title,
            outofoffice,
            admin,
            upper(concat(trim(firstname), ' ', trim(lastname))) as requested_by --used as 'buyer' in power bi

        from {{ ref('stg_erequester__user') }}
)

select * from user
