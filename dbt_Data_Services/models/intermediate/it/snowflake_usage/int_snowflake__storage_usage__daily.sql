with storage_usage_add_key as (

    select

        {{ dbt_utils.generate_surrogate_key(['usage_date', 'account_locator']) }} as usage_key,
        usage_date,
        account_locator,
        average_bytes,
        credits

    from {{ ref('stg_snowflake_organization_usage__storage_daily_history') }}

)

/*,

storage_to_terabytes as (

    select

        usage_date,
        account_locator,
        average_bytes, --/ power(1024, 4)) as average_terabytes,
        credits

    from storage_usage

    where credits > 0

),

*/

select * from storage_usage_add_key
