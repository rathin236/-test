with dir_party_table as (
    select * from {{ ref('stg_d365__dir_party_table') }}
),

final as (
    select
        t1.recid as key_,
        t1.omoperatingunitnumber as value,
        --t1.partition,
        t1.recid,
        t2.name
        --t2.partition as partition2
    from
        dir_party_table as t1
    cross join
        dir_party_table as t2
    where
        t1.omoperatingunittype = 1
        and t1.recid = t2.recid
        --and t1.partition = t2.partition
)

select * from final
