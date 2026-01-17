with wms_lot_tbl as (
    select * from {{ ref('stg_coolearth__wms_lot_tbl') }}
),

wm_lot_farm as (
    select * from {{ ref('stg_coolearth__wm_lot_farm') }}
),

wm_lot_farm_list_agg as (
    select

        wml1.company,
        wml1.lot,
        wml1.farm,
        listagg(wml2.cage, ',') within group (order by wml2.cage) as cages

    from wm_lot_farm as wml1

    left join wm_lot_farm as wml2
        on wml1.lot = wml2.lot

    group by
        wml1.company,
        wml1.lot,
        wml1.farm
),

tn_fresh_dim_lot as (
    select
        lot.en_lot_key as "LotNumber",
        lot.owner as "Owner",
        lot.harvestdate as "HarvestDateTime",
        lot.harvestdate::string as "HarvestDate",
        farm.farm as "Farm",
        farm.cages as "Cages",
        lot.vessel as "Vessel",
        lot.countryoforigin as "CountryOfOrigin",
        lot.certifications as "Certifications",

        -- These are Key references that can be used to join between other dimensions
        'CE_' || lot.gl_cmp_key || '_' || lot.en_lot_key as "Key_lot"

    from wms_lot_tbl as lot

    left join wm_lot_farm_list_agg as farm
        on lot.en_lot_key = farm.lot
            and lot.gl_cmp_key = farm.company

    where lot.gl_cmp_key = 'TNS'

    qualify row_number() over (
                partition by "Key_lot"                
                order by "Key_lot" desc
            ) = 1

)

select * from tn_fresh_dim_lot
