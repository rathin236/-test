with

source as (

    select * from {{ source('mas_far_dbo', 'gl_subaccount') }}

),

renamed as (

    select
        segmentno,
        subaccountcode,
        userupdatedkey,
        timeupdated,
        usercreatedkey,
        datecreated,
        subaccountshortdesc,
        timecreated,
        printfinancialstmts,
        datestart,
        status,
        dateend,
        dateupdated,
        subaccountdesc,
        udf_descrip_seg,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select *
from renamed
where coalesce(_fivetran_deleted, false) = false
