with tn_fresh_dim_item as (
    select * from {{ ref('tn_fresh_dim_item') }}
),

tn_fresh_dim_lot as (
    select * from {{ ref('tn_fresh_dim_lot') }}
),

tn_fresh_dim_production_line as (
    select * from {{ ref('tn_fresh_dim_production_line') }}
),

-- noqa: disable=PRS
inputs_unioned as (
    {{ dbt_utils.union_relations(

    relations=[ref('int_tn_fresh_yield_reporting__processing_inputs_ns'),
                ref('int_tn_fresh_yield_reporting__processing_inputs_innova')
    ]
) }}
),
-- noqa: enable=PRS

/* Dimensions */
tn_fresh_fact_processing_inputs as (

    select

        inputs."Company",
        inputs."Facility",
        inputs."PalletNumber",
        inputs."CaseNumber",
        inputs."ItemNumber",
        inputs."PalletUoM",
        inputs."PalletVolume",
        inputs."CaseUoM",
        inputs."CaseVolume",
        inputs."Pieces",
        inputs."FWtoLBConversion",
        inputs."TransactionType",
        inputs."dbDT",
        inputs."DateTime_Transaction",
        inputs."Date_Transaction",
        inputs."Key_Contdtl",
        inputs."Key_Date",
        inputs."Lbs",
        inputs."Units",
        inputs."ItemProfile",
        inputs."ItemSetCheck",
        inputs."Key_Company",
        inputs."Key_Site",
        inputs."Key_Item",
        inputs."Key_Lot",
        inputs."Key_Line",
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

    from inputs_unioned as inputs

    left join tn_fresh_dim_item as item
        on inputs."Key_Item" = item."Key_Item"

    left join tn_fresh_dim_lot as lot
        on inputs."Key_Lot" = lot."Key_lot"

    left join tn_fresh_dim_production_line as prodline
        on inputs."Key_Line" = prodline."Key_Line"
)

select * from tn_fresh_fact_processing_inputs
