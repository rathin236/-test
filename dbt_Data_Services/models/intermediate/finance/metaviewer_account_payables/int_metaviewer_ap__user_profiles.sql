with userprofile as (
    select
        userprofileid,
        providerid,
        loginname,
        providerlogin1,
        datarev,
        isenabled,
        providerlogin2,
        managecredentials,
        scopeid,
        _fivetran_deleted,
        _fivetran_synced,

        case
            when userprofileid = 1 then 'Automated Process'
            else
                initcap(
                    regexp_replace(
                        regexp_replace(loginname, '.*\\\\', ''),  -- remove domain prefix
                        '\\.', ' '                                -- replace dots with spaces
                    )
                )
        end as "name",

        md5(
            concat_ws(
                '||',
                coalesce(cast(userprofileid as text), '')
            )
        ) as sk_user_profile
    from {{ ref('stg_metaviewer__user_profile') }}
)

select * from userprofile
