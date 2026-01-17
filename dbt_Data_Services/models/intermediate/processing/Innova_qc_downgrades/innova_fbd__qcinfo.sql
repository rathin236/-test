with qcs as (
    select * from {{ ref('stg_innova_fbdag__qcs_dataagg') }}
),

prperiods as (
    select * from {{ ref('stg_innova_fbdag__proc_prperiods') }}
),

stations as (
    select * from {{ ref('stg_innova_fbdag__qcs_stations') }}
),

devices as (
    select * from {{ ref('stg_innova_fbdag__base_devices') }}
),

pos as (
    select * from {{ ref('stg_innova_fbdag__proc_pos') }}
),

lots as (
    select * from {{ ref('stg_innova_fbdag__proc_lots') }}
),

shifts as (
    select * from {{ ref('stg_innova_fbdag__proc_shifts') }}
),

materials as (
    select * from {{ ref('stg_innova_fbdag__proc_materials') }}
),

defectclasses as (
    select * from {{ ref('stg_innova_fbdag__qcs_defectclasses') }}
),

reasons as (
    select * from {{ ref('stg_innova_fbdag__qcs_dataaggreasons') }}
),

color_off_spec_reason as (
    select
        dataagg,
        category2
    from reasons
    where programparameter = 1072
),

dark_spots_reason as (
    select
        dataagg,
        triggerlimits
    from reasons
    where programparameter = 1105
),

qcinfo as (
    select
        qcs_dataagg.id as qcs_dataagg_id,
        qcs_dataagg.station as qcs_dataagg_station,
        intlookuptable27916.name as qcscannername,
        qcs_dataagg.device as qcs_dataagg_device,
        intlookuptable27917.name as intlookupcol102497,
        intlookuptable27917.code as intlookupcol102498,
        intlookuptable27917.active as intlookupcol102499,
        intlookuptable27917.objecttemplate as intlookupcol102500,
        qcs_dataagg.prperiod as qcs_dataagg_prperiod,
        intlookuptable27918.prperiod as intlookupcol102501,
        qcs_dataagg.sprperiod as qcs_dataagg_sprperiod,
        intlookuptable27919.prperiod as intlookupcol102502,
        qcs_dataagg.po as qcs_dataagg_po,
        intlookuptable27920.name as intlookupcol102503,
        intlookuptable27920.code as intlookupcol102504,
        intlookuptable27920.active as intlookupcol102505,
        intlookuptable27920.objecttemplate as intlookupcol102506,
        qcs_dataagg.lot as qcs_dataagg_lot,
        intlookuptable27921.name as base_product_code,
        intlookuptable27921.code as intlookupcol102508,
        intlookuptable27921.active as intlookupcol102509,
        intlookuptable27921.objecttemplate as intlookupcol102510,
        qcs_dataagg.shift as qcs_dataagg_shift,
        intlookuptable27922.name as intlookupcol102511,
        intlookuptable27922.code as intlookupcol102512,
        intlookuptable27922.active as intlookupcol102513,
        intlookuptable27922.objecttemplate as intlookupcol102514,
        qcs_dataagg.batch as qcs_dataagg_batch,
        qcs_dataagg.material as qcs_dataagg_material,
        intlookuptable27923.name as intlookupcol102515,
        intlookuptable27923.code as intlookupcol102516,
        intlookuptable27923.active as intlookupcol102517,
        intlookuptable27923.objecttemplate as intlookupcol102518,
        qcs_dataagg.laneid as qcs_dataagg_laneid,
        qcs_dataagg.regtime as qcs_dataagg_regtime,
        qcs_dataagg.modtime as qcs_dataagg_modtime,
        qcs_dataagg.destination as qcs_dataagg_destination,
        qcs_dataagg.activeseconds as qcs_dataagg_activeseconds,
        qcs_dataagg.nregs as qcs_dataagg_nregs,

        --query taken from [CookeFBD>Pivot Reports>QC Scanner Pivot Report] in innova for FBD--
        qcs_dataagg.nregstriggerlimit as qcs_dataagg_nregstriggerlimit,

        qcs_dataagg.weight as qcs_dataagg_weight,

        qcs_dataagg.rtype as qcs_dataagg_rtype,
        qcs_dataagg.defectclass as qcs_dataagg_defectclass,
        intlookuptable27924.name as intlookupcol102519,
        proc_prperiods.prday as proc_prperiods_prday,
        case
        when intlookuptable27921.name ilike '%T' then 'Trout'
        else 'Salmon'
        end as base_product,
        case qcs_dataagg.shift
            when 1 then 'Day'
            when 2 then 'Night'
        end as shift_name,
        case qcs_dataagg.scanningresult
            when 1 then 'Passed Q1'
            when 2 then 'Passed Q2'
            when 3 then 'Rejected'
            else 'Not Scanned'
        end as qcs_dataagg_scanningresult,
        case
            when qcs_dataagg.scanningresult = 3 then coalesce(color_off_spec_reason.category2, 0)
            else 0
        end as color_off_spec,
        case
            when qcs_dataagg.scanningresult = 3 then coalesce(dark_spots_reason.triggerlimits, 0)
            else 0
        end as dark_spots

    from
        qcs as qcs_dataagg

    left join prperiods as proc_prperiods on qcs_dataagg.prperiod = proc_prperiods.prperiod
    left join stations as intlookuptable27916 on qcs_dataagg.station = intlookuptable27916.id
    left join devices as intlookuptable27917 on qcs_dataagg.device = intlookuptable27917.device
    left join prperiods as intlookuptable27918 on qcs_dataagg.prperiod = intlookuptable27918.prperiod
    left join prperiods as intlookuptable27919 on qcs_dataagg.sprperiod = intlookuptable27919.prperiod
    left join pos as intlookuptable27920 on qcs_dataagg.po = intlookuptable27920.po
    left join lots as intlookuptable27921 on qcs_dataagg.lot = intlookuptable27921.lot
    left join shifts as intlookuptable27922 on qcs_dataagg.shift = intlookuptable27922.shift
    left join materials as intlookuptable27923 on qcs_dataagg.material = intlookuptable27923.material
    left join defectclasses as intlookuptable27924 on qcs_dataagg.defectclass = intlookuptable27924.id
    left join color_off_spec_reason on qcs_dataagg.id = color_off_spec_reason.dataagg
    left join dark_spots_reason on qcs_dataagg.id = dark_spots_reason.dataagg

    where proc_prperiods.prday >= current_date - 30
)

select * from qcinfo
