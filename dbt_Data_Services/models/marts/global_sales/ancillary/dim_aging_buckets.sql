with aging_buckets as (
    select * from {{ ref('aging_buckets') }}
)

select

    age_buckets as "Age Buckets",
    bucket_order as "Key_AgingBucket"

from aging_buckets
