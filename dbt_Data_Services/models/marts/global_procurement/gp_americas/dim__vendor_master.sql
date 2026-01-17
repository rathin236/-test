with kcs_vendor as (
    select *
    from {{ ref('int_kcs__vendor_master') }}
),

tns_vendor as (
    select *
    from {{ ref('int_tns__vendor_master') }}
),

cpqln_vendor as (
    select *
    from {{ ref('int_cpqln__vendor_master') }}
),

all_vendors as (
    select * from kcs_vendor
    union
    select * from tns_vendor
    -- union
    -- select * from cpqln_vendor
)

select * from all_vendors
