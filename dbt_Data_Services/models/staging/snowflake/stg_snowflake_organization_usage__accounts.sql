with

source as (

    select * from {{ source('snowflake_organization_usage', 'accounts') }}

),

renamed as (

    select
        organization_name,
        account_name,
        created_on,
        region,
        region_group,
        edition,
        is_org_admin,
        is_locked,
        account_url,
        account_old_url,
        account_old_url_last_used,
        organization_old_url,
        organization_old_url_last_used,
        account_locator,
        managed_accounts,
        is_managed,
        parent_account,
        consumption_billing_entity_name,
        marketplace_consumer_billing_entity_name,
        marketplace_provider_billing_entity_name,
        altered_on,
        scheduled_deletion_time,
        deleted_on,
        moved_on,
        comment

    from source

)

select * from renamed
