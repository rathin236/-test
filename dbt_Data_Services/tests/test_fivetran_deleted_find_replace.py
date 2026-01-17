from macros.fivetran_deleted_find_replace import replace_strings_in_sql_files
import pytest
import os
from tempfile import TemporaryDirectory
import sys

sys.path.append("..")


@pytest.fixture
def sample_sql_files():
    with TemporaryDirectory() as temp_dir:
        # Create a sample directory structure with SQL files
        root_dir = os.path.join(temp_dir, "sample_dir")
        os.makedirs(root_dir, exist_ok=True)

        file1_path = os.path.join(root_dir, "file1.sql")
        file2_path = os.path.join(root_dir, "subdir", "file2.sql")
        file3_path = os.path.join(root_dir, "subdir", "file3.txt")

        os.makedirs(os.path.dirname(file2_path), exist_ok=True)

        # Create sample SQL files
        with open(file1_path, "w") as file:
            file.write("select * from renamed")

        with open(file2_path, "w") as file:
            file.write("select * from renamed")

        with open(file3_path, "w") as file:
            file.write("Not an SQL file")

        yield root_dir


def test_replace_string_in_sql_files(sample_sql_files):
    # Test case 1: Run the function on the sample directory
    find_string = "select * from renamed"  # String to find
    replace_string = "select * from renamed where coalesce(_fivetran_deleted, false) = false"  # String to replace
    replace_strings_in_sql_files(sample_sql_files, find_string, replace_string)

    # Check if the string replacement is applied correctly in file1.sql
    with open(os.path.join(sample_sql_files, "file1.sql"), "r") as file:
        content = file.read()
        assert (
            "select * from renamed where coalesce(_fivetran_deleted, false) = false"
            in content
        )

    # Check if the string replacement is applied correctly in subdir/file2.sql
    with open(os.path.join(sample_sql_files, "subdir", "file2.sql"), "r") as file:
        content = file.read()
        assert (
            "select * from renamed where coalesce(_fivetran_deleted, false) = false"
            in content
        )

    # Verify that the non-SQL file (file3.txt) is untouched
    with open(os.path.join(sample_sql_files, "subdir", "file3.txt"), "r") as file:
        content = file.read()
        assert "select * from renamed" not in content

    # Test case 2: Test with an empty directory
    empty_dir = os.path.join(sample_sql_files, "empty_dir")
    os.makedirs(empty_dir, exist_ok=True)
    replace_strings_in_sql_files(
        empty_dir, find_string, replace_string
    )  # Should not raise any errors

    # Ensure that the empty directory remains empty
    assert len(os.listdir(empty_dir)) == 0

    # Test case 3: Test with a directory containing no SQL files
    non_sql_dir = os.path.join(sample_sql_files, "non_sql_dir")
    os.makedirs(non_sql_dir, exist_ok=True)
    with open(os.path.join(non_sql_dir, "file.txt"), "w") as file:
        file.write("Some content")
    replace_strings_in_sql_files(
        non_sql_dir, find_string, replace_string
    )  # Should not raise any errors

    # Verify that the non-SQL file remains unchanged
    with open(os.path.join(non_sql_dir, "file.txt"), "r") as file:
        content = file.read()
        assert "select * from renamed" not in content

    # Test case 4: Test with a directory containing files of different extensions
    mixed_ext_dir = os.path.join(sample_sql_files, "mixed_ext_dir")
    os.makedirs(mixed_ext_dir, exist_ok=True)
    with open(os.path.join(mixed_ext_dir, "file1.sql"), "w") as file:
        file.write("select * from renamed")
    with open(os.path.join(mixed_ext_dir, "file2.txt"), "w") as file:
        file.write("some content")
    replace_strings_in_sql_files(
        mixed_ext_dir, find_string, replace_string
    )  # Should not raise any errors

    # Check if the string replacement is applied correctly in file1.sql
    with open(os.path.join(mixed_ext_dir, "file1.sql"), "r") as file:
        content = file.read()
        assert (
            "select * from renamed where coalesce(_fivetran_deleted, false) = false"
            in content
        )

    # Verify that the non-SQL file (file2.txt) remains unchanged
    with open(os.path.join(mixed_ext_dir, "file2.txt"), "r") as file:
        content = file.read()
        assert "select * from renamed" not in content
