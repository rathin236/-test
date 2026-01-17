with taxonomy_output as (
    select
        root.curvename,
        root.lastupdatedate,
        val.value:category::varchar(255) as category,
        val.value:dimension::varchar(255) as dimension,
        val.value:dimension_abbr::varchar(255) as dimension_abbr
    from
        (
            select distinct
                taxo.curvename,
                taxo.lastupdatedate,
                taxo.taxonomy_detail
            from {{ ref('stg_kontali__kontali_curve_taxonomy') }} as taxo
            inner join
                (
                    select
                        tax1.curvename,
                        max(tax1.lastupdatedate) as max_date
                    from {{ ref('stg_kontali__kontali_curve_taxonomy') }} as tax1
                    group by tax1.curvename
                ) as sub
                on taxo.curvename = sub.curvename
                    and taxo.lastupdatedate = sub.max_date
        ) as root,
        lateral flatten(input => taxonomy_detail) as val
)

select * from taxonomy_output
