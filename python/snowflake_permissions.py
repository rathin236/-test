"""
Snowflake Permissions Manager

This script ensures proper permissions are set for source databases, schemas,
and tables in Snowflake for dbt operations.
"""
import os
import sys
import yaml
from pathlib import Path

try:
    import snowflake.connector
except ImportError:
    print("ERROR: snowflake-connector-python not installed.")
    print("Run: pip install snowflake-connector-python")
    sys.exit(1)


def get_env_var(name: str, required: bool = True) -> str:
    """Get environment variable with optional requirement check."""
    value = os.environ.get(name, "")
    if required and not value:
        print(f"ERROR: Required environment variable {name} is not set.")
        sys.exit(1)
    return value


def get_snowflake_connection():
    """Create a Snowflake connection using environment variables."""
    return snowflake.connector.connect(
        account=get_env_var("SNOWFLAKE_ACCOUNT"),
        user=get_env_var("SNOWFLAKE_USER"),
        password=get_env_var("SNOWFLAKE_PASSWORD"),
        role=get_env_var("SNOWFLAKE_ROLE"),
        warehouse=get_env_var("SNOWFLAKE_WAREHOUSE"),
    )


def parse_sources_yml(file_path: Path) -> list[dict]:
    """Parse a dbt sources.yml file and extract source definitions."""
    sources = []
    try:
        with open(file_path, "r", encoding="utf-8") as f:
            content = yaml.safe_load(f)
            if content and "sources" in content:
                sources = content["sources"]
    except Exception as e:
        print(f"Warning: Could not parse {file_path}: {e}")
    return sources


def find_all_sources(project_dir: str = "hv_edp_dbt") -> list[dict]:
    """Find all source definitions in the dbt project."""
    all_sources = []
    models_dir = Path(project_dir) / "models"
    
    # Find all .yml files in models directory
    for yml_file in models_dir.rglob("*.yml"):
        sources = parse_sources_yml(yml_file)
        all_sources.extend(sources)
    
    # Also check for sources.yml in project root
    sources_file = Path(project_dir) / "models" / "sources.yml"
    if sources_file.exists():
        sources = parse_sources_yml(sources_file)
        all_sources.extend(sources)
    
    return all_sources


def grant_database_permissions(cursor, database: str, role: str):
    """Grant usage permission on a database."""
    print(f"  Granting USAGE on database {database} to {role}...")
    try:
        cursor.execute(f"GRANT USAGE ON DATABASE {database} TO ROLE {role}")
        print(f"  ✅ Granted USAGE on database {database}")
    except Exception as e:
        print(f"  ⚠️ Could not grant on database {database}: {e}")


def grant_schema_permissions(cursor, database: str, schema: str, role: str):
    """Grant usage permission on a schema."""
    print(f"  Granting USAGE on schema {database}.{schema} to {role}...")
    try:
        cursor.execute(f"GRANT USAGE ON SCHEMA {database}.{schema} TO ROLE {role}")
        print(f"  ✅ Granted USAGE on schema {database}.{schema}")
    except Exception as e:
        print(f"  ⚠️ Could not grant on schema {database}.{schema}: {e}")


def grant_table_permissions(cursor, database: str, schema: str, role: str):
    """Grant select permission on all tables in a schema."""
    print(f"  Granting SELECT on all tables in {database}.{schema} to {role}...")
    try:
        cursor.execute(
            f"GRANT SELECT ON ALL TABLES IN SCHEMA {database}.{schema} TO ROLE {role}"
        )
        cursor.execute(
            f"GRANT SELECT ON FUTURE TABLES IN SCHEMA {database}.{schema} TO ROLE {role}"
        )
        print(f"  ✅ Granted SELECT on tables in {database}.{schema}")
    except Exception as e:
        print(f"  ⚠️ Could not grant on tables in {database}.{schema}: {e}")


def grant_view_permissions(cursor, database: str, schema: str, role: str):
    """Grant select permission on all views in a schema."""
    print(f"  Granting SELECT on all views in {database}.{schema} to {role}...")
    try:
        cursor.execute(
            f"GRANT SELECT ON ALL VIEWS IN SCHEMA {database}.{schema} TO ROLE {role}"
        )
        cursor.execute(
            f"GRANT SELECT ON FUTURE VIEWS IN SCHEMA {database}.{schema} TO ROLE {role}"
        )
        print(f"  ✅ Granted SELECT on views in {database}.{schema}")
    except Exception as e:
        print(f"  ⚠️ Could not grant on views in {database}.{schema}: {e}")


def main():
    """Main entry point."""
    print("=" * 60)
    print("Snowflake Permissions Manager")
    print("=" * 60)
    
    # Find all sources
    sources = find_all_sources()
    
    if not sources:
        print("No sources found in dbt project.")
        return
    
    print(f"Found {len(sources)} source definition(s)")
    
    # Get the role to grant permissions to
    target_role = get_env_var("SNOWFLAKE_ROLE", required=False) or "DBT_ROLE"
    print(f"Target role: {target_role}")
    print("=" * 60)
    
    # Connect to Snowflake
    print("Connecting to Snowflake...")
    conn = get_snowflake_connection()
    cursor = conn.cursor()
    
    try:
        # Process each source
        for source in sources:
            source_name = source.get("name", "unknown")
            database = source.get("database", "")
            schema = source.get("schema", source_name)
            
            if not database:
                print(f"⚠️ Skipping source '{source_name}': no database specified")
                continue
            
            print(f"\nProcessing source: {source_name}")
            print(f"  Database: {database}")
            print(f"  Schema: {schema}")
            
            # Grant permissions
            grant_database_permissions(cursor, database, target_role)
            grant_schema_permissions(cursor, database, schema, target_role)
            grant_table_permissions(cursor, database, schema, target_role)
            grant_view_permissions(cursor, database, schema, target_role)
        
        print("\n" + "=" * 60)
        print("✅ Permissions update complete!")
        
    except Exception as e:
        print(f"\n❌ Error: {e}")
        sys.exit(1)
    finally:
        cursor.close()
        conn.close()


if __name__ == "__main__":
    main()
