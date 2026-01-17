with source as (

    select * from {{ source('fishtalk', 'feedbatch') }}

),

renamed as (

    select
        medicamentmixratio,
        duplicate,
        feedtypeid,
        feedstoreid,
        batchnumber,
        prescription,
        starttime,
        endtime,
        _fivetran_deleted,
        _fivetran_synced,
        trim(feedbatchid) as feedbatchid

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
