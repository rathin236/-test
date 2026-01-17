with accountdocument_lines as (

    select * from {{ ref('stg_sap_sladegorton__bseg') }}
    where umskz != 'F'

),

accountdocument_header as (

    select * from {{ ref('stg_sap_sladegorton__bkpf') }}

),

companymaster as (

    select * from {{ ref('stg_sap_sladegorton__t001') }}

),

glaccount_master as (

    select * from {{ ref('stg_sap_sladegorton__skat') }}

),

costcentre_master as (

    select * from {{ ref('stg_sap_sladegorton__cskt') }}

),

sl_originatingmaster as (

    select * from {{ ref('int_cpm_sladegorton__originating_master') }}

),

item_master as (

    select * from {{ ref('stg_sap_sladegorton__mara') }}

),

joined as (

    select

        cma.butxt as company,
        adh.budat_simp_dt as transactiondate,
        adh.monat as periodnumber,
        adh.belnr as documentnumber,
        adl.hkont as mainaccountnumber,
        adl.kostl as costcenter,
        glm.txt50 as mainaccountdescription,
        ccm.ltext as costcenterdescription,
        adl.sgtxt as transactiondescription,
        slom.omid as originatingmasterid,
        slom.name1 as originatingmastername,
        adh.xblnr as originatingdocumentnumber,
        adh.waers as currency,
        adh.kursf as exchangerate,
        adl.menge as volumelbssold,
        ima.mtpos_mara as lineofbusiness,
        case
            when adl.shkzg = 'S' then to_decimal(adl.dmbtr, 10, 2)
            when adl.shkzg = 'H' then to_decimal(adl.dmbtr * -1, 10, 2)
            else to_decimal(adl.dmbtr, 10, 2)
        end as amountaccountingcurrency,
        case
            when adl.shkzg = 'S' then to_decimal(adl.wrbtr, 10, 2)
            when adl.shkzg = 'H' then to_decimal(adl.wrbtr * -1, 10, 2)
            else to_decimal(adl.wrbtr, 10, 2)
        end as amounttransactioncurrency

    from accountdocument_lines as adl
    left join accountdocument_header as adh
        on adl.mandt = adh.mandt and adl.bukrs = adh.bukrs and adl.belnr = adh.belnr and adl.gjahr = adh.gjahr
    left join companymaster as cma
        on adl.bukrs = cma.bukrs
    left join glaccount_master as glm
        on adl.hkont = glm.saknr and cma.ktopl = glm.ktopl and adl.mandt = glm.mandt
    left join costcentre_master as ccm
        on adl.mandt = ccm.mandt and adl.kostl = ccm.kostl
    left join sl_originatingmaster as slom
        on adl.mandt = slom.mandt and adl.bukrs = slom.bukrs and adl.belnr = slom.belnr and adl.gjahr = slom.gjahr
            and (adl.koart = slom.koart and adl.shkzg = slom.shkzg and adl.kunnr = slom.omid or (adl.koart = '' and slom.row_num = 1))
    left join item_master as ima
        on adl.matnr = ima.matnr

    where adh.budat_simp_dt >= '2022-12-01'

),

unioned as (

    select
        company,
        transactiondate,
        periodnumber,
        documentnumber,
        mainaccountnumber,
        costcenter,
        mainaccountdescription,
        costcenterdescription,
        transactiondescription,
        originatingmasterid,
        originatingmastername,
        originatingdocumentnumber,
        currency,
        exchangerate,
        volumelbssold,
        lineofbusiness,
        amountaccountingcurrency,
        amounttransactioncurrency
    from {{ ref('int_cpm_sladegorton__bb_transactions') }}

    union all

    select
        company,
        transactiondate,
        periodnumber,
        documentnumber,
        mainaccountnumber,
        costcenter,
        mainaccountdescription,
        costcenterdescription,
        transactiondescription,
        originatingmasterid,
        originatingmastername,
        originatingdocumentnumber,
        currency,
        exchangerate,
        volumelbssold,
        lineofbusiness,
        amountaccountingcurrency,
        amounttransactioncurrency
    from joined

)

select * from unioned
order by transactiondate, periodnumber
