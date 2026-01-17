with item_attribute_begin as (
    select

        itm.itemdescription as item_description,
        typ.description as item_type,
        sch.scheduleid as uom_schedule_id,
        sch.description as uom_schedule_description,
        atr.attribute as attribute_description,
        uom1.uomid as default_unit_uom,
        uom2.uomid as default_weight_uom,
        uom3.uomid as default_price_uom,
        itm.dataentitycompanysk as dataentitycompany_sk,
        company.companyid as source_system,
        trim(itm.itemsk) as item_sk,
        trim(itm.itemid) as item_id,
        trim(itm.itemid::string) || ' - ' || trim(itm.itemdescription::string) as item_display_description,
        trim(class.description) as item_class,
        case atr.attributedatatypeen
            when 2 then mfav.attributevalue
            when 1 then coalesce(iia.attributevalue, '')
            when 3 then coalesce((iia.attributevalue), '')
        end as attribute_value

    from {{ ref('stg_northscope_sb1__erpx_im_item') }} as itm

    inner join {{ ref('stg_northscope_sb1__erpx_mf_data_entity_company') }} as company
        on itm.dataentitycompanysk = company.dataentitycompanysk

    left outer join {{ ref('stg_northscope_sb1__erpx_im_item_class') }} as class
        on itm.itemclasssk = class.itemclasssk

    left outer join {{ ref('stg_northscope_sb1__erpx_im_item_type') }} as typ
        on itm.itemtypesk = typ.itemtypesk

    left outer join {{ ref('stg_northscope_sb1__erpx_im_uom_schedule') }} as sch
        on itm.uomschedulesk = sch.uomschedulesk

    left outer join {{ ref('stg_northscope_sb1__erpx_im_item_attributes') }} as iia
        on itm.itemsk = iia.itemsk

    left outer join {{ ref('stg_northscope_sb1__erpx_mf_attribute') }} as atr
        on iia.attributesk = atr.attributesk

    left outer join {{ ref('stg_northscope_sb1__erpx_mf_attribute_class') }} as mfac
        on itm.attributeclasssk = mfac.attributeclasssk

    left outer join {{ ref('stg_northscope_sb1__erpx_mf_attribute_value') }} as mfav
        on to_char(mfav.attributevaluesk) = iia.attributevalue
            and iia.attributesk = mfav.attributesk

    left outer join {{ ref('stg_northscope_sb1__erpx_im_uom') }} as uom1
        on itm.defaultsounituomsk = uom1.uomsk

    left outer join {{ ref('stg_northscope_sb1__erpx_im_uom') }} as uom2
        on itm.defaultsoweightuomsk = uom2.uomsk

    left outer join {{ ref('stg_northscope_sb1__erpx_im_uom') }} as uom3
        on itm.defaultsopriceuomsk = uom3.uomsk
)

select * from item_attribute_begin
