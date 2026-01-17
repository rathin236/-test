with latestcurves as (
    select
        *,
        row_number() over (
            partition by "Curve_Name"
            order by
                lastupdatedate desc
        ) as rn
    from
        {{ ref('stg_kontali__kontali_api_response') }}
    where
        category = 'NASDAQ-Pricing'
),

pricing_nasdaq as (
    select
        --root.LASTUPDATEDATE,
        root.json_data:name::varchar(256) as curvename,
        --Concat(REPLACE(REPLACE(SPLIT(root.JSON_DATA:name::varchar(256), ' ')[5], '"', ''), ' ', ''),' KG') as WeightClass,
        case
            when concat(
                replace(
                    replace(
                        split(root.json_data:name::varchar(256), ' ')[5],
                        '"',
                        ''
                    ),
                    ' ',
                    ''
                ),
                ' KG'
            ) = 'NOK_kg KG' then 'NQSALMON'
            when concat(
                replace(
                    replace(
                        split(root.json_data:name::varchar(256), ' ')[5],
                        '"',
                        ''
                    ),
                    ' ',
                    ''
                ),
                ' KG'
            ) = 't KG' then 'NQSALMON'
            else concat(
                replace(
                    replace(
                        split(root.json_data:name::varchar(256), ' ')[5],
                        '"',
                        ''
                    ),
                    ' ',
                    ''
                ),
                ' KG'
            )
        end as weightclass,
        --root.json_data:timeseries_type::varchar(256) Timeseries_Type,
        vl.value:timestamp::timestamp as timestamp,
        (year(vl.value:timestamp::timestamp))::varchar(255) as year,
        date_part('WEEK', vl.value:timestamp::timestamp) as "Week",
        --vl.value:updated_at::timestamp updated_At,
        vl.value:value::string as price,
        'NOK' as currency,
        '' as volume
    from
        latestcurves as root,
        lateral flatten(input => root.json_data:timeseries) as vl
    where
        category = 'NASDAQ-Pricing'
        and root.rn = 1
        and curvename like '%NOK_kg weekly%' --and WeightClass != 'NQSALMON'
),

--select * from Pricing_NASDAQ
pricing_sov_curves as (
    select
        --root.LASTUPDATEDATE,
        root.json_data:name::varchar(256) as curvename,
        --Concat(REPLACE(REPLACE(SPLIT(root.JSON_DATA:name::varchar(256), ' ')[5], '"', ''), ' ', ''),' KG') as WeightClass,
        vl.value:timestamp::timestamp as timestamp,
        --root.json_data:timeseries_type::varchar(256) Timeseries_Type,
        (year(vl.value:timestamp::timestamp))::varchar(255) as year,
        vl.value:value::string as price,
        'NOK' as currency,
        --vl.value:updated_at::timestamp updated_At,
        '' as volume,
        case
            when concat(
                replace(
                    replace(
                        split(root.json_data:name::varchar(256), ' ')[5],
                        '"',
                        ''
                    ),
                    ' ',
                    ''
                ),
                ' KG'
            ) = 'NOK_kg KG' then 'NQSALMON'
            when concat(
                replace(
                    replace(
                        split(root.json_data:name::varchar(256), ' ')[5],
                        '"',
                        ''
                    ),
                    ' ',
                    ''
                ),
                ' KG'
            ) = 't KG' then 'NQSALMON'
            else concat(
                replace(
                    replace(
                        split(root.json_data:name::varchar(256), ' ')[5],
                        '"',
                        ''
                    ),
                    ' ',
                    ''
                ),
                ' KG'
            )
        end as weightclass,
        date_part('WEEK', vl.value:timestamp::timestamp) as "Week"
    from
        latestcurves as root,
        lateral flatten(input => root.json_data:timeseries) as vl
    where
        category = 'NASDAQ-Pricing'
        and root.rn = 1
        and curvename like '%sov%' --and WeightClass != 'NQSALMON'
),

