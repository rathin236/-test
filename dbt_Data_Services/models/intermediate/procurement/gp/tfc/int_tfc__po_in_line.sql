with active_po_in_line as (
    select
        'TFC' as company,
        ord,
        prmdate,
        cast(prmdate as date) as prm_date,
        cast(reqdate as date) as req_date,
        extdcost,
        vnditdsc,
        umqtyinb,
        qtyorder,
        decplqty,
        vendorid as vendor_id,
        itemdesc,
        oruntcst,
        --   currencyid,
        unitcost,
        taxamnt,
        orextcst,
        ortaxamt,
        'active' as source,
        trim(ponumber) as po_number,
        extract(year from prm_date) as prm_year,
        extract(month from prm_date) as prm_month,
        trim(itemnmbr) as product,
        po_number || company || vendor_id as po_key,
        company || vendor_id as vendor_key
    from {{ ref("stg_gp_tfc__pop10110") }}
),

historic_po_in_line as (
    select
        'TFC' as company,
        ord,
        prmdate,
        cast(prmdate as date) as prm_date,
        cast(reqdate as date) as req_date,
        extdcost,
        vnditdsc,
        umqtyinb,
        qtyorder,
        decplqty,
        vendorid as vendor_id,
        itemdesc,
        oruntcst,
        --   currencyid,
        unitcost,
        taxamnt,
        orextcst,
        ortaxamt,
        'closed' as source,
        trim(ponumber) as po_number,
        extract(year from prm_date) as prm_year,
        extract(month from prm_date) as prm_month,
        trim(itemnmbr) as product,
        po_number || company || vendor_id as po_key,
        company || vendor_id as vendor_key
    from {{ ref("stg_gp_tfc__pop30110") }}
),

all_po_in_line as (
    select * from active_po_in_line
    union all
    select * from historic_po_in_line
)

select * from all_po_in_line
