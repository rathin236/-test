select * from {{ ref('int_tns__po_in_line') }}

union all

select * from {{ ref('int_cai__po_in_line') }}

union all

select * from {{ ref('int_kcs__po_in_line') }}

union all

select * from {{ ref('int_causa__po_in_line') }}

union all

select * from {{ ref('int_ci__po_in_line') }}

union all

select * from {{ ref('int_gmg__po_in_line') }}

union all

select * from {{ ref('int_nni__po_in_line') }}

union all

select * from {{ ref('int_sti__po_in_line') }}

union all

select * from {{ ref('int_ndhc__po_in_line') }}

union all

select * from {{ ref('int_tnsc__po_in_line') }}

union all

select * from {{ ref('int_avc__po_in_line') }}