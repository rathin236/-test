with inventorylbconversion as (
    select
        uomconv.product,
        prod.displayproductnumber as itemid,
        uomfrom.symbol as fromuom,
        uomto.symbol as touom,
        uomconv.factor
    from {{ ref('stg_d365__unit_of_measure_conversion') }} as uomconv

    left join {{ ref('stg_d365__unit_of_measure') }} as uomfrom
        on uomconv.fromunitofmeasure = uomfrom.recid

    left join {{ ref('stg_d365__unit_of_measure') }} as uomto
        on uomconv.tounitofmeasure = uomto.recid

    left join {{ ref('stg_d365__eco_res_product') }} as prod
        on uomconv.product = prod.recid

    where uomconv.tounitofmeasure = '5637145330'
)

select * from inventorylbconversion
