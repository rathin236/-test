with source as (
    select *
    from {{ source('finops_synapse', 'ecoresproduct') }}
),

renamed as (
    select
        id,
        sink_created_on,
        sink_modified_on,
        pdscwproduct,
        producttype,
        servicetype,
        sysdatastatecode,
        displayproductnumber,
        instancerelationtype,
        searchname,
        engchgproductownerid,
        engchgproductcategorydetails,
        engchgproductreleasepolicy,
        engchgproductreadinesspolicy,
        modifieddatetime,
        modifiedby,
        modifiedtransactionid,
        createddatetime,
        createdby,
        createdtransactionid,
        dataareaid,
        recversion,
        partition,
        sysrowversion,
        recid,
        tableid,
        versionnumber,
        createdon,
        modifiedon,
        _fivetran_deleted,
        _fivetran_synced
    from source
)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
