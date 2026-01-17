with

source as (

    select * from {{ source('snowflake_account_usage', 'users') }}

),

renamed as (

    select
        user_id,
        name,
        created_on,
        deleted_on,
        login_name,
        display_name,
        first_name,
        last_name,
        email,
        must_change_password,
        has_password,
        comment,
        disabled,
        snowflake_lock,
        default_warehouse,
        default_namespace,
        default_role,
        ext_authn_duo,
        ext_authn_uid,
        bypass_mfa_until,
        last_success_login,
        expires_at,
        locked_until_time,
        has_rsa_public_key,
        password_last_set_time,
        owner,
        default_secondary_role

    from source

)

select * from renamed
