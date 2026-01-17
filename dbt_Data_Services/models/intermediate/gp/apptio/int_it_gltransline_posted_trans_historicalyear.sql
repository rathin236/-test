--depends_on: {{ ref('int_it_costs__acctcode') }}
--depends_on: {{ ref('stg_d365__exchange_rate_currency_pair') }}
--depends_on: {{ ref('stg_d365__exchange_rate') }}

{{ config(materialized='table') }}


{% set schema_list = dbt_utils.get_column_values(table=ref("int_it_costs__valid_schemas"), column='NAME') %}

{% for schema in schema_list %}

    select
        act.company,
        gltptc.dex_row_id,
        to_char(gltptc.exchdate, 'YYYY-MM-DD') as exchdate,
        gltptc.ormstrnm,
        gltptc.ordocnum,
        gltptc.qkofset,
        gltptc.debitamt,
        gltptc.polldtrx,
        to_char(gltptc.orpstddt, 'YYYY-MM-DD') as orpstddt,
        year(gltptc.trxdate) as pstyear,
        gltptc.seqnumbr,
        gltptc.dta_gl_status,
        gltptc.ratetpid,
        gltptc.orcrdamt,
        gltptc.denxrate,
        gltptc.ormstrid,
        gltptc.aprvluserid,
        gltptc.user_defined_text02,
        gltptc.orgntsrc,
        to_char(gltptc.trxdate, 'YYYY-MM-DD') as trxdate,
        gltptc.voided,
        gltptc.ortrxsrc,
        gltptc.rctrxseq,
        to_char(gltptc.lstdtedt, 'YYYY-MM-DD') as lstdtedt,
        gltptc.dta_index,
        gltptc.xchgrate,
        gltptc.mctrxstt,
        gltptc.periodid,
        gltptc.user_defined_text01,
        gltptc.back_out_je,
        gltptc.orcomid,
        gltptc.refrence,
        gltptc.jrnentry,
        gltptc.origdtaseries,
        gltptc.noteindx,
        gltptc.orctrnum,
        gltptc.currnidx,
        to_char(gltptc.dex_row_ts, 'YYYY-MM-DD') as dex_row_ts,
        gltptc.correcting_je,
        gltptc.orgnatyp,
        to_char(gltptc.docdate, 'YYYY-MM-DD') as docdate,
        gltptc.ppsgnmbr,
        gltptc.ortrxtyp,
        gltptc.back_out_je_year,
        gltptc.ledger_id,
        gltptc.origseqnum,
        gltptc.dscriptn,
        gltptc.ictrx,
        gltptc.adjustment_transaction,
        try_cast('' as number) as openyear,
        gltptc.ordbtamt,
        gltptc.original_je_seq_num,
        gltptc.lastuser,
        gltptc.originje,
        gltptc.series,
        to_char(time1, 'YYYY-MM-DD') as time1,
        gltptc.correcting_je_year,
        to_char(apprvldt, 'YYYY-MM-DD') as apprvldt,
        gltptc.sourcdoc,
        gltptc.trxsorce,
        gltptc.original_je_year,
        gltptc.correspondingunit,
        gltptc.crdtamnt,
        gltptc.rtclcmtd,
        gltptc.original_je,
        gltptc.pstgnmbr,
        gltptc.actindx,
        gltptc.exgtblid,
        gltptc.curncyid as orcurncyid,
        gltptc.uswhpstd,
        gltptc._fivetran_deleted,
        gltptc._fivetran_synced,
        act.actnumst,
        act.actnumst_desc,
        act.NATURAL,
        act.natural_desc,
        act.costcenter,
        act.costcenter_desc,
        act.department,
        act.department_desc,
        cmcd.funlcurr,

        coalesce(round((exr.exchangerate / 100), 6), '1.000000') as exchangerate,

        case
            when cmcd.funlcurr = 'CAD' then debitamt
            when exr.exchangerate is not null and cmcd.funlcurr != 'CAD' then
                round(gltptc.ordbtamt / (exr.exchangerate / 100), 2)
            else
                gltptc.ordbtamt
        end as ordbtamt_cad,

        case
            when cmcd.funlcurr = 'CAD' then crdtamnt
            when exr.exchangerate is not null and cmcd.funlcurr != 'CAD' then
                round(gltptc.orcrdamt / (exr.exchangerate / 100), 2)
            else
                gltptc.orcrdamt
        end as orcrdamt_cad

    from gp.{{ schema }}.gl30000 as gltptc

    left join gp.{{ schema }}.mc40000 as cmcd

    left join {{ ref('int_it_costs__acctcode') }} as act on trim(act.actindx) = trim(gltptc.actindx) and act.company = '{{ schema }}'

    left join {{ ref('stg_d365__exchange_rate_currency_pair') }} as curp
            on curp.tocurrencycode = case
                                        when trim(gltptc.curncyid) like 'Z-EUR%'
                                            then 'EUR'
                                        else
                                            trim(gltptc.curncyid)
                                    end
            and curp.fromcurrencycode = 'CAD'

    left join {{ ref('stg_d365__exchange_rate') }} as exr
            on curp.recid = exr.exchangeratecurrencypair
            and date(gltptc.trxdate) between date(exr.validfrom) and date(exr.validto)

    where
        year(gltptc.trxdate) >= '2023'
        and trim(upper(refrence)) != upper('Balance Brought Forward')
        and trim(upper(refrence)) != upper('Trf intagible assets to CI')
        and trim(upper(refrence)) != upper('Intangible assets trf fr CAI')
        and gltptc._fivetran_deleted = 'FALSE'

    {% if not loop.last %}
        union all
    {% endif %}

{% endfor %}
