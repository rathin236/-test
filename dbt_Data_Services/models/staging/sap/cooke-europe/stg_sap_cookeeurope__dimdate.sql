with source as (

    select * from {{ source('fast_bi_dwh_dbo', 'dimdate') }}

),

renamed as (

    select

        dimdateid,
        iscurrentmonth,
        weekname,
        yearid,
        monthofyearname,
        yearname,
        iscurrentweek,
        daynameshort,
        weekisocontinuednameshort,
        weekisoofyearname,
        quartername,
        datetime,
        quarterofyearname,
        dayofweekname,
        weekisoofyearid,
        dayofweekid,
        weekisocontinuednamelong,
        quarterid,
        datecalculation,
        periodofyearid,
        periodofyearname,
        modifiedetlrunid,
        weekisocontinuedid,
        quarterofyearid,
        iscurrentweeknumeric,
        periodid,
        monthofyearid,
        daynamelong,
        monthid,
        periodname,
        weekid,
        monthname,
        createdetlrunid,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
