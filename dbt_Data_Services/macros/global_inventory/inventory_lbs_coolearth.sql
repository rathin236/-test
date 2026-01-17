{% macro convert_to_lb_ce(in_wms_contdtl_uom, in_wms_contdtl_qty, in_wms_contdtl_ctwgt, in_wms_contcase_uom, in_lb_conv_conversionvalue) %}
    case
        when upper(trim({{ in_wms_contdtl_uom }})) = 'LB' then {{ in_wms_contdtl_qty }}
        when upper(trim({{ in_wms_contdtl_uom }})) = 'KG' then {{ in_wms_contdtl_qty }} * {{ in_lb_conv_conversionvalue }}
        when upper(trim({{ in_wms_contdtl_uom }})) in ('CASE', 'BAG', 'TRAY', 'EACH') and {{ in_wms_contdtl_ctwgt }} = 0 and upper(trim({{ in_wms_contcase_uom }})) is null then {{ in_wms_contdtl_qty }} * {{ in_lb_conv_conversionvalue }}
        when upper(trim({{ in_wms_contdtl_uom }})) in ('CASE', 'BAG', 'TRAY', 'EACH') and {{ in_wms_contdtl_ctwgt }} <> 0 and upper(trim({{ in_wms_contcase_uom }})) = 'KG' then {{ in_wms_contdtl_ctwgt }} * 2.2046
        when upper(trim({{ in_wms_contdtl_uom }})) in ('CASE', 'BAG', 'TRAY', 'EACH') and {{ in_wms_contdtl_ctwgt }} <> 0 and upper(trim({{ in_wms_contcase_uom }})) = 'LB' then {{ in_wms_contdtl_ctwgt }}
        else {{ in_wms_contdtl_ctwgt }}
    end
{% endmacro %}
