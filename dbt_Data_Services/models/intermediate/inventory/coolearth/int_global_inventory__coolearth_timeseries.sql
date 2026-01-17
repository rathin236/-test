/*******************************************************************************************************************************************
    This model captures the historical inventory changes from coolearth
    The change is captured weekly (not daily) after 11 March 2024 (after we started syncing with fivetran)
    No historical data before that date in this model
    Allocation numbers can be added to this model in the future from the contdtl_tbl (refer the current inventory model)
*******************************************************************************************************************************************/
with bindtllst as (
    select *
    from {{ ref("stg_coolearth__hist_wms_bindtlst_tbl") }}
    ),

    cur_inv as (
        select {{ convert_columns("coolearth", "wms_bindtlst_tbl") }}
        from {{ source("coolearth", "wms_bindtlst_tbl") }}
        where _fivetran_deleted = 'True' and gl_cmp_key = 'TNS'
    ), --just to identify the products currently in hand

    contdtl_tbl as (
        select *
        from {{ ref("stg_coolearth__hist_wms_contdtl_tbl") }}
        where gl_cmp_key = 'TNS'
    ),

    conthdr_tbl as (
        select *
        from {{ ref("stg_coolearth__wms_conthdr_tbl") }}
        where trim(gl_cmp_key) = 'TNS'
    ),

    /*
    using the lot history table to identify the lots which are destroyed or have bin_keys as shipped or deleted
    */

    lothist_tbl as (
        select
            gl_cmp_key,
            in_lot_key,
            in_whs_key,
            wms_conthdr_key,
            wms_contdtl_key,
            in_item_key,
            bin,
            wms_tran_type,
            cast(
                date_trunc('week', to_date(dbserverdatetime)) as date
            ) as dbserverdatetime,
            result_qty,
            row_number() over (
                partition by
                    gl_cmp_key,
                    in_whs_key,
                    wms_conthdr_key,
                    wms_contdtl_key,
                    in_item_key
                order by dbserverdatetime desc
            ) as rn
        from {{ ref("stg_coolearth__wms_lothist_tbl") }}
        where gl_cmp_key = 'TNS'
        qualify rn = 1
    ),

    vawhs as (
        select distinct
in_whs_key,
wms_conthdr_key
        from {{ ref("stg_coolearth__wms_pmint_tbl") }} as pmint
        where
            wms_pmint_crdt = (
                select min(wms_pmint_crdt)
                from {{ ref("stg_coolearth__wms_pmint_tbl") }}
                where trim(wms_conthdr_key) = pmint.wms_conthdr_key
            )
    ), --this piece of code identifies original warehouse

    label_date as (
        select
            wms_conthdr_key,
            wms_contdtl_key,
            in_whs_key,
            min(to_date(wms_contdtl_prddt)) as label_date
        from contdtl_tbl
        group by 1, 2, 3
    ),

    /*******************************************************************************************************************************************
    weekly_data captures a combination of elements that contribute to inventory balance like
       item, warehouse, pallet, batch(lot)
    It also has the production date and the catchweight from the contdtl table
    *******************************************************************************************************************************************/

    weekly_data as (
        select
            bdt.gl_cmp_key,
            bdt.in_whs_key,
            bdt.in_item_key,
            bdt.wms_conthdr_key,
            bdt.in_lot_key,
            bdt.wms_contdtl_key,
            bdt.wms_contdtl_qty as qty,
            cdtl.wms_contdtl_ctwgt,
            label_date.label_date as wms_contdtl_prddt,
            cdtl.wms_contdtl_uom,
            cdtl.wms_contcase_uom,
            to_date(bdt._fivetran_start) as _fivetran_start_date,
            date_trunc('week', to_date(bdt._fivetran_start)) as week_start_date,
            row_number() over (
            partition by
                bdt.gl_cmp_key,
                bdt.in_whs_key,
                bdt.in_item_key,
                bdt.in_lot_key,
                bdt.wms_conthdr_key,
                label_date.label_date,
                date_trunc('week', to_date(bdt._fivetran_start)) -- partition by week
            order by to_date(bdt._fivetran_start) desc -- order by date within the week
        ) as rn
        from bindtllst as bdt
        left join
            contdtl_tbl as cdtl
            on bdt.gl_cmp_key = cdtl.gl_cmp_key
            and bdt.in_whs_key = cdtl.in_whs_key
            and bdt.in_item_key = cdtl.in_item_key
            and bdt.wms_conthdr_key = cdtl.wms_conthdr_key
            and bdt.in_lot_key = cdtl.in_lot_key
            and bdt.wms_contdtl_key = cdtl.wms_contdtl_key
            and date_trunc('week', to_date(bdt._fivetran_synced))
            = date_trunc('week', to_date(cdtl._fivetran_synced))
        inner join
            conthdr_tbl as ch on trim(cdtl.wms_conthdr_key) = trim(ch.wms_conthdr_key)
        inner join
            label_date
            on trim(cdtl.wms_conthdr_key) = trim(label_date.wms_conthdr_key)
            and trim(cdtl.wms_contdtl_key) = trim(label_date.wms_contdtl_key)
            and trim(cdtl.in_whs_key) = trim(label_date.in_whs_key)
        where coalesce(trim(bdt.wms_bin_key), 'XXX') not in ('SHIPPED', 'DELETED')
        qualify rn = 1
    ),

    -- here we filter the data for picking up the quantities for each item,
    -- pallet, batch in a week
    filtered_data as (
        select
            gl_cmp_key,
            in_whs_key,
            in_item_key,
            wms_conthdr_key,
            in_lot_key,
            wms_contdtl_key,
            qty,
            wms_contdtl_ctwgt,
            wms_contdtl_prddt,
            wms_contdtl_uom,
            wms_contcase_uom,
            week_start_date
        from weekly_data
    ),

    -- these are the static elements, we will use them to create the date spine for a
    -- combination of item, lot and pallet numbers
    static_data as (
        select distinct
            bdt.gl_cmp_key,
            bdt.in_whs_key,
            bdt.in_item_key,
            bdt.wms_conthdr_key,
            bdt.in_lot_key,
            bdt.wms_contdtl_key,
            label_date.label_date as wms_contdtl_prddt,
            cdtl.wms_contdtl_uom,
            cdtl.wms_contcase_uom
        from bindtllst as bdt
        left join
            contdtl_tbl as cdtl
            on bdt.gl_cmp_key = cdtl.gl_cmp_key
            and bdt.in_whs_key = cdtl.in_whs_key
            and bdt.in_item_key = cdtl.in_item_key
            and bdt.wms_conthdr_key = cdtl.wms_conthdr_key
            and bdt.in_lot_key = cdtl.in_lot_key
            and bdt.wms_contdtl_key = cdtl.wms_contdtl_key
        inner join
            conthdr_tbl as ch on trim(cdtl.wms_conthdr_key) = trim(ch.wms_conthdr_key)
        inner join
            label_date
            on trim(cdtl.wms_conthdr_key) = trim(label_date.wms_conthdr_key)
            and trim(cdtl.wms_contdtl_key) = trim(label_date.wms_contdtl_key)
            and trim(cdtl.in_whs_key) = trim(label_date.in_whs_key)
        where coalesce(trim(bdt.wms_bin_key), 'XXX') not in ('SHIPPED', 'DELETED')
    ),

    date_spine as (
        select date_trunc('week', to_date(dates."Key_Date")) as week_start_date
        from {{ ref("dim_date") }} as dates
        where date_trunc('week', to_date(dates."Key_Date")) >= '2024-03-11'
        group by date_trunc('week', to_date(dates."Key_Date"))
        having week_start_date <= current_date
    ),

    static_data_with_dates as (
        select
            sd.gl_cmp_key,
            sd.in_whs_key,
            sd.in_item_key,
            sd.wms_conthdr_key,
            sd.in_lot_key,
            sd.wms_contdtl_key,
            sd.wms_contdtl_prddt,
            sd.wms_contcase_uom,
            sd.wms_contdtl_uom,
            ds.week_start_date
        from static_data as sd
        cross join date_spine as ds
    ),

    full_data as (
        select
            sdwd.gl_cmp_key,
            sdwd.in_whs_key,
            sdwd.in_item_key,
            sdwd.wms_conthdr_key,
            sdwd.in_lot_key,
            sdwd.wms_contdtl_key,
            fd.qty,
            fd.wms_contdtl_ctwgt,
            sdwd.wms_contdtl_prddt,
            sdwd.wms_contdtl_uom,
            sdwd.wms_contcase_uom,
            sdwd.week_start_date
        from static_data_with_dates as sdwd
        left join
            filtered_data as fd
            on sdwd.gl_cmp_key = fd.gl_cmp_key
            and sdwd.in_whs_key = fd.in_whs_key
            and sdwd.in_item_key = fd.in_item_key
            and sdwd.wms_conthdr_key = fd.wms_conthdr_key
            and sdwd.in_lot_key = fd.in_lot_key
            and sdwd.wms_contdtl_key = fd.wms_contdtl_key
            and sdwd.week_start_date = fd.week_start_date
    ),

    /*******************************************************************************************************************************************
    This part back fills the weekly timeline with the last value to show a continuous balance
    the products that have nulls in the beginning are still nulls
    Once these products will have new qty added to them, these values should get filled from that date
    *******************************************************************************************************************************************/

    final_data as (
        select
            fd.gl_cmp_key,
            fd.in_whs_key,
            fd.in_item_key,
            fd.wms_conthdr_key,
            fd.in_lot_key,
            fd.wms_contdtl_key,
            fd.wms_contdtl_prddt,
            fd.wms_contdtl_uom,
            fd.wms_contcase_uom,
            fd.week_start_date,
            case
                when
                    trim(cht.wms_bin_key) in ('SHIPPED', 'DELETED')
                    and cast(fd.week_start_date as date)
                    >= cast(cht.wms_conthdr_lstmv as date)
                then 0
                when
                    lht.bin in ('SHIPPED', 'DELETED')
                    and cast(fd.week_start_date as date)
                    >= cast(to_date(lht.dbserverdatetime) as date)
                then 0
                when
                    lht.wms_tran_type in ('DESTROY', 'DELETED')
                    and cast(fd.week_start_date as date)
                    >= cast(to_date(lht.dbserverdatetime) as date)
                then 0
                else
                    last_value(qty ignore nulls) over (
                        partition by
                            fd.gl_cmp_key,
                            fd.in_whs_key,
                            fd.in_item_key,
                            fd.wms_conthdr_key,
                            fd.in_lot_key,
                            fd.wms_contdtl_key
                        order by fd.week_start_date
                        rows between unbounded preceding and current row
                    )
            end as qty_filled,
            case
                when
                    trim(cht.wms_bin_key) in ('SHIPPED', 'DELETED')
                    and cast(fd.week_start_date as date)
                    >= cast(cht.wms_conthdr_lstmv as date)
                then 0
                when
                    lht.bin in ('SHIPPED', 'DELETED')
                    and cast(fd.week_start_date as date)
                    >= cast(to_date(lht.dbserverdatetime) as date)
                then 0
                when
                    lht.wms_tran_type in ('DESTROY', 'DELETED')
                    and cast(fd.week_start_date as date)
                    >= cast(to_date(lht.dbserverdatetime) as date)
                then 0
                else
                    last_value(wms_contdtl_ctwgt ignore nulls) over (
                        partition by
                            fd.gl_cmp_key,
                            fd.in_whs_key,
                            fd.in_item_key,
                            fd.wms_conthdr_key,
                            fd.in_lot_key,
                            fd.wms_contdtl_key
                        order by fd.week_start_date
                        rows between unbounded preceding and current row
                    )
            end as wms_contdtl_ctwgt_filled
        from full_data as fd
        left join conthdr_tbl as cht on fd.wms_conthdr_key = cht.wms_conthdr_key
        right outer join
            lothist_tbl as lht
            on fd.in_lot_key = trim(lht.in_lot_key)
            and fd.wms_conthdr_key = trim(lht.wms_conthdr_key)
            and fd.in_whs_key = lht.in_whs_key
        left join cur_inv as inv on fd.wms_conthdr_key = inv.wms_conthdr_key
    ),

    final as (
        select
            gl_cmp_key,
            in_whs_key,
            in_item_key,
            wms_conthdr_key,
            in_lot_key,
            wms_contdtl_key,
            qty_filled as qty,
            wms_contdtl_ctwgt_filled as wms_contdtl_ctwgt,
            wms_contdtl_prddt,
            wms_contdtl_uom,
            wms_contcase_uom,
            week_start_date,
            row_number() over (
                partition by
                    gl_cmp_key,
                    in_whs_key,
                    wms_conthdr_key,
                    in_lot_key,
                    in_item_key,
                    wms_contdtl_prddt, --as some pallets have a change in their original production date
                    week_start_date
                order by qty desc
            ) as rn
        from final_data
        qualify rn = 1
        order by week_start_date desc
    )

select * from final
