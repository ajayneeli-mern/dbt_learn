# dbt Snowflake project

## CI/CD to Google Cloud Composer

Pushing to `main` validates dbt, uploads the DAG plus dbt project into the
Composer `dags/dbt_learn` folder, then triggers the `dbt_build` Airflow DAG.
Pull requests validate only.

One-time setup:

1. Add `airflow/requirements-composer.txt` as a Composer PyPI package and wait
   for the environment update to finish.
2. Create an Airflow connection named `snowflake_dbt`: place the Snowflake user
   in **Login**, password in **Password**, and set **Extra** to
   `{"account":"<account>","warehouse":"<warehouse>","database":"<database>","schema":"<schema>","role":"<optional-role>"}`.
3. Add GitHub repository variables: `GCP_PROJECT_ID`, `COMPOSER_LOCATION`, and
   `COMPOSER_ENVIRONMENT`.
4. Add GitHub secrets: `GCP_WORKLOAD_IDENTITY_PROVIDER` and
   `GCP_SERVICE_ACCOUNT`. The service account needs access to describe Composer,
   write its DAG bucket, and execute Composer Airflow commands.

The workflow uses GitHub-to-Google Workload Identity Federation, so it does not
store a Google service-account key. Set Airflow variable
`dbt_snowflake_connection_id` if your connection has another ID.

## Cloud Build deployment (recommended for a GCP-only setup)

`cloudbuild.yaml` is the equivalent deployment pipeline for a Cloud Build
GitHub trigger. Configure the trigger to run on pushes to `main`, using that
file and these substitution variables:

- `_COMPOSER_ENVIRONMENT`: your Composer environment name
- `_COMPOSER_LOCATION`: its region, for example `asia-south1`

Give the Cloud Build service account permission to get the Composer environment
and write objects to its DAG bucket. The build syncs only
`dags/dbt_learn`, keeping other DAGs untouched. Composer asynchronously copies
the new objects from that bucket, so allow a few minutes after a build completes
before expecting the update to be visible. The DAG is scheduled for 02:00 UTC
daily (`schedule="0 2 * * *"`); edit that cron expression in
`airflow/dags/dbt_build.py` to match your desired schedule.
