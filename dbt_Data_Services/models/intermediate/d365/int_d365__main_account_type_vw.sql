with main_account_type_vw as (

    select
        enumvaluename as enum_name,
        enumvaluelabel as enum_label,
        enumvalue as enum_value
    from {{ ref('stg_d365__fds_enum_table') }}
    where enumid = 2662

)

select * from main_account_type_vw
