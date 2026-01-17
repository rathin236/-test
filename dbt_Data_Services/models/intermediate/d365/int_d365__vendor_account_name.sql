with vendor_account_name as (

    select
        vt.accountnum as vendor_id,
        vt.lineofbusinessid as line_of_business,
        dpt.name as name_description,
        dpt.namesalias as vendor_name,
        vt.bankaccount as bank_account,
        vt.paymmode as pay_mode,
        vt.taxgroup as tax_group,
        vt.vendgroup as vendor_group,
        vt.w_9
    from {{ ref('stg_d365__vend_table') }} as vt

    left join {{ ref('stg_d365__dir_party_table') }} as dpt
        on vt.party = dpt.recid

)

select * from vendor_account_name
