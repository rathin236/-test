with view_import_curves_final as (
    select * from {{ ref('int_kontali_view3_import') }}
)

select * from view_import_curves_final
