with segments as (

    select * from {{ ref('stg_sage_100_ine__gl_accountsegment') }}

),

segmentdescriptions as (

    select * from {{ ref('stg_sage_100_ine__gl_subaccount') }}

),

joined as (

    select

        seg.accountkey,
        seg.segmentno,
        seg.subaccountcode,
        coalesce(sdc.udf_descrip_seg, sdc.subaccountdesc) as subaccountdesc

    from segments as seg
    left join segmentdescriptions as sdc
        on seg.segmentno = sdc.segmentno and seg.subaccountcode = sdc.subaccountcode

)

select * from joined
