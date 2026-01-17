with pds_rebate as (
    select

        inventtransid,
        currencycode,
        sum(pdsstartingrebateamt) over (partition by inventtransid) as pds_starting_rebate_amt

    from {{ ref('stg_d365__pds_rebate_table') }}
)

select * from pds_rebate
