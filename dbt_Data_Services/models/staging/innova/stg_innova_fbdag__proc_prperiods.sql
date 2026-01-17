with

source as (

    select * from {{ source('innova_fbdag', 'proc_prperiods') }}

),

renamed as (

    select
        prperiod,
        recipebatchstep,
        prodplan,
        comment,
        prday,
        begtime,
        configtable,
        endtime,
        prunit,
        datastatus,
        activity,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
