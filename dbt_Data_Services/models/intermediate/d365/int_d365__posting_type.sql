with transaction_type as (

    select distinct
        enumvaluename as enum_name,
        enumvaluelabel as enum_label,
        enumvalue as enum_value
    from {{ ref('stg_d365__fds_enum_table') }}
    where enumid = 5576

)

select * from transaction_type
