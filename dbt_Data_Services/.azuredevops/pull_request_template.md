## Description

[Describe the purpose of this PR and what was changed. If related to a Service Desk ticket or Task, include the ticket/task number.]

## Screenshots

[Include a screenshot of the relevant section of the updated dbt DAG. You can access your version of the DAG by clicking the `Lineage` button in dbt cloud, or running `dbt docs generate` and `dbt docs serve`.]

## Validation

[Include any output that confirms that the models work as expected. This might be a link to an in-development dashboard in Power BI, query results, or test outputs.]

## Checklist

- [ ] Code has been tested in development and works as expected
- [ ] All CI checks are passing (SQLFluff, yamllint, dbt tests)
- [ ] Code changes have been documented
- [ ] Models are materialized appropriately (views vs. tables)
- [ ] Appropriate tests added for new models
- [ ] Snowflake permissions verified (`dbt_data_ops` role should have usage on databases/schema and select on tables/views)

## Deployment Notes

[If applicable, provide any special instructions or considerations for deploying this code to production.]

## Rollback Plan

[If applicable, provide a plan for rolling back this change in case of any issues.]
