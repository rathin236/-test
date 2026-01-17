with dept as (

    select *
    from {{ ref('stg_erequester__dept') }}
)

select * from dept
