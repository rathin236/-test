with delivery_terms as (
    select
        'D365' as source,
        recid,
        dataareaid,
        code,
        txt,
        partition,
        tableid
    from {{ ref('stg_d365__delivery_terms') }}
)

select * from delivery_terms
