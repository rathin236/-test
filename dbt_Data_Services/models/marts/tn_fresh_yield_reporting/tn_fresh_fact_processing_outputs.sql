with int_tn_fresh_yield_reporting__processing_outputs_cases as (
    select * from {{ ref('int_tn_fresh_yield_reporting__processing_outputs_cases') }}
),

int_tn_fresh_yield_reporting__processing_outputs_pallets as (
    select * from {{ ref('int_tn_fresh_yield_reporting__processing_outputs_pallets') }}
),

int_tn_fresh_yield_reporting__processing_outputs_qc as (
    select * from {{ ref('int_tn_fresh_yield_reporting__processing_outputs_qc') }}
),

tn_fresh_dim_item as (
    select * from {{ ref('tn_fresh_dim_item') }}
),

tn_fresh_dim_lot as (
    select * from {{ ref('tn_fresh_dim_lot') }}
),

tn_fresh_dim_production_line as (
    select * from {{ ref('tn_fresh_dim_production_line') }}
),

-- noqa: disable=PRS
outputs_unioned as (
    {{ dbt_utils.union_relations(

        relations=[ref('int_tn_fresh_yield_reporting__processing_outputs_cases'),
                    ref('int_tn_fresh_yield_reporting__processing_outputs_pallets'),
                    ref('int_tn_fresh_yield_reporting__processing_outputs_qc')
        ],
        column_override={"Units": "number(10)"}
    ) }}
),
-- noqa: enable=PRS

/* Dimensions */
tn_fresh_fact_processing_outputs as (

    select

        outputs."Company",
        outputs."Facility",
        outputs."PalletNumber",
        outputs."CaseNumber",
        outputs."ItemNumber",
        outputs."PalletUoM",
        outputs."PalletVolume",
        outputs."CaseUoM",
        outputs."CaseVolume",
        outputs."Pieces",
        outputs."FWtoLBConversion",
        outputs."TransactionType",
        outputs."dbDT",
        outputs."DateTime_Transaction",
        outputs."Date_Transaction",
        outputs."Key_Contdtl",
        outputs."Key_Date",
        outputs."Lbs" as "OutputLbs",
        outputs."Units",
        outputs."ItemProfile",
        outputs."ItemSetCheck",
        outputs."Key_Company",
        outputs."Key_Site",
        outputs."Key_Item",
        outputs."Key_Lot",
        outputs."Key_Line",
        outputs."Allocation",
        lot."LotNumber" as "Lot_Number",
        item."ItemDescription" as "Item_Description",
        lot."Farm",
        prodline."LineDescription" as "Line_Description",
        item."Category",
        item."CWCategory" as "CW_Category",
        item."Size",
        item."Grade",
        item."Form",
        item."Trim",
        item."Scaled",
        lot."Owner"

    from outputs_unioned as outputs

    left join tn_fresh_dim_item as item
        on outputs."Key_Item" = item."Key_Item"

    left join tn_fresh_dim_lot as lot
        on outputs."Key_Lot" = lot."Key_lot"

    left join tn_fresh_dim_production_line as prodline
        on outputs."Key_Line" = prodline."Key_Line"
)

select * from tn_fresh_fact_processing_outputs
{# and "Key_Date" = '2024-04-02' #}
{# and trim("PalletNumber") = '12160570' #}
{# and trim("Key_Line") = 'CE_3003'  #}