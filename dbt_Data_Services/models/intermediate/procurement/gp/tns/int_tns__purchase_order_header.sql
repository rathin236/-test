with active_po_header as (
    select
        creatddt,
        cast(prmdate as date) as prm_date,
        cast(docdate as date) as doc_date,
        cmpanyid,
        cmpnynam,
        subtotal,
        orsubtot,
        oremsubt,
        taxamnt,
        ortaxamt,
        remsubto,
        curncyid,
        currnidx,
        xchgrate,
        exchdate,
        pymtrmid,
        country,
        purchcountry,
        purchstate,
        state,
        purchcity,
        city,
        taxschid,
        commntid,
        denxrate,
        lstedtdt,
        duedate,
        reqtndt,
        reqdate,
        modifdt,
        lstprtdt,
        prmshpdte,
        'active' as source,
        trim(ponumber) as ponumber,
        trim(vendorid) as vendor_id,
        case postatus
            when 1 then 'New'
            when 2 then 'Released'
            when 3 then 'Change Order'
            when 4 then 'Recieved'
            when 5 then 'Closed'
            when 6 then 'Cancelled'
        end as order_status,
        extract(year from prmdate) as prm_year,
        extract(month from prmdate) as prm_month
    --  CBVAT

    from {{ ref('stg_gp_tns__pop10100') }}
),

historic_po_header as (
    select
        creatddt,
        cast(prmdate as date) as prm_date,
        -- trim(PRMDATE),
        cast(docdate as date) as doc_date,
        -- change_order_flag,
        -- PO_STATUS_ORIG,
        cmpanyid,
        cmpnynam,
        subtotal,
        orsubtot,
        oremsubt,
        taxamnt,
        ortaxamt,
        remsubto,
        curncyid,
        currnidx,
        xchgrate,
        exchdate,
        pymtrmid,
        country,
        purchcountry,
        purchstate,
        state,
        purchcity,
        city,
        taxschid,
        commntid,
        denxrate,
        lstedtdt,
        duedate,
        reqtndt,
        reqdate,
        modifdt,
        lstprtdt,
        prmshpdte,
        'history' as source,
        trim(ponumber) as ponumber,
        trim(vendorid) as vendor_id,
        case postatus
            when 1 then 'New'
            when 2 then 'Released'
            when 3 then 'Change Order'
            when 4 then 'Recieved'
            when 5 then 'Closed'
            when 6 then 'Cancelled'
        end as order_status,
        extract(year from prmdate) as prm_year,
        extract(month from prmdate) as prm_month
        -- CBVAT

    from {{ ref('stg_gp_tns__pop30100') }}
),

all_header as (
    select * from active_po_header
    union distinct
    select * from historic_po_header
),

ponumber_count as (
    select
        *,
        'TNS' as company,
        ponumber || company || vendor_id as po_key,
        case when count(*) over (partition by ponumber) > 1 and source = 'active' then 1 else 0 end as dedupe
    from all_header
)

select * from ponumber_count
where dedupe = 0
