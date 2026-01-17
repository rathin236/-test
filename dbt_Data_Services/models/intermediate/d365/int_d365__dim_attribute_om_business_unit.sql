with dir_party_table as (
    select * from {{ ref('stg_d365__dir_party_table') }}
),

final as (
    select

        dpt.recid as key_,
        dpt.omoperatingunitnumber as value_,
       -- dpt.partition,
        dpt.recid,
        dpt2.name
       -- dpt2.partition as partition_2

    from dir_party_table as dpt

    cross join dir_party_table as dpt2

    where dpt.omoperatingunittype = 4
        and dpt.recid = dpt2.recid
      --  and dpt.partition = dpt2.partition
)

select * from final
