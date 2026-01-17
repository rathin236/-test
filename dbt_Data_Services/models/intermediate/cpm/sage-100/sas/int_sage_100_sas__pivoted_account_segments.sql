select
    accountkey,
    {{
        dbt_utils.pivot(
            'segmentno',
            dbt_utils.get_column_values( ref('int_sage_100_sas__account_segements_descriptions'), 'segmentno' ),
            agg='max',
            prefix='SEGMENT_',
            then_value='subaccountcode',
            else_value='null'
            )
    }},
    {{
        dbt_utils.pivot(
            'segmentno',
            dbt_utils.get_column_values( ref('int_sage_100_sas__account_segements_descriptions'), 'segmentno' ),
            agg='max',
            prefix='SEGMENT_',
            suffix='_DESC',
            then_value='subaccountdesc',
            else_value='null'
            )
    }}
from {{ ref('int_sage_100_sas__account_segements_descriptions') }}
group by accountkey
