with source as (
    select *
    from {{ source('inspec_fbd', 'qcbhpersonalhygienegmps') }}
),

filtered as (
    select *
    from source
    where coalesce(_fivetran_deleted, false) = false
),

renamed as (
    select
        _id,
        shiftmonitored,
        employeename,
        status_workflow,
        comments,
        supervisorleadhandnotified,
        total_score,
        approval_datetime,
        status_lastmodifiedby,
        photo,
        approval_user,
        deficiencycorrected,
        formid,
        formpassfail,
        walltime,
        statusoverridereason,
        status_lastmodified,
        nodeficienciesnoted,
        reasonforother,
        deficiencies,
        context,
        officialtime,
        approval_status,
        context_enterprise,
        nodeficienciesnoted_0,
        status_createdby,
        context_plant,
        _fivetran_deleted,
        _fivetran_synced,
        date,
        time_datestring,
        date_datestring,
        time_timestring,
        date_timestring,
        time,
        time_timedatestring,
        date_timedatestring

    from filtered
)

select * from renamed