volume_nasdaq as (
    select
        --root.LASTUPDATEDATE,
        root.json_data:name::varchar(256) as curvename,
        --Concat(REPLACE(REPLACE(SPLIT(root.JSON_DATA:name::varchar(256), ' ')[5], '"', ''), ' ', ''),' KG') as WeightClass,
        vl.value:timestamp::timestamp as timestamp,
        --root.json_data:timeseries_type::varchar(256) Timeseries_Type,
        (year(vl.value:timestamp::timestamp))::varchar(255) as year,
        '' as price,
        'NOK' as currency,
        --vl.value:updated_at::timestamp updated_At,
        vl.value:value::string as volume,
        case
            when concat(
                replace(
                    replace(
                        split(root.json_data:name::varchar(256), ' ')[5],
                        '"',
                        ''
                    ),
                    ' ',
                    ''
                ),
                ' KG'
            ) = 'NOK_kg KG' then 'NQSALMON'
            when concat(
                replace(
                    replace(
                        split(root.json_data:name::varchar(256), ' ')[5],
                        '"',
                        ''
                    ),
                    ' ',
                    ''
                ),
                ' KG'
            ) = 't KG' then 'NQSALMON'
            else concat(
                replace(
                    replace(
                        split(root.json_data:name::varchar(256), ' ')[5],
                        '"',
                        ''
                    ),
                    ' ',
                    ''
                ),
                ' KG'
            )
        end as weightclass,
        date_part('WEEK', vl.value:timestamp::timestamp) as "Week"
    from
        latestcurves as root,
        lateral flatten(input => root.json_data:timeseries) as vl
    where
        category = 'NASDAQ-Pricing'
        and root.rn = 1
        and curvename like '%vol%' --and WeightClass = 'NQSALMON'
),

--select * from Volume_NASDAQ
both_units_curves_nd as (
    select
        pricing_nasdaq.curvename,
        pricing_nasdaq.weightclass,
        pricing_nasdaq.timestamp,
        pricing_nasdaq.year,
        pricing_nasdaq."Week",
        pricing_nasdaq.price,
        pricing_nasdaq.currency,
        volume_nasdaq.volume
    from
        pricing_nasdaq
        inner join volume_nasdaq on pricing_nasdaq.weightclass = volume_nasdaq.weightclass
        and pricing_nasdaq."Week" = volume_nasdaq."Week"
        and pricing_nasdaq.timestamp = volume_nasdaq.timestamp
    where
        pricing_nasdaq.weightclass not in ('3-6 KG', '6+ KG', '1-3 KG')
),

