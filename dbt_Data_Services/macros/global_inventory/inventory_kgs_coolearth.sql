{% macro convert_to_kg_ce(cdtl_wms_contdtl_uom, cdtl_wms_contdtl_qty, cdtl_wms_contdtl_ctwgt, cdtl_wms_contcase_uom, lb_conv_conversionvalue) %}
    case
        when trim({{ cdtl_wms_contdtl_uom }}) in ('CASE', 'BAG', 'TRAY', 'EACH') and trim({{ cdtl_wms_contdtl_ctwgt }}) <> 0 and trim({{ cdtl_wms_contcase_uom }}) = 'KG'
            then {{ cdtl_wms_contdtl_ctwgt }}
        else (
            case
                when trim({{ cdtl_wms_contdtl_uom }}) = 'LB' then {{ cdtl_wms_contdtl_qty }}
                when trim({{ cdtl_wms_contdtl_uom }}) = 'KG' then {{ cdtl_wms_contdtl_qty }} * {{ lb_conv_conversionvalue }}
                when trim({{ cdtl_wms_contdtl_uom }}) in ('CASE', 'BAG', 'TRAY', 'EACH') and trim({{ cdtl_wms_contdtl_ctwgt }}) = 0 and {{ cdtl_wms_contcase_uom }} is null
                    then trim({{ cdtl_wms_contdtl_qty }}) * trim({{ lb_conv_conversionvalue }})
                else {{ cdtl_wms_contdtl_ctwgt }}
            end
        ) / 2.2046
    end
{% endmacro %}
