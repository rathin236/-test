-- Enabled North America companies as per the business requirement

with cafl_ar_transactions as (
    select * from {{ ref('gp_cafl_ar__transactions') }}
),

caglp_ar_transactions as (
    select * from {{ ref('gp_caglp_ar__transactions') }}
),

cagsf_ar_transactions as (
    select * from {{ ref('gp_cagsf_ar__transactions') }}
),

cai_ar_transactions as (
    select * from {{ ref('gp_cai_ar__transactions') }}
),

calp_ar_transactions as (
    select * from {{ ref('gp_calp_ar__transactions') }}
),

cap_ar_transactions as (
    select * from {{ ref('gp_cap_ar__transactions') }}
),

casl_ar_transactions as (
    select * from {{ ref('gp_casl_ar__transactions') }}
),

causa_ar_transactinos as (
    select * from {{ ref('gp_causa_ar__transactions') }}
),

cos_ar_transactions as (
    select * from {{ ref('gp_cos_ar__transactions') }}
),

culc1_ar_transactions as (
    select * from {{ ref('gp_culc1_ar__transactions') }}
),

culc3_ar_transactions as (
    select * from {{ ref('gp_culc3_ar__transactions') }}
),

culc4_ar_transactions as (
    select * from {{ ref('gp_culc4_ar__transactions') }}
),

gcags_ar_transactions as (
    select * from {{ ref('gp_gcags_ar__transactions') }}
),

gmg_ar_transactions as (
    select * from {{ ref('gp_gmg_ar__transactions') }}
),

hpi_ar_transactions as (
    select * from {{ ref('gp_hpi_ar__transactions') }}
),

-- hsi_ar_transactions as (
--     select * from {{ ref('gp_hsi_ar__transactions') }}
-- ),

kcs_ar_transactions as (
    select * from {{ ref('gp_kcs_ar__transactions') }}
),

nb678_ar_transactions as (
    select * from {{ ref('gp_nb678_ar__transactions') }}
),

nni_ar_transactions as (
    select * from {{ ref('gp_nni_ar__transactions') }}
),

nns_ar_transactions as (
    select * from {{ ref('gp_nns_ar__transactions') }}
),

rbf_ar_transactions as (
    select * from {{ ref('gp_rbf_ar__transactions') }}
),

slgp_ar_transactions as (
    select * from {{ ref('gp_slgp_ar__transactions') }}
),

sti_ar_transactions as (
    select * from {{ ref('gp_sti_ar__transactions') }}
),

stusa_ar_transactions as (
    select * from {{ ref('gp_stusa_ar__transactions') }}
),

tfc_ar_transactions as (
    select * from {{ ref('gp_tfc_ar__transactions') }}
),

tfci_ar_transactions as (
    select * from {{ ref('gp_tfci_ar__transactions') }}
),

tnm_ar_transactions as (
    select * from {{ ref('gp_tnm_ar__transactions') }}
),

tns_ar_transactions as (
    select * from {{ ref('gp_tns_ar__transactions') }}
),

tnsc_ar_transactions as (
    select * from {{ ref('gp_tnsc_ar__transactions') }}
),

tnscl_ar_transactions as (
    select * from {{ ref('gp_tnscl_ar__transactions') }}
),

tnsus_ar_transactions as (
    select * from {{ ref('gp_tnsus_ar__transactions') }}
),

cpqln_ar_transactions as (
    select * from {{ ref('gp_cpqln_ar__transactions') }}
),

ci_ar_transactions as (
    select * from {{ ref('gp_ci_ar__transactions') }}
),

cfami_ar_transactions as (
    select * from {{ ref('gp_cfami_ar__transactions') }}
),

nb601_ar_transactions as (
    select * from {{ ref('gp_nb601_ar__transactions') }}
),
avc_ar_transactions as(
    select * from {{ ref('gp_avc_ar__transactions') }}
),
avch_ar_transactions as(
    select * from {{ ref('gp_avch_ar__transactions') }}
),
dti_ar_transactions as(
    select * from {{ ref('gp_dti_ar__transactions') }}
),
gdvii_ar_transactions as(
    select * from {{ ref('gp_gdvii_ar__transactions') }}
),
grn_ar_transactions as(
    select * from {{ ref('gp_grn_ar__transactions') }}
),
ndhc_ar_transactions as(
    select * from {{ ref('gp_ndhc_ar__transactions') }}
),
was_ar_transactions as(
    select * from {{ ref('gp_was_ar__transactions') }}
)


select * from cafl_ar_transactions

union

select * from caglp_ar_transactions

union

select * from cagsf_ar_transactions

union

select * from cai_ar_transactions

union

select * from calp_ar_transactions

union

select * from cap_ar_transactions

union

select * from casl_ar_transactions

union

select * from causa_ar_transactinos

union

select * from cos_ar_transactions

union

select * from culc1_ar_transactions

union

select * from culc3_ar_transactions

union

select * from culc4_ar_transactions

union

select * from gcags_ar_transactions

union

select * from gmg_ar_transactions

union

select * from hpi_ar_transactions

union

-- select * from hsi_ar_transactions

-- union

select * from kcs_ar_transactions

union

select * from nb678_ar_transactions

union

select * from nni_ar_transactions

union

select * from nns_ar_transactions

union

select * from rbf_ar_transactions

union

select * from slgp_ar_transactions

union

select * from sti_ar_transactions

union

select * from stusa_ar_transactions

union

select * from tfc_ar_transactions

union

select * from tfci_ar_transactions

union

select * from tnm_ar_transactions

union

select * from tns_ar_transactions

union

select * from tnsc_ar_transactions

union

select * from tnscl_ar_transactions

union

select * from tnsus_ar_transactions

union

select * from cpqln_ar_transactions

union

select * from ci_ar_transactions

union

select * from cfami_ar_transactions

union

select * from nb601_ar_transactions

union

select * from avc_ar_transactions

union

select * from avch_ar_transactions

union

select * from dti_ar_transactions

union

select * from gdvii_ar_transactions

union

select * from grn_ar_transactions

union

select * from ndhc_ar_transactions

union

select * from was_ar_transactions
