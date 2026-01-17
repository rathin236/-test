with references_data as (
    select *
    from {{ ref('int_ardoq_references_flattened') }}
),

components as (
    select *
    from {{ ref('int_ardoq_components_flattened') }}
),

workspaces as (
    select *
    from {{ ref('int_ardoq_workspaces_flattened') }}
),

final as (
    select
        references_data.id,
        references_data.created_timestamp,
        references_data.application_url,
        references_data.connection_type,
        references_data.root_workspace,
        work1.wp_name as root_ws,
        references_data.target_workspace,
        work2.wp_name as target_ws,
        references_data.source,
        comp1.comp_name as source_comp,
        references_data.target,
        comp2.comp_name as target_comp,
        references_data.ref_type,
        references_data.capability_team_role,
        right(references_data.business_level_maturity, 1) as sf_maturity
    from references_data

    left join workspaces as work1
        on references_data.root_workspace = work1.id

    left join workspaces as work2
        on references_data.target_workspace = work2.id

    left join components as comp1
        on references_data.source = comp1.id

    left join components as comp2
        on references_data.target = comp2.id
)

select * from final
