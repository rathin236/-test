import os
from snowflake.snowpark import Session


def get_connection_parameters() -> dict:
    """
    Retrieves Snowflake connection parameters from environment variables.

    Returns:
        dict: A dictionary containing the Snowflake connection parameters.
    """
    return {
        "account": os.getenv("ACCOUNT"),
        "user": os.getenv("USER"),
        "password": os.getenv("PASSWORD"),
        "role": "securityadmin",
        "warehouse": "dbt_data_ops_cicd_warehouse",
    }


def get_db_list() -> list:
    """
    Retrieves the list of databases from an environment variable.

    Returns:
        list: A list of database names.
    """
    dbs_string = os.getenv("DB_LIST")
    return dbs_string.split(",") if dbs_string else []


def gen_sql(database: str) -> str:
    """
    Generates Snowflake SQL commands to grant usage and select permissions to the data_ops_admin role for a specified database.

    This function constructs a series of SQL commands that:
    1. Switches to the 'securityadmin' role.
    2. Grants usage permissions on the specified database to the 'data_ops_admin' role.
    3. Grants usage permissions on all current and future schemas within the specified database to the 'data_ops_admin' role.
    4. Grants select permissions on all current and future tables within the specified database to the 'data_ops_admin' role.

    Parameters:
        database (str): The name of the database for which permissions are to be granted.

    Returns:
        str: The generated SQL commands.
    """
    sql = f"""
    USE ROLE securityadmin;
    GRANT USAGE ON DATABASE {database} TO ROLE data_ops_admin;
    GRANT USAGE ON ALL SCHEMAS IN DATABASE {database} TO ROLE data_ops_admin;
    GRANT USAGE ON FUTURE SCHEMAS IN DATABASE {database} TO ROLE data_ops_admin;
    GRANT SELECT ON ALL TABLES IN DATABASE {database} TO ROLE data_ops_admin;
    GRANT SELECT ON FUTURE TABLES IN DATABASE {database} TO ROLE data_ops_admin;
    """
    return sql


def main():
    """
    Main function to connect to Snowflake and execute the generated SQL commands for each database.
    """
    connection_parameters = get_connection_parameters()

    if (
        not connection_parameters["account"]
        or not connection_parameters["user"]
        or not connection_parameters["password"]
    ):
        print("Error: Missing connection parameters.")
        return

    session = Session.builder.configs(connection_parameters).create()
    dbs = get_db_list()

    for db in dbs:
        sql_command = gen_sql(db)
        session.sql(sql_command).collect()
        print(f"The following SQL was executed:\n{sql_command}\n")

    session.close()


if __name__ == "__main__":
    main()
