with proc_matxacts as (
    select * from {{ ref('stg_innova_fbdag__proc_matxacts') }}
),

proc_plots as (
    select * from {{ ref('stg_innova_fbdag__proc_plots') }}
),

proc_materials as (
    select * from {{ ref('stg_innova_fbdag__proc_materials') }}
),

proc_lots as (
    select * from {{ ref('stg_innova_fbdag__proc_lots') }}
),

int_tn_fresh_yield_reporting__processing_outputs_qc as (

    select

        'TNS' as "Company",
        'FBD' as "Facility",
        null as "PalletNumber",
        null as "CaseNumber",
        matx.material::string as "ItemNumber",
        'Piece' as "PalletUoM",
        matx.weight as "PalletVolume",
        'LB' as "CaseUoM",
        matx.weight as "CaseVolume",
        matx.pieces as "Pieces",
        1::float as "FWtoLBConversion",
        matx.weight as "Lbs",
        matx.pieces as "Units",
        'Output' as "TransactionType",
        'QC Graded Fillet' as "ItemProfile",
        'ValidOutputItem' as "ItemSetCheck",
        matx.regtime as "dbDT",
        matx.regtime as "DateTime_Transaction",
        '1' as "Key_Contdtl",
        'NS_1' as "Key_Company",
        'NS_1268' as "Key_Site",
        '' as "Allocation",
        to_date(matx.regtime) as "Date_Transaction",
        to_date(matx.regtime) as "Key_Date",
        'QCScanner_' || mat.material as "Key_Item",
        'CE_' || 'TNS_' || iff(coalesce(lot.code, 'MissingLot') = '', 'MissingLot', lot.code) as "Key_Lot",
        case
            when plot.code in ('1009', '1010', '1011')
                then 'CE_1005'
            when plot.code in ('2009', '2010', '2011')
                then 'CE_2005'
            else 'CE_NoLine'
        end as "Key_Line"

    from proc_matxacts as matx

    left join proc_plots as plot
        on matx.plot = plot.plot

    left join proc_materials as mat
        on matx.material = mat.material

    left join proc_lots as lot
        on matx.lot = lot.lot

        /*******************************************************************************************************************************************
        WHERE condition notes:
                The SSRS assets are limited to just the current and previous month.
                This is explicitly intended to extract data from the QC Scanner machines for fillets that are being diverted to futher Skinless processing,
                that's why we're calling the specific plot.code values. At present, there should be no data from these machines that are going to any other processes.
        *******************************************************************************************************************************************/
    where plot.code in ('1009', '1010', '1011', '2009', '2010', '2011')
        and matx.xactpath in (9, 10, 11)

)

select * from int_tn_fresh_yield_reporting__processing_outputs_qc
