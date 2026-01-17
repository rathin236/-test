with alldata as (
    select
        status,
        source,
        company,
        pricelist,
        pricelistid,
        unit,
        amount,
        currency,
        quantsellopt,
        roundpolicy,
        productuid,
        uomscheduleid,
        productid
    from {{ ref('int_d365_crm__crm_new_product_price_list') }}
    union all
    select
        status,
        source,
        company,
        pricelist,
        pricelistid,
        unit,
        amount,
        currency,
        quantsellopt,
        roundpolicy,
        productuid,
        uomscheduleid,
        productid
    from {{ ref('int_d365_crm__crm_product_price_list') }}

)

select * from alldata
order by productid
