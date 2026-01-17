with gp_vendors as (

  {{ dbt_utils.union_relations(
    relations=[
      ref('int_global_ap__gp_gmg_vendors'),
      ref('int_global_ap__gp_kcs_vendors'),
      ref('int_global_ap__gp_tns_vendors'),
      ref('int_global_ap__gp_cai_vendors'),
      ref('int_global_ap__gp_nb601_vendors'),
      ref('int_global_ap__gp_bhfc_vendors'),
      ref('int_global_ap__gp_nb681_vendors'),
      ref('int_global_ap__gp_cos_vendors'),
      ref('int_global_ap__gp_ci_vendors'),
      ref('int_global_ap__gp_hpi_vendors'),
      ref('int_global_ap__gp_nni_vendors'),
      ref('int_global_ap__gp_sti_vendors'),
      ref('int_global_ap__gp_slgp_vendors'),
      ref('int_global_ap__gp_tnsc_vendors'),
      ref('int_global_ap__gp_cap_vendors'),
      ref('int_global_ap__gp_causa_vendors'),
      ref('int_global_ap__gp_tfc_vendors'),
      ref('int_global_ap__gp_stusa_vendors'),
      ref('int_global_ap__gp_tnm_vendors'),
      ref('int_global_ap__gp_gdvii_vendors'),
      ref('int_global_ap__gp_ndhc_vendors'),
      ref('int_global_ap__gp_tfci_vendors'),
      ref('int_global_ap__gp_tnsus_vendors'),
      ref('int_global_ap__gp_wvcl_vendors'),
      ref('int_global_ap__gp_cph_vendors'),
      ref('int_global_ap__gp_avc_vendors'),
      ref('int_global_ap__gp__dim_vendors')
    ],
      source_column_name=None,
      exclude=['_dbt_source_relation']
  ) }}

),

vendor_sort as (
    select
        *,
        case
            when vendor_type = 'Trade' then 1
            when vendor_type = 'Related Party' then 2
            when vendor_type = 'Inter Company' then 3
            when vendor_type = 'SCF Vendor' then 4
        end as vendor_type_sort
    from gp_vendors
)

select * from vendor_sort
