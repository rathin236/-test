with
    main_account as (
        select
            recid,
            mainaccountid as main_account_id,
            name as account_name,
            dataareaid,
            createdon,
            modifiedon,
            modifiedby,
            accountcategoryref,
            type,
            closing,
            closetype,
            case
                when ledgerchartofaccounts = '5637144576' then 'TNSF' else 'Other'
            end as chart_of_accounts,
            md5(
                concat(
                    trim(upper(mainaccountid)),
                    trim(upper(chart_of_accounts), trim(upper(dataareaid)))
                )
            ) as sk_main_account
        from {{ ref("stg_d365__main_account") }}
    ),

    account_categories as (select * from {{ ref("stg_d365__main_account_category") }}),

    ma_type as (
        select
            enumvaluename as enum_name,
            enumvaluelabel as main_account_type,
            enumvalue as enum_value
        from {{ ref("stg_d365__fds_enum_table") }}
        where enumid = 2662
    ),

    final as (
        select
            ma.recid,
            ma.main_account_id,
            ma.chart_of_accounts,
            ma.account_name,
            ma.dataareaid,
            ma.createdon as created_on,
            ma.modifiedon as modified_on,
            ma.modifiedby as modified_by,
            mac.accountcategory as account_category,
            mat.main_account_type,
            ma.closing,
            ma.closetype as closing_type,
            ma.sk_main_account
        from main_account as ma
        left join
            account_categories as mac on ma.accountcategoryref = mac.accountcategoryref

        left join ma_type as mat on ma.type = mat.enum_value
    )

select * from final
