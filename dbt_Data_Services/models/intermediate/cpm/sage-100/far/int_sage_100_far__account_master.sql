with accounts as (

    select * from {{ ref('stg_sage_100_far__gl_account') }}

),

segmentdetails as (

    select * from {{ ref('int_sage_100_far__pivoted_account_segments') }}

),

joined as (

    select

        acc.companycode,
        acc.accountkey,
        acc.account,
        acc.mainaccountcode,
        acc.accountdesc,
        sdet.segment_02,
        sdet.segment_02_desc,
        sdet.segment_03,
        sdet.segment_03_desc

    from accounts as acc
    left join segmentdetails as sdet
        on acc.accountkey = sdet.accountkey

)

select * from joined
