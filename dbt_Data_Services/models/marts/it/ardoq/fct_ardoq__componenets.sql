with components as (
    select *
    from {{ ref('int_ardoq_components_flattened') }}
),

level1 as (
    select *
    from components
    where type_id = 'p1709545611106'
        and component_level = '2'
),

level2 as (
    select *
    from components
    where component_level = '3'
),

level3 as (
    select *
    from components
    where component_level = '4'
),

final as (
    select
        level1.comp_name as level1,
        level1.id as level1_id,
        level2.comp_name as level2,
        level2.id as level2_id,
        level3.comp_name as level3,
        level3.id as level3_id,
        level3.maturity,
        level3.approved,
        level1.description as l1_desc,
        level2.description as l2_desc,
        level3.description as l3_des,
        level3.top_level_parent as top_level_parent_all,
        level3.parent,
        components.comp_name as company_name,
        level3.root_workspace
    from level3

    left join level2
        on level3.parent = level2.id

    left join level1
        on level2.parent = level1.id

    left join components
        on level1.parent = components.id

)

select * from final
