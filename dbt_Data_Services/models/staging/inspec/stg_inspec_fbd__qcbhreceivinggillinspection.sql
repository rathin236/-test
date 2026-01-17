with source as (

    select * from {{ source('inspec_fbd', 'qcbhreceivinggillinspection') }}

),

filtered as (

    select * from source
    where coalesce(_fivetran_deleted, false) = false

),

renamed as (

    select
        _id,
        context_enterprise,
        gillinspection_n_3,
        status_createdby,
        comments,
        gillinspection_n_2,
        lot,
        context,
        statusoverridereason,
        status_workflow,
        total_score,
        formpassfail,
        status_lastmodifiedby,
        gillinspection_n_1,
        photo,
        walltime,
        officialtime,
        approval_status,
        formid,
        status_lastmodified,
        approval_datetime,
        gillinspection_n_0,
        context_plant,
        gillinspection_n_4,
        approval_user,
        _fivetran_deleted,
        _fivetran_synced,
        n_2,
        gillinspectionpassfail,
        n_1,
        n_4,
        n_3,
        gillinspection_percentagefailed,
        gillinspection_percentagepassed,
        n_0,
        percentagepassed,
        percentagefailed,
        vessel,
        numberorfishinspected,
        photofailed,
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
