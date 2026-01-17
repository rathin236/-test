{{ config(materialized='table') }}

select * from {{ ref('int_d365__default_dimension_view') }}