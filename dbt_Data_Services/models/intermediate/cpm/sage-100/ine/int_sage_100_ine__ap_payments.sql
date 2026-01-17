with paymentheaders as (

    select * from {{ ref('stg_sage_100_ine__ap_checkhistoryheader') }}

),

bank as (

    select * from {{ ref('stg_sage_100_ine__gl_bank') }}

),

joined as (

    select

        phd.sourcejournal,
        phd.sourcejournalbatchno,
        phd.checkamt,
        phd.bankcode,
        phd.checkno,
        bnk.cashaccountkey,
        phd.vendorno,
        phd.vendorname,
        concat(phd.bankcode, phd.checkno) as documentno

    from paymentheaders as phd
    left join bank as bnk
        on phd.bankcode = bnk.bankcode

)

select * from joined
