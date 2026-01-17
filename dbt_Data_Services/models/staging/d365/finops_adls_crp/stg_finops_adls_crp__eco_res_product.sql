with

source as (

    select * from {{ source('finops_adls_crp', 'eco_res_product') }}

),

renamed as (

    select
        recid,
        _sys_row_id,
        lsn,
        last_processed_change_date_time,
        data_lake_modified_date_time,
        instancerelationtype,
        pdscwproduct,
        producttype,
        searchname,
        servicetype,
        engchgproductcategorydetails,
        engchgproductreleasepolicy,
        partition,
        recversion,
        modifiedby,
        relationtype,
        engchgproductreadinesspolicy,
        modifieddatetime,
        _fivetran_deleted,
        _fivetran_synced,
        trim(displayproductnumber) as displayproductnumber

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
