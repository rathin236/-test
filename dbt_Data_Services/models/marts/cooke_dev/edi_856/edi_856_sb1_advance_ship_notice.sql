with advance_ship_notice as (
    select

        'COOKE' as client_id,
        company.companyid as source,
        soh.orderid as order_id,
        '' as filename,
        current_date() as date_created,
        md5(soh.orderid::string) as incremental_uid

    from {{ ref('stg_northscope_sb1__erpx_so_order_header') }} as soh

    inner join {{ ref('stg_northscope_sb1__erpx_mf_data_entity_company') }} as company
        on soh.dataentitycompanysk = company.dataentitycompanysk

)

select * from advance_ship_notice