sov_volume as (
    select
        voln.curvename as vol_nasdaq,
        sovv.curvename as sovcurvname,
        voln.timestamp,
        voln.year,
        voln."Week",
        sovv.weightclass,
        coalesce(try_cast((voln.volume) as number), 0),
        coalesce(sovv.price, 0),
        (voln.volume * sovv.price)::number(38, 2) as requiredvolume --COALESCE((NULLIF((volN.volume * sovV.Price),''),0) as RequiredVolume
    from
        volume_nasdaq as voln
        inner join pricing_sov_curves as sovv on voln.timestamp = sovv.timestamp
        and voln.year = sovv.year
        and voln."Week" = sovv."Week" -- where volN.Year= '2020' and VolN."Week" = '1'*/
),

final_sov as (
    select
        pnd.curvename,
        pnd.weightclass,
        pnd.timestamp,
        pnd.year,
        pnd."Week",
        pnd.price,
        pnd.currency,
        sovv.requiredvolume as volume
    from
        sov_volume as sovv
        inner join pricing_nasdaq as pnd on sovv.weightclass = pnd.weightclass
        and sovv.timestamp = pnd.timestamp
        and sovv.year = pnd.year
        and sovv."Week" = pnd."Week"
    order by
        pnd.curvename asc,
        pnd.year desc
),

final_nasdaq as (
    select
        f.curvename,
        f.weightclass,
        f.timestamp,
        f.year,
        f."Week",
        f.price,
        f.currency,
        // CAST(ROUND(volN.volume * sovV.Price) AS NUMBER(38, 0)) AS RequiredVolume
        (coalesce(nullif(f.volume, ''), 0))::number(38, 2) as volume
    from
        (
            select *
            from
                pricing_nasdaq
            where
                weightclass != 'NQSALMON'
            union distinct
            select *
            from
                both_units_curves_nd
        ) as f
    where
        f.weightclass not in ('1-3 KG', '6+ KG', '3-6 KG')
    order by
        f.curvename asc,
        f.year desc
),

final_historical as (
    select *
    from
        final_nasdaq
    union distinct
    select *
    from
        final_sov
),

curves_sisalmoni as (
    select
        *,
        row_number() over (
            partition by "Curve_Name"
            order by
                lastupdatedate desc
        ) as rn
    from
        {{ ref('stg_kontali__kontali_api_response') }}
    where
        category = 'SISALMONI'
),

pricing_sisalmoni as (
    select
        --root.LASTUPDATEDATE,
        root.json_data:name::varchar(256) as curvename,
        --Concat(REPLACE(REPLACE(SPLIT(root.JSON_DATA:name::varchar(256), ' ')[5], '"', ''), ' ', ''),' KG') as WeightClass,
        case
            when concat(
                replace(
                    replace(
                        split(root.json_data:name::varchar(256), ' ')[5],
                        '"',
                        ''
                    ),
                    ' ',
                    ''
                ),
                ' KG'
            ) = 'NOK_kg KG' then 'SISALMONI'
            when concat(
                replace(
                    replace(
                        split(root.json_data:name::varchar(256), ' ')[5],
                        '"',
                        ''
                    ),
                    ' ',
                    ''
                ),
                ' KG'
            ) = 't KG' then 'SISALMONI'
            else concat(
                replace(
                    replace(
                        split(root.json_data:name::varchar(256), ' ')[5],
                        '"',
                        ''
                    ),
                    ' ',
                    ''
                ),
                ' KG'
            )
        end as weightclass,
        --root.json_data:timeseries_type::varchar(256) Timeseries_Type,
        vl.value:timestamp::timestamp as timestamp,
        (year(vl.value:timestamp::timestamp))::varchar(255) as year,
        date_part('WEEK', vl.value:timestamp::timestamp) as "Week",
        --vl.value:updated_at::timestamp updated_At,
        vl.value:value::string as price,
        'NOK' as currency,
        '' as volume
    from
        curves_sisalmoni as root,
        lateral flatten(input => root.json_data:timeseries) as vl
    where
        category = 'SISALMONI'
        and root.rn = 1
        and curvename like '%NOK_kg weekly%' --and WeightClass != 'NQSALMON'
),

--select * from Pricing_SISALMONI
volume_sisalmoni as (
    select
        --root.LASTUPDATEDATE,
        root.json_data:name::varchar(256) as curvename,
        --Concat(REPLACE(REPLACE(SPLIT(root.JSON_DATA:name::varchar(256), ' ')[5], '"', ''), ' ', ''),' KG') as WeightClass,
        vl.value:timestamp::timestamp as timestamp,
        --root.json_data:timeseries_type::varchar(256) Timeseries_Type,
        (year(vl.value:timestamp::timestamp))::varchar(255) as year,
        '' as price,
        'NOK' as currency,
        --vl.value:updated_at::timestamp updated_At,
        vl.value:value::string as volume,
        case
            when concat(
                replace(
                    replace(
                        split(root.json_data:name::varchar(256), ' ')[5],
                        '"',
                        ''
                    ),
                    ' ',
                    ''
                ),
                ' KG'
            ) = 'NOK_kg KG' then 'SISALMONI'
            when concat(
                replace(
                    replace(
                        split(root.json_data:name::varchar(256), ' ')[5],
                        '"',
                        ''
                    ),
                    ' ',
                    ''
                ),
                ' KG'
            ) = 't KG' then 'SISALMONI'
            else concat(
                replace(
                    replace(
                        split(root.json_data:name::varchar(256), ' ')[5],
                        '"',
                        ''
                    ),
                    ' ',
                    ''
                ),
                ' KG'
            )
        end as weightclass,
        date_part('WEEK', vl.value:timestamp::timestamp) as "Week"
    from
        curves_sisalmoni as root,
        lateral flatten(input => root.json_data:timeseries) as vl
    where
        category = 'SISALMONI'
        and root.rn = 1
        and curvename like '%vol%'
) --select * from Volume_SISALMONI
,
both_units_curves as (
    select
        pricing_sisalmoni.curvename,
        --Volume_SISALMONI.CurveName,
        pricing_sisalmoni.weightclass,
        pricing_sisalmoni.timestamp,
        pricing_sisalmoni.year,
        pricing_sisalmoni."Week",
        pricing_sisalmoni.price,
        pricing_sisalmoni.currency,
        volume_sisalmoni.volume
    from
        pricing_sisalmoni
        inner join volume_sisalmoni on pricing_sisalmoni.weightclass = volume_sisalmoni.weightclass
        and pricing_sisalmoni."Week" = volume_sisalmoni."Week"
        and pricing_sisalmoni.timestamp = volume_sisalmoni.timestamp
),

final_sisalmoni as (
    select
        f.curvename,
        f.weightclass,
        f.timestamp,
        f.year,
        f."Week",
        f.price,
        f.currency,
        // CAST(ROUND(volN.volume * sovV.Price) AS NUMBER(38, 0)) AS RequiredVolume
        (coalesce(nullif(f.volume, ''), 0))::number(38, 2) as volume
    from
        (
            select *
            from
                pricing_sisalmoni
            where
                weightclass not in ('SISALMONI', '1-3 KG', '3-6 KG', '6+ KG')
            union distinct
            select *
            from
                both_units_curves
        ) as f
        --where f.CurveName = 'SAL MCR NO NQSAL IndP NOK_kg weekly Act NQ' and f.Year = 2020
    order by
        f.curvename asc,
        f.year desc
)

select *
from
    (
        select *
        from
            final_sisalmoni
        union distinct
        select *
        from
            final_historical
    ) as f
order by
    f.curvename asc,
    f.year asc,
    f."Week" desc --where f.CurveName = 'SAL MCR NO NQSAL IndP NOK_kg weekly Act NQ'
    ------------------------------------------------------------------------
