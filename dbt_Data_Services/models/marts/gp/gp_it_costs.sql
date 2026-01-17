{{config(materialized='table') }}

WITH it_costs AS (
    SELECT * FROM {{ref("int_it_gltransline_posted_trans_currentyear")}}
    UNION ALL
    SELECT * FROM {{ref("int_it_gltransline_posted_trans_historicalyear")}}
)
 
 SELECT * FROM it_costs
 
 