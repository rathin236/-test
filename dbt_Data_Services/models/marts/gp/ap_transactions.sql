-- Enabled North America companies as per the business requirement

select distinct *
from (
  {{ dbt_utils.union_relations(
    relations=[
      ref('gp_cafl_ap__transactions'),
      ref('gp_caglp_ap__transactions'),
      ref('gp_cagsf_ap__transactions'),
      ref('gp_cai_ap__transactions'),
      ref('gp_calp_ap__transactions'),
      ref('gp_cap_ap__transactions'),
      ref('gp_casl_ap__transactions'),
      ref('gp_causa_ap__transactions'),
      ref('gp_cos_ap__transactions'),
      ref('gp_culc1_ap__transactions'),
      ref('gp_culc3_ap__transactions'),
      ref('gp_culc4_ap__transactions'),
      ref('gp_gcags_ap__transactions'),
      ref('gp_gmg_ap__transactions'),
      ref('gp_hpi_ap__transactions'),
      ref('gp_kcs_ap__transactions'),
      ref('gp_nb678_ap__transactions'),
      ref('gp_nni_ap__transactions'),
      ref('gp_nns_ap__transactions'),
      ref('gp_rbf_ap__transactions'),
      ref('gp_slgp_ap__transactions'),
      ref('gp_sti_ap__transactions'),
      ref('gp_stusa_ap__transactions'),
      ref('gp_tfc_ap__transactions'),
      ref('gp_tfci_ap__transactions'),
      ref('gp_tnm_ap__transactions'),
      ref('gp_tns_ap__transactions'),
      ref('gp_tnsc_ap__transactions'),
      ref('gp_tnscl_ap__transactions'),
      ref('gp_tnsus_ap__transactions'),
      ref('gp_cpqln_ap__transactions'),
      ref('gp_ci_ap__transactions'),
      ref('gp_cfami_ap__transactions'),
      ref('gp_nb601_ap__transactions'),
      ref('gp_avc_ap__transactions'),
      ref('gp_avch_ap__transactions'),
      ref('gp_dti_ap__transactions'),
      ref('gp_gdvii_ap__transactions'),
      ref('gp_grn_ap__transactions'),
      ref('gp_ndhc_ap__transactions'),
      ref('gp_was_ap__transactions')
    ],
      source_column_name=None,
      exclude=['_dbt_source_relation']
  ) }}
)
