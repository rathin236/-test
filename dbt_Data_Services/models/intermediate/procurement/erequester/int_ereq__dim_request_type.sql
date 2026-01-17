with request_type as (
    select *
    from {{ ref('stg_erequester__request_type') }}
)

select * from request_type
