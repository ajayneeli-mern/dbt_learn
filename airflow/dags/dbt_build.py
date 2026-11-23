"""Run this repository's dbt project in Cloud Composer."""

from __future__ import annotations

import json
import shutil
import subprocess
import tempfile
from datetime import datetime
from pathlib import Path

from airflow import DAG
from airflow.hooks.base import BaseHook
from airflow.models import Variable
from airflow.operators.python import PythonOperator

DAG_ID = "dbt_build"
PROJECT_DIRECTORY = Path(__file__).parent / "dbt_project"
SNOWFLAKE_CONN_ID = "snowflake_dbt"


def run_dbt_build() -> None:
    """Create a transient dbt profile from the Composer Snowflake connection."""
    if shutil.which("dbt") is None:
        raise RuntimeError("dbt is not installed in Composer; configure airflow/requirements-composer.txt as PyPI packages first.")
    connection = BaseHook.get_connection(Variable.get("dbt_snowflake_connection_id", default_var=SNOWFLAKE_CONN_ID))
    extra = connection.extra_dejson
    values = {"account": extra.get("account") or connection.host, "user": connection.login, "password": connection.password, "warehouse": extra.get("warehouse"), "database": extra.get("database"), "schema": extra.get("schema")}
    missing = [name for name, value in values.items() if not value]
    if missing:
        raise ValueError("The Composer connection is missing: " + ", ".join(missing))
    if extra.get("role"):
        values["role"] = extra["role"]
    profile = {"snowflake_project": {"target": "prod", "outputs": {"prod": {"type": "snowflake", "threads": 4, **values}}}}
    with tempfile.TemporaryDirectory(prefix="dbt-build-") as temporary_directory:
        workspace = Path(temporary_directory) / "project"
        shutil.copytree(PROJECT_DIRECTORY, workspace)
        profiles_dir = Path(temporary_directory) / "profiles"
        profiles_dir.mkdir()
        (profiles_dir / "profiles.yml").write_text(json.dumps(profile), encoding="utf-8")
        base_command = ["dbt", "--project-dir", str(workspace), "--profiles-dir", str(profiles_dir)]
        subprocess.run([*base_command, "deps"], check=True)
        subprocess.run([*base_command, "build", "--target", "prod"], check=True)


with DAG(dag_id=DAG_ID, description="Build and test the dbt Snowflake project after deployment.", start_date=datetime(2024, 1, 1), schedule="0 2 * * *", catchup=False, tags=["dbt", "snowflake"]) as dag:
    PythonOperator(task_id="dbt_build", python_callable=run_dbt_build)
