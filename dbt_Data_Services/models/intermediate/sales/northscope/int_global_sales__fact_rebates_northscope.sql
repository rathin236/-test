with rebates as (
    select distinct
        soh.orderid,
        soi.orderheadersk,
        soi.orderitemsk,
        iav.item_id,
        imi.brokerageexpactsk,
        soh.currencysk,
        mfc.currencyid
    from {{ ref('stg_northscope__erpx_so_order_item') }} as soi

    inner join {{ ref('stg_northscope__erpx_so_order_header') }} as soh
        on soi.orderheadersk = soh.orderheadersk

    inner join {{ ref('int_northscope__item_attribute_values_pre_pivot') }} as iav
        on soi.itemsk = iav.item_sk
            and iav.source_system = 'TNS'

    inner join {{ ref('stg_northscope__erpx_im_item') }} as imi
        on iav.item_sk = imi.itemsk

    left join {{ ref('stg_northscope__erpx_mf_currency') }} as mfc
        on soh.currencysk = mfc.currencysk

),

journal_header as (
    select * from {{ ref('stg_northscope__erpx_gl_journal_header') }}
),

journal_line_detail as (
    select * from {{ ref('stg_northscope__erpx_gl_journal_line_detail') }}
),

gl_lines as (
    select
        jlh.sourcetransactionid,
        jld.sourcetransactionlinesk,
        jld.glaccountsk,
        sum(jld.debitamount) as total_debit,
        sum(jld.creditamount) as total_credit
    from journal_header as jlh
    inner join journal_line_detail as jld
        on jlh.journalheadersk = jld.journalheadersk
        and jlh.sourcetransactionid = jld.sourcetransactionid
    group by all
),

final as (
    select
        rbt.orderitemsk,
        rbt.orderid,
        rbt.item_id,
        'CAD' as rebate_currency,
        (coalesce(gll.total_debit, 0) - coalesce(gll.total_credit, 0)) as rebate_amount
    from rebates as rbt
    inner join gl_lines as gll
        on rbt.orderid = gll.sourcetransactionid
        and rbt.brokerageexpactsk = gll.glaccountsk
        and rbt.orderitemsk = gll.sourcetransactionlinesk
)

select * from final
/* for testing */
-- where orderid = 'R-TNS316154A'
