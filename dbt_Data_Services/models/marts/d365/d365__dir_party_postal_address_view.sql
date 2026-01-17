{{ config(materialized='table') }}

select *
from {{ ref('int_d365__dir_party_postal_address') }}
