with proc_matxacts as (
    select * from {{ ref('stg_innova_fbdag__proc_matxacts') }}
),

proc_materials as (
    select * from {{ ref('stg_innova_fbdag__proc_materials') }}
),

int_tnfresh_yield_reporting__dim_item_innova as (
    select distinct
        'Graded Fillet' as "ItemDescription",
        'Graded Fillet' as "ItemDisplayDescription",
        'QC Scanner Output' as "ItemType",
        'Fillet Prem' as "ItemClass",
        null as "CatchArea",
        'Fillet' as "Category",
        'FLT' as "CWCategory",
        'TNS' as "Division",
        'Fin Fish' as "Family",
        'Finished Good' as "FinishedForm",
        'Fresh' as "Form",
        'Premium' as "Grade",
        'Salmon' as "HighLevelCategory",
        'Premium' as "HighLevelGrade",
        null as "InsidePackType",
        null as "MasterPackagingType",
        null as "Scaled",
        'GradedFillet' as "Size",
        null as "SkinOnOff",
        null as "SkinningType",
        'Salmon' as "Species",
        'Fillet Skin On' as "SubCategory",
        'Atlantic Salmon' as "SubSpecies",
        'D' as "Trim",
        'VA' as "WholeVA",
        'Farm' as "WildOrFarmed",
        'Skinless+Deep Skinless+Full Deep Skinless' as "YieldClass",
        trim(mat.material::string) as "ItemNumber",
        'QCScanner_' || trim(mat.material::string) as "Key_Item"

    from proc_matxacts as mtx

    left join proc_materials as mat
        on mtx.material = mat.material
)

select * from int_tnfresh_yield_reporting__dim_item_innova
