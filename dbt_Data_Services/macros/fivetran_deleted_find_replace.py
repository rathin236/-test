import os

script_directory = os.path.dirname(os.path.abspath(__file__))
repo_directory = os.path.dirname(script_directory)
subdir = r"models\staging\cooke_dev\coolearth"  # Change this as needed
directory = os.path.join(repo_directory, subdir)  # Directory to scan
print(f"Directory to find/replace: {directory}")


def replace_strings_in_sql_files(directory, find_string, replace_string):
    """Finds and replaces strings in multiple files.
    Note that this script must be run locally,
    it wont run in dbt Cloud"""

    for root, _, files in os.walk(directory):
        for file in files:
            if file.endswith(".sql"):
                filepath = os.path.join(root, file)

                print(f"Processing file: {filepath}")

                with open(filepath, "r") as file:
                    content = file.read()

                    new_content = content.replace(find_string, replace_string)

                with open(filepath, "w") as file:
                    file.write(new_content)


find_string = "source('coolearth'"  # String to find
replace_string = "source('coolearth_sb1'"  # String to replace

"""If you want to run this on all subdirectories in 'staging', pass
'script directory as an argument to the 'replace_strings_in_sql_files' function instead"""
replace_strings_in_sql_files(directory, find_string, replace_string)
