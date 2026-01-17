with

source as (

    select * from {{ source('mas_roy_dbo', 'gl_accountsegment') }}

),

renamed as (

    select
        accountkey,
        segmentno,
        subaccountcode,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select *
from renamed
where coalesce(_fivetran_deleted, false) = false
