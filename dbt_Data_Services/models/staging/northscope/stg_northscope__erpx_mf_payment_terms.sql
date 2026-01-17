with source as (

    select * from {{ source('northscope', 'erpx_mfpaymentterms') }}

),

renamed as (

    select
        discountamount,
        discountdatedays,
        discountcalcmethoden,
        paymenttermname,
        hostsystemlink,
        duetypeen,
        discountpercent,
        duedatedays,
        paymenttermsk,
        dataentitycompanysk,
        discounttypeen,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
