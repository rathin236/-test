{{ codegen.generate_source(
    schema_name = 'monday',
    database_name = 'monday',
    table_names = ['activity_log', 'asset', 'board', 'board_owner', 'board_subscriber', 'board_update', 'board_view', 'columns', 'column_value', 'column_value_item_id', 'column_value_mirror_item', 'groups', 'item', 'item_subscriber', 'person_team', 'reply', 'tags', 'team', 'team_user', 'updates', 'users', 'workspace', 'workspace_owner_subscriber', 'workspace_team_subscriber', 'workspace_user_subscriber'],
    generate_columns = True,
    include_descriptions = True) }}
