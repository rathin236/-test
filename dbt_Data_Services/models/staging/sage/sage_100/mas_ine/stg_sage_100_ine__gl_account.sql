with

source as (

    select * from {{ source('mas_ine_dbo', 'gl_account') }}

),

renamed as (

    select
        accountkey,
        rollupcode1,
        accounttype,
        accountcategory,
        accountgroup,
        mainaccountcode,
        rollupcode4,
        rawaccount,
        dateend,
        dateupdated,
        timecreated,
        account,
        userupdatedkey,
        rollupcode3,
        clearbalance,
        cashflowstype,
        companycode,
        status,
        rollupcode2,
        accountdesc,
        udf_sort,
        timeupdated,
        datecreated,
        datestart,
        usercreatedkey,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select *
from renamed
where coalesce(_fivetran_deleted, false) = false
