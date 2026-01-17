def calculate_checksum_digit(sscc: str) -> str:
    """Calculates and concats a checksum digit
    to a 17 character string using modulus 10"""

    sscc = sscc.strip()
    if not sscc:
        return "BAD PALLET HEADER #"

    try:
        digits = [int(d) for d in str(sscc) if d.isdigit()]
        if not digits:
            return "BAD PALLET HEADER #"

        weighted_digits = [(d * 3 if i % 2 == 0 else d) for i, d in enumerate(digits)]
        total_weighted_digits = sum(weighted_digits)
        check_digit = (10 - (total_weighted_digits % 10)) % 10
        return str(sscc) + str(check_digit)

    except (ValueError, TypeError):
        return "BAD PALLET HEADER #"


def model(dbt, session):
    dbt.config(materialized="table", packages=["pandas==1.5.3", "numpy==1.24.3"])
    df = dbt.ref("int_edi_856__gfs_pallet_group")
    df = df.to_pandas()

    df = df.apply(lambda x: x.str.strip() if x.dtype == "object" else x)

    df["SSCC_CHECKSUM"] = df["ID"].apply(calculate_checksum_digit)

    return df
