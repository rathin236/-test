with main_account_table as (

    select
        ma.mainaccountid as main_account_id,
        ma.name as main_account_name,
        mat.enum_label as main_account_type,
        mac.accountcategory as account_category,
        ma.recid,
        case
            when ledgerchartofaccounts = 5637144576
                then 'TNSF'
            else 'Other'
        end as chart_of_accounts
    from {{ ref('stg_d365__main_account') }} as ma

    left join {{ ref('stg_d365__main_account_category') }} as mac
        on ma.accountcategoryref = mac.accountcategoryref

    left join {{ ref('int_d365__main_account_type_vw') }} as mat
        on ma.type = mat.enum_value

)

select * from main_account_table
