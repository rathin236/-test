with

source as (

    select * from {{ source('mas_lar_dbo', 'gl_periodpostinghistory') }}

),

renamed as (

    select
        accountkey,
        fiscalperiod,
        fiscalyear,
        debitamount,
        creditamount,
        beginningbalance,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select *
from renamed
where coalesce(_fivetran_deleted, false) = false
