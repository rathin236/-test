from models.marts.edi.edi_856.edi_856_pallet_group_sscc import calculate_checksum_digit

import pytest
import sys

sys.path.append("..")


@pytest.mark.parametrize(
    "sscc_code, expected_output",
    [
        ("00006767010358834", "000067670103588344"),
        ("00006767010358835", "000067670103588351"),
        ("00006767010358839", "000067670103588399"),
        ("00006767010358841", "000067670103588412"),
        ("", "BAD PALLET HEADER #"),
    ],
)
def test_checksum(sscc_code, expected_output):
    """This function confirms that the provided inputs
    produce the correct output for the checksum function"""
    assert calculate_checksum_digit(sscc_code) == expected_output
