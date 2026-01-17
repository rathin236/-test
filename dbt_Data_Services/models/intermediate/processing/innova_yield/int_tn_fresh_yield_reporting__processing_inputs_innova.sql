with proc_matxacts as (
    select * from {{ ref('stg_innova_fbdag__proc_matxacts') }}
),

proc_plots as (
    select * from {{ ref('stg_innova_fbdag__proc_plots') }}
),

proc_lots as (
    select * from {{ ref('stg_innova_fbdag__proc_lots') }}
),

erpx_mf_site as (
    select * from {{ ref('stg_northscope__erpx_mf_site') }}
),

int_tn_fresh_yield_reporting__processing_inputs_innova as (

    select

        'TNS' as "Company",
        'FBD' as "Facility",
        null as "PalletNumber",
        null as "CaseNumber",
        mtx.material::string as "ItemNumber",
        'Fillet' as "PalletUoM",
        mtx.weight as "PalletVolume",
        'Fillet' as "CaseUoM",
        mtx.weight as "CaseVolume",
        mtx.pieces as "Pieces",
        1.00 as "FWtoLBConversion",
        mtx.weight as "Lbs",
        mtx.pieces as "Units",
        'Input' as "TransactionType",
        'Graded Fillet' as "ItemProfile",
        'ValidInputItem' as "ItemSetCheck",
        mtx.regtime as "dbDT",
        mtx.regtime as "DateTime_Transaction",
        mtx.regtime::string as "Date_Transaction",
        null as "Key_Contdtl",
        'NS_1' as "Key_Company",
        mtx.regtime::string as "Key_Date",
        'NS_' || site.sitesk as "Key_Site",
        'QCScanner_' || mtx.material::string as "Key_Item",
        'CE_TNS_' || lot.code as "Key_Lot",
        'CE_' || plot.code as "Key_Line"

    from proc_matxacts as mtx

    left join proc_plots as plot
        on mtx.plot = plot.plot

    left join proc_lots as lot
        on mtx.lot = lot.lot

    left join erpx_mf_site as site
        on 'FBD' = site.hostsystemlink
            and site.dataentitycompanysk = 1

    /*******************************************************************************************************************************************
    where condition notes:
        The SSRS assets are limited to just the current and previous month.
        With respect to the plot.code and mtx.xactpath conditions, 9,10,and 11 represent the Skinless, Deep Skinless, Full Deep Skinless processes respectively,
        and the individual graders are identified by 10 and 20. I.E. 1009 would be QC Scanner #1 (10) sending a fillet to Skinless (09)
    *******************************************************************************************************************************************/
    where mtx.xactpath in (9, 10, 11)
        and plot.code in ('1009', '2009', '1010', '2010', '1011', '2011')

)

select * from int_tn_fresh_yield_reporting__processing_inputs_innova
