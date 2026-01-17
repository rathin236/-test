with accounts as (

    select

        account_locator,
        account_name,
        deleted_on,
        case
            when is_managed = 'FALSE' then 'main account' else 'reader account'
        end as account_type

    from {{ ref('stg_snowflake_organization_usage__accounts') }}

)

select * from accounts
